require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Emailtb do

  context '.reset_password' do
    before do
      @user = Factory(:user)
      @emailtb = Emailtb.reset_password(@user)
    end
    it "should have one emailtb record" do
      Emailtb.count.should == 1
    end
    it "should use right template" do
      #@emailtb.data['template'].should == 'reset_password'
      @emailtb.data.keys.should =~ [:template, :recipients, :subject]
      @emailtb.data[:template].should == 'reset_password'
      @emailtb.data[:recipients].should == [@user.id]
      @emailtb.data[:subject].should == 'Reset password'
    end
  end
end
