#---
# by hweng@ucsd.edu
#---

require 'spec_helper'

describe RechargesController do 
  describe "GET index" do
    it "sets @total_count" do
      @recharge = Fabricate(:recharge)
      get :index 
      expect(assigns(:total_count)).to eq(1)
    end
    
    it "sets @recharges to be nil if result_arr is blank" do
      get :index 
      expect(assigns(:recharges)).to eq(nil)
    end
  end

  describe "GET new" do
    it "sets @recharge" do
      get :new
      expect(assigns(:recharge)).to be_instance_of(Recharge)
    end

    it "sets @index_list" do
      fund = Fabricate(:fund, id: 1, index_code: "ABCDEFG")
      get :new
      expect(assigns(:index_list)).to eq([["ABCDEFG", 1]])
    end
  end

  describe "POST create" do
    context "with valid input" do
      before do
        post :create, recharge: Fabricate.attributes_for(:recharge)
      end

      it "creates the recharge" do
        expect(Recharge.count).to eq(1)
      end

      it "redirects to the front page" do
        expect(response).to redirect_to root_path
      end
    end

    context "with invalid input" do
      before do
        post :create, recharge: {charge: "-5"}
      end

      it "sets @fund" do
        expect(assigns(:recharge)).to be_instance_of(Recharge)
      end

      it "does not create the fund" do
        expect(Recharge.count).to eq(0)
      end

      it "render the :new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET edit" do
    before(:each) do
      @recharge = Fabricate(:recharge, fund_id: 1, status: "active")
    end

    it "sets @recharge" do
      get :edit, id: @recharge
      expect(assigns(:recharge)).to eq(@recharge)
    end

    it "sets @index_list" do
      fund = Fabricate(:fund, id: 1, index_code: "ABCDEFG")
      get :edit, id: @recharge
      expect(assigns(:index_list)).to eq([["ABCDEFG", 1]])
    end

    it "sets @selected_index" do
      get :edit, id: @recharge
      expect(assigns(:selected_index)).to eq(1)
    end

    it "sets @selected_status" do
      get :edit, id: @recharge
      expect(assigns(:selected_status)).to eq("active")
    end
  end

  describe "PUT update" do
    context "with valid input" do
      before(:each) do
        @recharge = Fabricate(:recharge, charge: 5.0)
        put :update, id: @recharge, recharge: Fabricate.attributes_for(:recharge, charge: 5.5)
        @recharge.reload
      end
     
      it "updates the recharge" do
        expect(@recharge.charge).to eq(5.5)
      end

      it "redirects to the front page" do
        expect(response).to redirect_to root_path
      end
    end

    context "with invalid input" do
      before(:each) do
        @recharge = Fabricate(:recharge, charge: 5.0)
        put :update, id: @recharge, recharge: Fabricate.attributes_for(:recharge, charge: -5.5)
        @recharge.reload
      end

      it "located the requested recharge" do
        expect(assigns(:recharge)).to eq(@recharge)
      end

      it "does not update the recharge" do
        expect(@recharge.charge).to eq(5.0)
      end

      it "render the :edit template" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "GET search" do
    before do
      fund = Fabricate(:fund, id: 1, index_code: "ANSVAMC")
      @recharge = Fabricate(:recharge, fund_id: 1 )
    end

    it "sets @total_count" do
      get :search, search_term: "ANSVAMC"
      expect(assigns(:total_count)).to eq(1)
    end
    
    it "sets @search_result an array if there is a match" do
      get :search, search_term: "ANSVAMC"
      expect(assigns(:search_result)).to eq([@recharge])
    end
    
    it "sets @search_result to be nil if no match" do
      get :search, search_term: "AA"
      expect(assigns(:search_result)).to eq(nil)
    end
  end

  describe "GET process_batch" do
    it "sets @current_batch_result an array if there is a match" do
      @recharge = Fabricate(:recharge, status: "pending")
      get :process_batch
      expect(assigns(:current_batch_result)).to eq([@recharge])
    end
    
    it "sets @current_batch_result to be nil if no match" do
      get :process_batch
      expect(assigns(:current_batch_result)).to eq(nil)
    end
  end
end