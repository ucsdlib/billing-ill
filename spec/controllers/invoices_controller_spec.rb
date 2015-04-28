#---
# by hweng@ucsd.edu
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
end