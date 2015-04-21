require 'spec_helper'

describe Invoice do 
  include MoneyRails::TestHelpers

  it {expect(monetize(:charge_cents)).to be_truthy}
  
  it {should belong_to(:patron)}
  it {should validate_presence_of(:number_prints)}
  it {should validate_presence_of(:type)}
  it {should validate_presence_of(:status)}
  it {should validate_presence_of(:ill_numbers)}
  it {should validate_presence_of(:patron_id)}
  it {should validate_numericality_of(:charge)}
end