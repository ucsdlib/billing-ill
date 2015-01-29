require 'spec_helper'

describe Fund do 

  it {should have_many(:recharges)}
  
  it {should validate_presence_of(:program_code)}
  it {should validate_presence_of(:org_code)}
  it {should validate_presence_of(:index_code)}
  it {should validate_presence_of(:fund_code)}

  it {should validate_length_of(:program_code)}
  it {should validate_length_of(:org_code)}
  it {should validate_length_of(:index_code)}
  it {should validate_length_of(:fund_code)}
end