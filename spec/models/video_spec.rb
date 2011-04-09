require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Video do

  fixtures :channels

  context "instance with kind and language value" do

    subject { @video }

    before(:each) do
      @show  = Factory(:show, :name => "TeesMarkhan")
      @video = Factory(:video, :name => "sheilaki", :kind => "lyric")
    end

    it "should update channel that it belongs" do
      subject.language = "hindi"
      subject.save

      subject.channel_id.should eql(channels(:hindi_lyrics).id)
    end
  end

  context "#associations" do
    before(:each) { Factory(:video, :youtube_id => "12") }
    it { should belong_to(:show)   }
    it { should belong_to(:feed)   }
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

  context "#validations" do
    subject { Factory(:video, :youtube_id => "12") }
    it { should validate_presence_of(:youtube_id)   }
    it { should validate_uniqueness_of(:youtube_id) }
    it { should validate_presence_of(:name)        }

    it { should allow_value('telugu').for(:language) }
    it { should allow_value('hindi').for(:language) }
    it { should allow_value(nil).for(:language) }

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
      video = Factory(:telugu_video, :kind => "song")
      video.tag_list.should include('song')
    end

    it "should update tag on kind" do
      video = Factory(:telugu_video, :kind => "song")
      video.tag_list.should include('song')

      video.update_attributes(:kind => 'lyric')

      video.tag_list.should include('lyric')
      video.tag_list.should_not include('song')
    end

    it "should create tag on quality of video" do
      video = Factory(:hd_video)
      video.tag_list.should include('hd')
    end

    it "should create tag on show name" do
      video = Factory(:hd_video)
      video.tag_list.should include(video.show.name)
    end

    it "should update tag on show name" do
      video = Factory(:hd_video)
      first = video.show
      video.tag_list.should include(first.name)
      second = Factory(:show)
      video.show = second
      video.save

      video.tag_list.should_not include(first.name)
      video.tag_list.should include(second.name)
    end

    it "should update tag on quality" do
      video = Factory(:telugu_video, :quality => "hd")
      video.tag_list.should include('hd')

      video.update_attributes(:quality => 'medium')

      video.tag_list.should include('medium')
      video.tag_list.should_not include('hd')
    end

    it "should append to tags on language" do
      video = Factory(:hindi_video, :tag_list => "hulchul, video song")
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

  context "#to-param" do
    it "include name of the video" do
      video = Video.new(:name => "something")
      video.should_receive(:id).and_return(23)
      video.to_param.should eql("23-something")
    end

    it "return id of the video if any exception raises" do
      video = Video.new
      name = double()
      name.should_receive(:parameterize).and_raise(Exception)
      video.stub(:id).and_return(23)
      video.stub(:name).and_return(name)

      video.to_param.should eql("23")
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

    context "#in_admin_queue" do
      it "return all unapproved alive videos when argument is nil" do
        Video.in_admin_queue('all').map(&:id).should =~ [ @video2.id, @video4.id ]
      end
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
        Video.approved.map(&:id).should =~ [@video1.id, @video3.id]
      end
    end

    context "unapproved" do
      it "returns all videos which are un approved" do
        Video.unapproved.map(&:id).should =~ [@video2.id, @video4.id]
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

    its(:youtube_id) { should eql("12344") }
    its(:view_count) { should eql(24) }
    its(:rating) { should eql(2.4) }
    its(:racy) { should eql(true) }
    its(:category) { should eql("news") }
    its(:name) { should eql("mytitle") }
    its(:keywords) { should =~ %w(tv9 telugu) }
    its(:published_at) { should eql("1/12/2009".to_date) }
    its(:description) { should eql("custom description") }
  end
  context "Video class when queried for tags" do
    before(:each) do
      @show = Factory(:show, :name => "teesmarkhan")
      @video = Factory(:video, :name => "sheila ke", :kind => "song", :show => @show, :approved => true)
      @video = Factory(:video, :name => "trailer01", :kind => "trailer", :show => @show, :approved => true)
    end

    it "should return tags containing 'shakti'" do
      Video.containing_tag("shei").should eql([{:label => "sheila ke", :category => ""}])
    end

    it "should return tags containing 'shakti' and also all possible tags" do
      pending do
        Video.containing_tag("teesmar").should eql([{:label => "song", :category => "teesmarkhan"}, {:label => "trailer", :category => "teesmarkhan"}])
      end
    end
  end
end
