#---
# by hweng@ucsd.edu
#---

require 'spec_helper'

describe RechargesController do 
  describe "GET new" do
    it "sets @recharge" do
      get :new
      expect(assigns(:recharge)).to be_instance_of(Recharge)
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
    it "sets @recharge" do
      @recharge = Fabricate(:recharge)
      get :edit, id: @recharge
      expect(assigns(:recharge)).to eq(@recharge)
    end
  end

  describe "PUT update" do
    context "with valid input" do
      before(:each) do
        @recharge = Fabricate(:recharge, charge: "5.0")
        put :update, id: @recharge, recharge: Fabricate.attributes_for(:recharge, charge: "5.5")
        @recharge.reload
      end
     
      it "updates the recharge" do
        expect(@recharge.charge).to eq('5.5')
      end

      it "redirects to the front page" do
        expect(response).to redirect_to root_path
      end
    end

    context "with invalid input" do
      before(:each) do
        @recharge = Fabricate(:recharge, charge: "5.0")
        put :update, id: @recharge, recharge: Fabricate.attributes_for(:recharge, charge: "-5.5")
        @recharge.reload
      end

      it "located the requested recharge" do
        expect(assigns(:recharge)).to eq(@recharge)
      end

      it "does not update the recharge" do
        expect(@recharge.charge).to eq('5.0')
      end

      it "render the :edit template" do
        expect(response).to render_template :edit
      end
    end
  end
end