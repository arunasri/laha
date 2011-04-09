require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Feed do

  context "validations" do
    subject { Factory(:feed) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:default_channel_id) }
    it { should validate_uniqueness_of(:name) }
    it { should belong_to(:default_channel) }
  end

  context "add_youtube_video" do
    subject {  Factory(:feed) }

    it "should return false if video is already added by feed" do
      video = Factory(:video, :feed => subject)
      video.should_receive(:unique_id).and_return(video.youtube_id)

      subject.add_youtube_video(video).should be_false
    end

    it "should return false if video is already in the system" do
      video = Factory(:video)
      video.should_receive(:unique_id).and_return(video.youtube_id)

      subject.add_youtube_video(video).should be_false
    end

    it "should add video to the system if it is not in the system" do
      video = Factory.build(:video)
      video.stub(:unique_id).and_return(video.youtube_id)
      video.should_receive(:rating).and_return(nil)
      video.should_receive(:title).and_return(video.name)
      video.should_receive(:categories).and_return([double(:term => "News")])

      subject.add_youtube_video(video).should be_true
    end

    it "should set default_channel as video channel to newly added video" do
      video = Factory.build(:video)
      video.stub(:unique_id).and_return(video.youtube_id)
      video.should_receive(:rating).and_return(nil)
      video.should_receive(:title).and_return(video.name)
      video.should_receive(:categories).and_return([double(:term => "News")])

      added = subject.add_youtube_video(video)
      added.language.should eql(subject.default_channel.language)
    end
  end

  context "alreay_added?" do
    before(:each) do
      @feed = Factory(:feed)
      @v1 = Factory(:video, :feed => @feed).youtube_id
      @v2 = Factory(:video).youtube_id
      @v3 = Factory(:video, :feed => @feed).youtube_id
      @v4 = Factory(:video).youtube_id
    end

    it "should detect passed video belong to feed" do
      @feed.should be_already_added([@v1, @v3])
    end

    it "should detect any passed video belong to feed" do
      @feed.should be_already_added([@v1, @v2])
    end

    it "should fail all passed video does not belong to feed" do
      @feed.should_not be_already_added([@v4, @v2])
    end
  end
end
