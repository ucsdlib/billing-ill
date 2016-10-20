#---
# @author hweng@ucsd.edu
#---

require 'spec_helper'

describe InvoicesController do 
   describe "GET index" do
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end

    before(:each) do
      set_current_user
    end

    it "sets @total_count" do
      @invoice = Fabricate(:invoice)
      get :index 
      expect(assigns(:total_count)).to eq(1)
    end
    
    it "sets @invoices to be nil if result_arr is blank" do
      get :index 
      expect(assigns(:invoices)).to eq(nil)
    end
  end

  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) {get :new}
    end

    before(:each) do
      set_current_user
    end

    it "sets @invoice" do
      get :new
      expect(assigns(:invoice)).to be_instance_of(Invoice)
    end

    it "sets @patron_list" do
      patron = Fabricate(:patron, id: 1, name: "Joe Don")
      get :new
      expect(assigns(:patron_list)).to eq([["Joe Don", 1]])
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
        post :create, invoice: Fabricate.attributes_for(:invoice)
      end

      it "creates the recharge" do
        expect(Invoice.count).to eq(1)
      end

      it "redirects to the front page" do
        expect(response).to redirect_to new_invoice_path
      end
    end

    context "with invalid input" do
      before do
        post :create, invoice: {charge: "-5"}
      end

      it "sets @patron" do
        expect(assigns(:invoice)).to be_instance_of(Invoice)
      end

      it "does not create the invoice" do
        expect(Invoice.count).to eq(0)
      end

      it "render the :new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET edit" do
    before(:each) do
      set_current_user
      @invoice = Fabricate(:invoice, patron_id: 1, status: "active", invoice_type: "e-copy")
    end

    it "sets @invoice" do
      get :edit, id: @invoice
      expect(assigns(:invoice)).to eq(@invoice)
    end

    it "sets @patron_list" do
      patron = Fabricate(:patron, id: 1, name: "Joe Doe")
      get :edit, id: @invoice
      expect(assigns(:patron_list)).to eq([["Joe Doe", 1]])
    end

    it "sets @selected_patron" do
      get :edit, id: @invoice
      expect(assigns(:selected_patron)).to eq(1)
    end

    it "sets @selected_status" do
      get :edit, id: @invoice
      expect(assigns(:selected_status)).to eq("active")
    end

    it "sets @selected_type" do
      get :edit, id: @invoice
      expect(assigns(:selected_type)).to eq("e-copy")
    end
  end

  describe "PUT update" do
    context "with valid input" do
      before(:each) do
        set_current_user
        @invoice = Fabricate(:invoice, charge: 5.0)
        put :update, id: @invoice, invoice: Fabricate.attributes_for(:invoice, charge: 5.5)
        @invoice.reload
      end
     
      it "updates the invoice" do
        expect(@invoice.charge).to eq(5.5)
      end

      it "redirects to the front page" do
        expect(response).to redirect_to new_invoice_path
      end
    end

    context "with invalid input" do
      before(:each) do
        set_current_user
        @invoice = Fabricate(:invoice, charge: 5.0)
        put :update, id: @invoice, invoice: Fabricate.attributes_for(:invoice, charge: -5.5)
        @invoice.reload
      end

      it "located the requested invoice" do
        expect(assigns(:invoice)).to eq(@invoice)
      end

      it "does not update the invoice" do
        expect(@invoice.charge).to eq(5.0)
      end

      it "render the :edit template" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
        set_current_user
        @invoice = Fabricate(:invoice)
        delete :destroy, id: @invoice
      end

    it "deletes the invoice" do
      expect(Invoice.count).to eq(0)
    end
    
    it "redirects to the invoice index page" do
      expect(response).to redirect_to invoices_path
    end
  end

  describe "GET search" do
    before do
      set_current_user
      patron = Fabricate(:patron, id: 1, name: "Joe Doe")
      @invoice = Fabricate(:invoice, invoice_num: "50002", patron_id: 1 )
    end
    
    it "sets @search_result an array if there is a match for search option of patron_name" do
      get :search, search_term: "Joe Doe", search_option: "patron_name"
      expect(assigns(:search_result)).to eq([@invoice])
    end
    
    it "sets @search_result to be nil if no match for search option of patron_name" do
      get :search, search_term: "Alice", search_option: "patron_name"
      expect(assigns(:search_result)).to eq(nil)
    end

    it "sets @search_result an array if there is a match for search option of invoice_num" do
      get :search, search_term: "50002", search_option: "invoice_num"
      expect(assigns(:search_result)).to eq([@invoice])
    end
    
    it "sets @search_result to be nil if no match for search option of invoice_num" do
      get :search, search_term: "50000", search_option: "invoice_num"
      expect(assigns(:search_result)).to eq(nil)
    end

    it "default sets @search_result an invoice array if no option selected" do
      get :search, search_term: "50002", search_option: ""
      expect(assigns(:search_result)).to eq([@invoice])
    end

    it "sets @search_count" do
      get :search, search_term: "Joe Doe", search_option: "patron_name"
      expect(assigns(:search_count)).to eq(1)
    end
  end

  describe "GET process_batch" do
    before do
      set_current_user
      @invoice = Fabricate(:invoice, status: "pending")
    end

    it "sets @current_batch_count" do
      get :process_batch
      expect(assigns(:current_batch_count)).to eq(1)
    end

    it "sets @current_batch_result" do
      get :process_batch
      expect(assigns(:current_batch_result)).to eq([@invoice])
    end
  end

  describe "GET create_report" do
    before do
      set_current_user
      @invoice = Fabricate(:invoice, status: "pending")
    end

    it "sets @current_batch_count" do
      get :create_report
      expect(assigns(:current_batch_count)).to eq(1)
    end
    
    it "sets @current_batch_result" do
      get :create_report
      expect(assigns(:current_batch_result)).to eq([@invoice])
    end
  end

  describe "GET create_bill" do
   before(:each) do
      set_current_user
      @invoice = Fabricate(:invoice)
    end

    it "sets @invoice" do
      get :create_bill, id: @invoice
      expect(assigns(:invoice)).to eq(@invoice)
    end
  end

  describe "GET create_charge_output" do
    before(:each) do
      set_current_user
    end

    it "render the :plain content template" do
        get :create_charge_output
        expect(response.body).to include("CLIBRARY.CHARGE")
    end
  end

  describe "GET create_person_output" do
    before(:each) do
      set_current_user
    end

    it "render the :plain content template" do
        get :create_person_output
        expect(response.body).to include("CLIBRARY.PERSON")
    end
  end

  describe "GET create_entity_output" do
    before(:each) do
      set_current_user
    end

    it "render the :plain content template" do
        get :create_entity_output
        expect(response.body).to include("CLIBRARY.ENTITY")
    end
  end

  describe "GET create_person_output" do
    it "render the :plain content template" do
      # patron = Fabricate(:patron, ar_code: "A23456789")
      # @invoice = Fabricate(:invoice, patron_id: 1 )
        
        expect(response.body).to eq("")
    end
  end

  describe "GET ftp_file" do
    before do
      @user = Fabricate(:user, email: "joe@example.com")
      set_current_user(@user)
      expect(Invoice).to receive(:send_file)
    end

    it "sends an email to the recipient" do
      get :ftp_file
      ActionMailer::Base.deliveries.clear
      email_date = Time.zone.now
      AppMailer.send_invoice_email(@user, email_date).deliver_now

      expect(ActionMailer::Base.deliveries.last.from).to eq(['joe@example.com'])
    end

    it "redirects to the invoice index page" do
        get :ftp_file
        expect(response).to redirect_to invoices_path
    end

    it "sets the notice" do
      get :ftp_file
      expect(flash[:notice]).not_to be_blank
    end
  end

  describe "GET merge_records" do
    before(:each) do
      set_current_user
    end

    it "redirects to the invoice index page" do
      get :merge_records
      expect(response).to redirect_to invoices_path
    end

    it "updates the status to submitted" do
      invoice = Fabricate(:invoice, status: "pending")
      get :merge_records
      expect(invoice.reload.status).to eq("submitted")
    end

    it "updates the submitted_at to current date" do
      invoice = Fabricate(:invoice, status: "pending")
      get :merge_records
      expect(invoice.reload.submitted_at.strftime("%m%y")).to eq(Time.zone.now.strftime("%m%y"))
    end
  end
end