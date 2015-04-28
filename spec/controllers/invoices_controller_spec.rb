require 'spec_helper'

describe InvoicesController do 
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
end