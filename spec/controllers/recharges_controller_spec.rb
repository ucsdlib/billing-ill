#---
# @author hweng@ucsd.edu
#---

require 'spec_helper'

describe RechargesController do 
  describe "GET index" do
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end

    before(:each) do
      set_current_user
    end

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
    it_behaves_like "requires sign in" do
      let(:action) {get :new}
    end

    before(:each) do
      set_current_user
    end

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
    it_behaves_like "requires sign in" do
      let(:action) {post :create}
    end

    before(:each) do
      set_current_user
    end

    context "with valid input" do
      before do
        post :create, recharge: Fabricate.attributes_for(:recharge)
      end

      it "creates the recharge" do
        expect(Recharge.count).to eq(1)
      end

      it "redirects to the front page" do
        expect(response).to redirect_to new_recharge_path
      end
    end

    context "with invalid input" do
      before do
        post :create, recharge: {charge: "-5"}
      end

      it "sets @fund" do
        expect(assigns(:recharge)).to be_instance_of(Recharge)
      end

      it "does not create the recharge" do
        expect(Recharge.count).to eq(0)
      end

      it "render the :new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET edit" do
    before(:each) do
      set_current_user
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
        set_current_user
        @recharge = Fabricate(:recharge, charge: 5.0)
        put :update, id: @recharge, recharge: Fabricate.attributes_for(:recharge, charge: 5.5)
        @recharge.reload
      end
     
      it "updates the recharge" do
        expect(@recharge.charge).to eq(5.5)
      end

      it "redirects to the front page" do
        expect(response).to redirect_to new_recharge_path
      end
    end

    context "with invalid input" do
      before(:each) do
        set_current_user
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

  describe "DELETE destroy" do
    before(:each) do
        set_current_user
        @recharge = Fabricate(:recharge)
        delete :destroy, id: @recharge
      end

    it "redirects to the recharge index page" do
      expect(response).to redirect_to recharges_path
    end

    it "deletes the recharge" do
      expect(Recharge.count).to eq(0)
    end
  end

  describe "GET search" do
    before do
      set_current_user
      fund = Fabricate(:fund, id: 1, index_code: "ANSVAMC")
      @recharge = Fabricate(:recharge, fund_id: 1 )
    end
    
    it "sets @search_result an array if there is a match" do
      get :search, search_term: "ANSVAMC"
      expect(assigns(:search_result)).to eq([@recharge])
    end
    
    it "sets @search_result to be nil if no match" do
      get :search, search_term: "AA"
      expect(assigns(:search_result)).to eq(nil)
    end

    it "sets @search_count" do
      get :search, search_term: "ANSVAMC"
      expect(assigns(:search_count)).to eq(1)
    end
  end

  describe "GET process_batch" do
    before do
      set_current_user
    end
   
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

  describe "GET ftp_file" do
    it "sends an email to the recipient" do
      get :ftp_file
      ActionMailer::Base.deliveries.clear
      @user = Fabricate(:user, email: "joe@example.com")
      set_current_user(@user)
      email_date = Time.now
      file_name = "test_file"
      record_count = 10
      AppMailer.send_recharge_email(@user, email_date, file_name, record_count).deliver_now

      expect(ActionMailer::Base.deliveries.last.from).to eq(['joe@example.com'])
    end

    # it "updates the status to submitted" do
    #   set_current_user
      
    #   recharge = Fabricate(:recharge, status: "pending")
    #   get :ftp_file
    #   expect(recharge.reload.status).to eq("submitted")
    # end

    # it "updates the submitted_at to current date" do
    #   set_current_user
     
    #   recharge = Fabricate(:recharge, status: "pending")
    #   get :ftp_file
    #   expect(recharge.reload.submitted_at.strftime("%m%y")).to eq(Time.now.strftime("%m%y"))
    # end

    # it "redirects to the recharges index page" do
    #     expect(response).to redirect_to recharges_path
    #   end
  end

  describe "GET create_output" do
    before(:each) do
      set_current_user
    end

    it "render the :plain content template" do
        get :create_output
        expect(response.body).to include("LIBRARY RECHARGES")
    end
  end
end