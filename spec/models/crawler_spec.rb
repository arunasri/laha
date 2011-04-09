require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Crawler do

  context "#crawl" do
    it "should search using feed user name" do
      crawler = Crawler.new(Feed.new(:name => 'tv9telugu'))
      client = mock()
      client.should_receive(:videos_by).with(:user => 'tv9telugu', :page => 1).and_return('videos')
      crawler.should_receive(:client).and_return(client)

      crawler.crawl.should eql("videos")
    end
  end

  context "load_result" do
    subject { Crawler.new(Feed.new(:name => 'tv9telugu')) }

    it "should force crawler to query youtube if results are not set" do
      subject.should_receive(:crawl).and_return('fresh')
      subject.load_result.should eql('fresh')
    end

    it "should return current search results" do
      subject.instance_eval { @result = 'old' }
      subject.load_result.should eql('old')
    end
  end

  context "#add_videos" do
    subject { @crawler }

    before(:each) do
      @feed    = Feed.new
      @crawler = Crawler.new(@feed)
    end

    it "should add videos to feed" do
      y1 = double()
      y2 = double()

      @feed.should_receive(:add_youtube_video).with(y1).and_return(true)
      @feed.should_receive(:add_youtube_video).with(y2).and_return(true)
      subject.should_receive(:videos).and_return([y1, y2])

      subject.process!
    end

    it "should keep track of failed videos in the current result set" do
      y1 = double(:unique_id => '23')
      y2 = double()

      @feed.should_receive(:add_youtube_video).with(y1).and_return(false)
      @feed.should_receive(:add_youtube_video).with(y2).and_return(true)
      subject.should_receive(:load_result).and_return(double(:videos => [y1, y2]))

      subject.process!

      subject.failed.should =~ ['23']
    end
  end

  context "#end_of_feed?" do
    subject { Crawler.new(Feed.new(:name => 'tv9telugu')) }

    it "return true when crawler gets less than 25 videos" do
      results = mock(:videos => mock(:length => 24))
      subject.should_receive(:load_result).and_return(results)

      subject.should be_end_of_feed
    end

    it "return false when crawler gets less than 25 videos" do
      results = mock(:videos => mock(:length => 25))
      subject.should_receive(:load_result).and_return(results)

      subject.should_not be_end_of_feed
    end
  end

  context "#next?" do

    subject { Crawler.new(Feed.new(:name => 'tv9telugu')) }
    before(:each) { subject.should_receive(:already_processed?).and_return(false) }

    it "should return false when end of feed reached" do
      subject.should_receive(:end_of_feed?).and_return(true)
      subject.should_not be_next
    end

    it "should return true when videos left in the feed" do
      subject.should_receive(:end_of_feed?).and_return(false)
      subject.should be_next
    end
  end

  context "#already_processed?" do
    before(:each) do
      @feed    = Factory(:feed, :processed => true)
      @crawler = Crawler.new(@feed)
      @crawler.should_receive(:process!)
    end

    it "should be true if feed is processed and failed videos include last_updated_video of the feed" do
      @feed.should_receive(:already_added?).with([1,2,3,4]).and_return(true)
      @crawler.should_receive(:failed).and_return([1,2,3, 4])

      @crawler.should be_already_processed
    end

    it "should be false if feed is processed and failed videos does not include last_updated_video of the feed" do
      @feed.should_receive(:already_added?).with([1,2,3]).and_return(false)
      @crawler.should_receive(:failed).and_return([1,2,3])

      @crawler.should_not be_already_processed
    end

    it "should be false if feed is not processed and some videos are not added" do
      @crawler.should_not be_already_processed
    end

    it "should be false if feed is processed and all videos are added" do
      @feed.processed = false
      @crawler.should_not be_already_processed
    end
  end

  context "#next!" do

    subject { @crawler = Crawler.new(Feed.new(:name => 'tv9telugu')) }

    it "should increase page number and reset result when succeds" do
      subject.should_receive(:next?).and_return(true)
      subject.should_receive(:reset).and_return(true)

      subject.next!
      subject.page.should eql(2)
    end

    it "should not increase page number nor reset result when fails" do
      subject.should_receive(:next?).and_return(false)
      subject.should_receive(:reset).never

      subject.next!
      subject.page.should eql(1)
    end
  end

  context "#reset" do
    subject { @crawler = Crawler.new(Feed.new(:name => 'tv9telugu')) }
    before(:each)   { subject.reset   }
    its(:failed)    { should be_blank }
    its(:processed) { should be_false }
    its(:result)    { should be_nil   }
  end
end
