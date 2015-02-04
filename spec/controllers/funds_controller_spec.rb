require 'spec_helper'

describe FundsController do 
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
end