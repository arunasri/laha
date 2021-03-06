require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Show do

  context "#when data is set and synced" do
    subject { @show }
    before(:each) do
      @show = Show.new({
        :language => 'telugu',
        :data     => File.open("#{Rails.root}/spec/fixtures/html/raaga.html").read
      })
      @show.sync
      @show.save
      @show.reload
    end

    it "should create 8 lyrics" do
      @show.lyrics.length.should eql(8)
    end

    it "should create 8 video songs" do
      @show.songs.length.should eql(8)
    end

    it "should create 8 videos" do
      @show.videos.length.should eql(16)
    end

    its(:name)      { should eql("100% Love") }
    its(:year) { should eql(2011) }
    its(:cast) { should eql("Naga Chaitanya, Tamanna ") }
    its(:music_director) { should eql("Devi Sri Prasad") }
    its("songs.length") { should eql(8) }

    context "for first song" do
      subject       { @show.songs.to_ary[0] }
      its(:language){ should eql('telugu') }
      its(:name)    { should eql("Infatuation") }
      its(:singers) { should eql("Adnan Sami") }
      its(:writer)  { should eql("Chandrabose") }
      its(:approved){ should eql(false) }
    end

    context "for second song" do
      subject       { @show.songs.to_ary[1] }
      its(:language){ should eql('telugu') }
      its(:name)    { should eql("Thiru Thiru Gananadha") }
      its(:singers) { should eql("Harini") }
      its(:writer)  { should eql("Rama Jhogaya Sastry") }
      its(:approved){ should eql(false) }
    end

    context "for last song" do
      subject       { @show.songs.last }
      its(:language){ should eql('telugu') }
      its(:name)    { should eql("Diyalo Diyala") }
      its(:singers) { should eql("Priya Hemesh, Murali") }
      its(:writer)  { should eql("Chandrabose") }
      its(:approved){ should eql(false) }
    end
  end

  context "#when url is set" do
    it "should load web page into data" do
      show = Show.new(:url => "some url")
      show.should_receive(:load_page).with("some url").and_return('data')
      show.should_receive(:sync)
      show.save

      show.data.should eql('data')
    end

    it "should not load web page into data for existing record" do
      show = Factory(:show)
      show.url="some url"
      show.should_receive(:load_page).with("some url").never
      show.save

      show.data.should be_nil
    end
  end

  context "#scopes" do
    it "should determine movies released in year 2009" do
      show1 = Factory(:show, :started_on => "1/1/2009")
      show2 = Factory(:show, :started_on => "3/1/2009")
      show3 = Factory(:show, :started_on => "1/1/2008")

      result = Show.released_in_year(2009).map(&:id)
      result.should =~ [ show1.id, show2.id ]
    end
  end

  context "#decode" do
    before(:each) do
      @show1 = Factory(:show, :name => "Athadu", :language => 'telugu', :started_on => "1/1/2009")
      @show2 = Factory(:show, :name => "Don 2", :language => 'hindi', :started_on => nil)
    end

    it "should decode 'athadu (telugu 2009)' to athadu movie" do
      Show.decode("Athadu (telugu 2009)").id.should eql(@show1.id)
    end

    it "should decode 'Don 2 (hindi )' to Don 2 movie" do
      Show.decode("Don 2 (hindi )").id.should eql(@show2.id)
    end
  end

  context "instance" do
    subject { Factory(:show, :name => "Athadu", :language => 'telugu', :started_on => "1/1/2009".to_date) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:language) }
    it { should have_many(:movies) }
    it { should have_many(:trailers) }
    it { should have_many(:lyrics) }
    it { should have_many(:videos) }
    it { should have_many(:songs) }

    it { should allow_value("telugu").for(:language) }
    it { should allow_value("hindi").for(:language)  }

    it { should_not allow_value("tamil").for(:language) }
    its(:autocomplete_name) { should eql("Athadu (telugu 2009)") }
    its(:year) { should eql(2009) }
  end

  context "associations" do
    subject { Factory(:show) }
    before(:each) do
      @a1 = Factory(:video, :show => subject, :kind => 'lyric')
      @m1 = Factory(:video, :show => subject, :kind => 'movie')
      @m2 = Factory(:video, :show => subject, :kind => 'movie')
      @t1 = Factory(:video, :show => subject, :kind => 'trailer')
      @a2 = Factory(:video, :show => subject, :kind => 'lyric')
      @v2 = Factory(:video, :show => subject, :kind => 'song')
    end
    its(:songs)     { should =~ [ @v2 ] }
    its(:trailers)  { should =~ [ @t1 ] }
    its(:movies)    { should =~ [ @m1, @m2 ] }
    its(:lyrics)    { should =~ [ @a1, @a2 ] }
    its(:videos)    { should =~ [ @v2, @t1, @a1, @a2, @m1, @m2 ] }
  end
end
