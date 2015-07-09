#---
# @author hweng@ucsd.edu
#---

require 'spec_helper'

describe Patron do 

  #it {should have_many(:invoices)}
  
  #it {should validate_presence_of(:email_address)}
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:ar_code)}
  it {should validate_presence_of(:address1)}
  it {should validate_presence_of(:city)}
  it {should validate_presence_of(:state)}
  it {should validate_presence_of(:zip1)}

  it {should validate_length_of(:name)}
  it {should validate_length_of(:ar_code)}
  it {should validate_length_of(:address1)}
  it {should validate_length_of(:address2)}
  it {should validate_length_of(:address3)}
  it {should validate_length_of(:address4)}
  it {should validate_length_of(:city)}
  it {should validate_length_of(:state)}
  it {should validate_length_of(:zip1)}
  it {should validate_length_of(:zip2)}
  it {should validate_length_of(:country_code)}

  it {should validate_uniqueness_of(:ar_code)}

  it do
    should allow_value('A12345678', 'AA2345678').
      for(:ar_code)
  end
end