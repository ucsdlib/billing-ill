#---
# by hweng@ucsd.edu
#---

require 'spec_helper'

describe FundsController do 
  describe "GET index" do
    it "sets @total_count" do
      @fund = Fabricate(:fund)
      get :index 
      expect(assigns(:total_count)).to eq(1)
    end
    
    it "sets @funds to be nil if result_arr is blank" do
      get :index 
      expect(assigns(:funds)).to eq(nil)
    end
  end

  describe "GET new" do
    it "sets @fund" do
      get :new
      expect(assigns(:fund)).to be_instance_of(Fund)
    end
  end

  describe "POST create" do
    context "with valid input" do
      before do
        post :create, fund: Fabricate.attributes_for(:fund)
      end

      it "creates the fund" do
        expect(Fund.count).to eq(1)
      end

      it "redirects to the front page" do
        expect(response).to redirect_to root_path
      end
    end

    context "with invalid input" do
      before do
        post :create, fund: {program_code: "abcdf", org_code: "abcde"}
      end

      it "sets @fund" do
        expect(assigns(:fund)).to be_instance_of(Fund)
      end

      it "does not create the fund" do
        expect(Fund.count).to eq(0)
      end

      it "render the :new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET edit" do
    it "sets @fund" do
      @fund = Fabricate(:fund)
      get :edit, id: @fund
      expect(assigns(:fund)).to eq(@fund)
    end
  end

  describe "PUT update" do
    context "with valid input" do
      before(:each) do
        @fund = Fabricate(:fund, program_code: 'abcdef')
        put :update, id: @fund, fund: Fabricate.attributes_for(:fund, program_code: '123456')
        @fund.reload
      end
     
      it "updates the fund" do
        expect(@fund.program_code).to eq('123456')
      end

      it "redirects to the front page" do
        expect(response).to redirect_to root_path
      end
    end

    context "with invalid input" do
      before(:each) do
        @fund = Fabricate(:fund, program_code: 'abcdef')
        put :update, id: @fund, fund: Fabricate.attributes_for(:fund, program_code: '123')
        @fund.reload
      end

      it "located the requested fund" do
        expect(assigns(:fund)).to eq(@fund)
      end

      it "does not update the fund" do
        expect(@fund.program_code).to eq('abcdef')
      end

      it "render the :edit template" do
        expect(response).to render_template :edit
      end
    end
  end
end