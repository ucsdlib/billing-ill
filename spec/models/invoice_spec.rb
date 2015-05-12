#---
# By hweng@ucsd.edu
#---

require 'spec_helper'

describe Invoice do 
  include MoneyRails::TestHelpers

  it {expect(monetize(:charge_cents)).to be_truthy}
  
  it {should belong_to(:patron)}
  it {should validate_presence_of(:invoice_num)}
  it {should validate_presence_of(:number_prints)}
  it {should validate_presence_of(:invoice_type)}
  it {should validate_presence_of(:status)}
  it {should validate_presence_of(:ill_numbers)}
  it {should validate_presence_of(:patron_id)}
  it {should validate_numericality_of(:charge)}

  it {should validate_uniqueness_of(:invoice_num)}

  it {should delegate_method(:patron_name).to(:patron).as(:name)}
  it {should delegate_method(:patron_ar_code).to(:patron).as(:ar_code)}
  it {should delegate_method(:patron_address1).to(:patron).as(:address1)}
  it {should delegate_method(:patron_address2).to(:patron).as(:address2)}
  it {should delegate_method(:patron_address3).to(:patron).as(:address3)}
  it {should delegate_method(:patron_address4).to(:patron).as(:address4)}
  it {should delegate_method(:patron_city).to(:patron).as(:city)}
  it {should delegate_method(:patron_state).to(:patron).as(:state)}
  it {should delegate_method(:patron_zip1).to(:patron).as(:zip1)}
  it {should delegate_method(:patron_zip2).to(:patron).as(:zip2)}
  it {should delegate_method(:patron_country_code).to(:patron).as(:country_code)}
end

  describe "search_by_patron_name" do
    before do
        patron = Fabricate(:patron, id: 1, name: "Joe Doe")
        @invoice1 = Fabricate(:invoice, patron_id: 1, invoice_num: "50002" )
        @invoice2 = Fabricate(:invoice, patron_id: 1, invoice_num: "50003")
    end
    
    it "returns an array of all matches ordered by created_at" do
      expect(Invoice.search_by_patron_name("Joe Doe")).to eq([@invoice2,@invoice1])
    end

    it "returns an empty array if there is no match" do
      expect(Invoice.search_by_patron_name("alice")).to eq([])
    end

    it "returns an empty array for a search with an empty string" do
      expect(Invoice.search_by_patron_name("")).to eq([])
    end
  end

  describe "search_by_invoice_num" do
    before do
        @invoice = Fabricate(:invoice, invoice_num: "50002")
    end
    
    it "returns an array of all matches" do
      expect(Invoice.search_by_invoice_num("50002")).to eq([@invoice])
    end

    it "returns an empty array if there is no match" do
      expect(Invoice.search_by_invoice_num("50000")).to eq([])
    end

    it "returns an empty array for a search with an empty string" do
      expect(Invoice.search_by_invoice_num("")).to eq([])
    end
  end