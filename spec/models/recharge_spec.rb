#---
# by hweng@ucsd.edu
#---
require 'spec_helper'

describe Recharge do 

  it {should belong_to(:fund)}
  
  it {should validate_presence_of(:charge)}
  it {should validate_presence_of(:number_copies)}
  it {should validate_presence_of(:status)}
  it {should validate_presence_of(:fund_id)}
  it {should validate_numericality_of(:charge)}

  it {should delegate_method(:fund_org_code).to(:fund).as(:org_code)}
  it {should delegate_method(:fund_index_code).to(:fund).as(:index_code)}
  it {should delegate_method(:fund_fund_code).to(:fund).as(:fund_code)}
  it {should delegate_method(:fund_program_code).to(:fund).as(:program_code)}

  it do
    should allow_value('5', '5.00', '5.0', '0.5').
      for(:charge)
  end

  describe "search_by_index_code" do
    before do
        fund = Fabricate(:fund, id: 1, index_code: "ANSVAMC")
        @recharge1 = Fabricate(:recharge, fund_id: 1 )
        @recharge2 = Fabricate(:recharge, fund_id: 1)
    end
    
    it "returns an array of all matches ordered by created_at" do
      expect(Recharge.search_by_index_code("ANSVAMC")).to eq([@recharge2,@recharge1])
    end

    it "returns an empty array if there is no match" do
      expect(Recharge.search_by_index_code("BB")).to eq([])
    end

    it "returns an empty array for a search with an empty string" do
      expect(Recharge.search_by_index_code("")).to eq([])
    end
  end
end