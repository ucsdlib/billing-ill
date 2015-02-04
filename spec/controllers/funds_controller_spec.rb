require 'spec_helper'

describe FundsController do 
  describe "GET new" do
    it "sets @fund" do
      get :new
      expect(assigns(:fund)).to be_instance_of(Fund)
    end
  end
end