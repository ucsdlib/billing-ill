require 'spec_helper'

describe Recharge do 

  it {should belong_to(:fund)}
  
  it {should validate_presence_of(:charge)}
  it {should validate_presence_of(:number_copies)}
  it {should validate_presence_of(:status)}
  it {should validate_numericality_of(:charge)}

  it do
    should allow_value('5', '5.00', '5.0', '0.5').
      for(:charge)
  end
end