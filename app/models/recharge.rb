class Recharge < ActiveRecord::Base
  belongs_to :fund

  validates :charge, presence: true, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than => 0, :less_than => 1000000}
  validates :number_copies, presence: true, 
  validates :status, presence: true, 
  
end