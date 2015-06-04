require 'spec_helper'

describe User do

  describe ".find_or_create_for_developer" do
    it "should create a User for first time user" do
      user = User.find_or_create_for_developer

      user.should be_persisted
      user.provider.should == "developer"
      user.uid.should == "1"
      user.full_name.should == "DEVELOPER"
    end

    it "should reuse an existing User if the access token matches" do
      user = User.find_or_create_for_developer
      lambda { User.find_or_create_for_developer }.should_not change(User, :count) 
    
    end
  end

  describe ".find_or_create_for_shibboleth" do
    it "should create a User when a user is first authenticated" do
      token = { 'info' => { 'email' => nil, 'full_name' => nil} }
      token.stub(:uid => "test_user", :provider => "shibboleth")
      user = User.find_or_create_for_shibboleth(token)

      user.should be_persisted
      user.provider.should == "shibboleth"
      user.uid.should == "test_user"
    end
  end
end