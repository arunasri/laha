require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Channel do

  fixtures :channels

  context "hindi scope" do
    it "returns hindi channels" do
      Channel.hindi.map(&:id).should =~ [5,6,7,8]
    end
  end

  context "telugu scope" do
    it "return telugu channels" do
      Channel.telugu.map(&:id).should =~ [1,2,3,4]
    end
  end

  context "instance" do
    subject { Factory(:channel) }
    it { should have_many(:feeds) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:show_association_name) }
    it { should allow_value('telugu').for(:language) }
    it { should allow_value('hindi').for(:language) }
    it { should_not allow_value('tamil').for(:language) }
    it { should_not allow_value('kannada').for(:language) }
  end
end
