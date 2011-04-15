require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Video do

  context "#youtube id extractor" do

    it "should get when url format is http://www.youtube.com/watch?v=id" do
      video = Video.new(:url => "http://www.youtube.com/watch?v=234")
      video.send(:extract_youtube_id).should eql("234")
    end

    it "should get when url format is http://www.youtube.com/user/IleanaDCruzTV#p/a/u/2/12a" do
      video = Video.new(:url => "http://www.youtube.com/user/IleanaDCruzTV#p/a/u/2/12a")
      video.send(:extract_youtube_id).should eql("12a")
    end

  end

  context "when invalid url format is given" do
    subject { Factory(:video) }

    it "should raise error" do
      subject.url = "ksdf"
      subject.should_not be_valid
    end

    it "should raise with invalid video id" do
      subject.url = "http://www.youtube.com/user/IleanaDCruzTV#p/a/u/2/12a"
      client = double()
      client.should_receive(:video_by).with("12a").and_return(nil)
      Crawler.should_receive(:client).and_return(client)

      subject.should_not be_valid
    end
  end

  context "#associations" do
    before(:each) { Factory(:video, :youtube_id => "12") }
    it { should belong_to(:show)   }
    it { should belong_to(:feed)   }
  end

  context "when deleted" do
    before(:each) { Factory(:video, :approved => true, :deleted => true, :youtube_id => "12") }
    its("tag_list.size") { should eql(0) }
    its(:approved) { should eql(false) }
  end

  context "#know?" do
    it "should return false if youtube video not in system" do
      youtube = double(:unique_id => Factory.build(:video).youtube_id)
      Video.should_not be_know(youtube)
    end

    it "should return true if youtube video in system" do
      youtube = double(:unique_id => Factory(:video).youtube_id)
      Video.should be_know(youtube)
    end
  end

  context "#validations when approved" do
    subject { Factory(:video, :youtube_id => "12", :approved => true) }
    it { should validate_presence_of(:youtube_id)   }
    it { should validate_uniqueness_of(:youtube_id) }
    it { should validate_presence_of(:name)        }

    it { should allow_value('telugu').for(:language) }
    it { should allow_value('hindi').for(:language) }

    it { should_not allow_value('english').for(:language) }
    it { should_not allow_value('tamil').for(:language) }
    it { should_not allow_value('kannada').for(:language) }
    it { should_not allow_value('marathi').for(:language) }

    it { should allow_value('hd').for(:quality) }
    it { should allow_value('high').for(:quality) }
    it { should allow_value('medium').for(:quality) }
    it { should allow_value('low').for(:quality) }

    it { should allow_value('lyric').for(:kind) }
    it { should allow_value('song').for(:kind) }
    it { should allow_value('trailer').for(:kind) }
    it { should allow_value('movie').for(:kind) }

    it { should_not allow_value('dfaudio').for(:kind) }
    it { should_not allow_value('vid').for(:kind) }
  end

  context "#callbacks" do

    it "should not create any tags for unapproved" do
      video = Factory(:telugu_video, :approved => false)
      video.tag_list.should be_empty
    end

    it "should remove all tags when disapproved" do
      video = Factory(:telugu_video, :approved => true)
      video.tag_list.should_not be_empty

      video.update_attributes(:approved => false)
      video.tag_list.should be_empty
    end

    it "should create tag on language" do
      video = Factory(:telugu_video, :approved => true)
      video.tag_list.should include('telugu')
    end

    it "should not create tags for unapproved videos" do
      video = Factory(:video, :language => 'telugu',:approved => false)
      video.tag_list.should_not include('telugu')
    end

    it "should create tags for approved videos after approval" do
      video = Factory(:video, :language => 'telugu',:approved => false)
      video.tag_list.should_not include('telugu')
      video.update_attributes(:approved => true)

      video.tag_list.should include('telugu')
    end

    it "should update tag on language" do
      video = Factory(:video, :language => 'telugu',:approved => true)
      video.tag_list.should include('telugu')

      video.update_attributes(:language => 'hindi')

      video.tag_list.should include('hindi')
      video.tag_list.should_not include('telugu')
    end

    it "should create tag on kind" do
      video = Factory(:approved_video, :kind => "song")
      video.tag_list.should include('song')
    end

    it "should update tag on kind" do
      video = Factory(:approved_video, :kind => "song")
      video.tag_list.should include('song')

      video.update_attributes(:kind => 'lyric')

      video.tag_list.should include('lyric')
      video.tag_list.should_not include('song')
    end

    it "should create tag on quality of video" do
      video = Factory(:hd_video, :approved => true, :quality => 'hd')
      video.tag_list.should include('hd')
    end

    it "should create tag on show name" do
      video = Factory(:approved_video)
      video.tag_list.should include(video.show.name)
    end

    it "should update tag on show name" do
      video = Factory(:approved_video)
      first = video.show
      video.tag_list.should include(first.name)
      second = Factory(:show)
      video.show = second
      video.save

      video.tag_list.should_not include(first.name)
      video.tag_list.should include(second.name)
    end

    it "should update tag on quality" do
      video = Factory(:approved_video, :quality => "hd")
      video.tag_list.should include('hd')

      video.update_attributes(:quality => 'medium')

      video.tag_list.should include('medium')
      video.tag_list.should_not include('hd')
    end

    it "should append to tags on language" do
      video = Factory(:hindi_video, :approved => true, :tag_list => "hulchul, video song")
      video.tag_list.should include('hindi', 'hulchul','video song')
    end
  end

  context "instance methods" do
    subject { Factory(:video, :youtube_id => "12", :name => "lovethis") }

    its(:default_thumbnail) { should eql("http://i2.ytimg.com/vi/12/default.jpg") }
    its(:player_url)        { should eql("http://www.youtube.com/v/12&autoplay=1") }
    its(:embed_url)         { should eql("http://www.youtube.com/v/12&feature=youtube_gdata_player") }
    its(:bare_url)          { should eql("http://www.youtube.com/watch?v12") }

    it "will set deleted flag to true" do
      subject.delete!
      subject.delete.should be_true
    end
  end

  context "#next video" do
    before(:each) do
      @video1 = Factory(:approved_video, :youtube_id => "1", :published_at => "1/1/2009", :deleted => false)
      @video2 = Factory(:rejected_video, :youtube_id => "2", :published_at => "2/1/2009", :deleted => false)
      @video3 = Factory(:deleted_video, :youtube_id => "3", :published_at => "3/1/2008",  :approved => true)
      @video4 = Factory(:deleted_video, :youtube_id => "4", :published_at => "5/1/2010",  :approved => false)
    end
  end

  context "#scope" do
    before(:each) do
      @video1 = Factory(:approved_video, :youtube_id => "1", :published_at => "1/1/2009", :deleted => true)
      @video2 = Factory(:rejected_video, :youtube_id => "2", :published_at => "2/1/2009", :deleted => false)
      @video3 = Factory(:deleted_video, :youtube_id => "3", :published_at => "3/1/2008",  :approved => true)
      @video4 = Factory(:live_video, :youtube_id => "4", :published_at => "5/1/2010",     :approved => false)
    end

    context "alive" do
      it "returns all videos which are not deleted" do
        Video.alive.map(&:id).should =~ [@video2.id, @video4.id]
      end
    end

    context "deleted" do
      it "returns all videos which are deleted" do
        Video.deleted.map(&:id).should =~ [@video1.id, @video3.id]
      end
    end

    context "approved" do
      it "returns all videos which are approved" do
        Video.approved.map(&:id).should be_empty
      end
    end

    context "unapproved" do
      it "returns all videos which are un approved" do
        Video.unapproved.map(&:id).should =~ [@video1.id, @video2.id, @video3.id, @video4.id]
      end
    end

    context "after" do
      it "return all videos published after given date" do
        Video.after("2/2/2009").map(&:id).should =~ [@video4.id]
      end
    end

    context "before" do
      it "return all videos published before given date" do
        Video.before("2/2/2009").map(&:id).should =~ [@video1.id, @video2.id, @video3.id]
      end
    end
  end

  context "#assign_youtube_attributes" do
    subject { Video.new }
    before(:each) do
      youtube = double()
      youtube.stub(:unique_id).and_return("12344")
      youtube.stub(:title).and_return("mytitle")
      youtube.stub(:description).and_return("custom description")
      youtube.stub(:racy).and_return(true)
      youtube.stub(:view_count).and_return(24)
      youtube.stub(:rating).and_return(double(:average => 2.4))
      youtube.stub(:categories).and_return([double(:term => "news")])
      youtube.stub(:duration).and_return(124)
      youtube.stub(:keywords).and_return(%w(tv9 telugu))
      youtube.stub(:published_at).and_return("1/12/2009")

      subject.assign_youtube_attributes(youtube)
    end

    its(:youtube_id)    { should eql("12344") }
    its(:view_count)    { should eql(24) }
    its(:rating)        { should eql(2.4) }
    its(:racy)          { should eql(true) }
    its(:category)      { should eql("news") }
    its(:name)          { should eql("mytitle") }
    its(:keywords)      { should =~ %w(tv9 telugu) }
    its(:published_at)  { should eql("1/12/2009".to_date) }
    its(:description)   { should eql("custom description") }
  end
end
