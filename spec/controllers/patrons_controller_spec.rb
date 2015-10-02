#---
# @author hweng@ucsd.edu
#---

require 'spec_helper'

describe PatronsController do 

  describe "GET index" do
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end

    before(:each) do
      set_current_user
    end

    it "sets @total_count" do
      @patron = Fabricate(:patron)
      get :index 
      expect(assigns(:total_count)).to eq(1)
    end
    
    it "sets @patrons to be nil if result_arr is blank" do
      get :index 
      expect(assigns(:patrons)).to eq(nil)
    end
  end
  
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) {get :new}
    end

    before(:each) do
      set_current_user
    end

    it "sets @patron" do
      get :new
      expect(assigns(:patron)).to be_instance_of(Patron)
    end

    it "sets @country_list" do
      @list = []
      COUNTRIES.each do |country|
        @list << [country[:term], country[:id]]
      end
      
      get :new
      expect(assigns(:country_list)).to eq(@list)
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) {post :create}
    end

    context "with valid input" do
      before do
        set_current_user
        post :create, patron: Fabricate.attributes_for(:patron)
      end

      it "creates the patron" do
        expect(Patron.count).to eq(1)
      end

      it "redirects to the create a new patron page" do
        expect(response).to redirect_to new_patron_path
      end
    end

    context "with invalid input" do
      before do
        set_current_user
        post :create, patron: {ar_code: "123"}
      end

      it "sets @patron" do
        expect(assigns(:patron)).to be_instance_of(Patron)
      end

      it "does not create the patron" do
        expect(Patron.count).to eq(0)
      end

      it "render the :new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET edit" do
    before(:each) do
      set_current_user
      @patron = Fabricate(:patron, country_code: 'US')
    end

    it "sets @patron" do
      #@patron = Fabricate(:patron)
      get :edit, id: @patron
      expect(assigns(:patron)).to eq(@patron)
    end

    it "sets @selected_country" do
      #@patron = Fabricate(:patron, country_code: 'US')
      get :edit, id: @patron
      expect(assigns(:selected_country)).to eq('US')
    end

    it "sets @country_list" do
      @list = []
      COUNTRIES.each do |country|
        @list << [country[:term], country[:id]]
      end
      
      get :edit, id: @patron
      expect(assigns(:country_list)).to eq(@list)
    end
  end

  describe "PUT update" do
    context "with valid input" do
      before(:each) do
        set_current_user
        @patron = Fabricate(:patron, ar_code: 'A23456789')
        put :update, id: @patron, patron: Fabricate.attributes_for(:patron, ar_code: 'A98765432')
        @patron.reload
      end
     
      it "updates the patron" do
        expect(@patron.ar_code).to eq('A98765432')
      end

      it "redirects to the front page" do
        expect(response).to redirect_to new_patron_path
      end
    end

    context "with invalid input" do
      before(:each) do
        set_current_user
        @patron = Fabricate(:patron, ar_code: 'A23456789')
        put :update, id: @patron, patron: Fabricate.attributes_for(:patron, ar_code: '123')
        @patron.reload
      end

      it "located the requested patron" do
        expect(assigns(:patron)).to eq(@patron)
      end

      it "does not update the patron" do
        expect(@patron.ar_code).to eq('A23456789')
      end

      it "render the :edit template" do
        expect(response).to render_template :edit
      end
    end
  end
end