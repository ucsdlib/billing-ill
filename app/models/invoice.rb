class Invoice < ActiveRecord::Base
  belongs_to :patron

  monetize :charge_cents,  :numericality => {
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => 1000000
  }

  validates :number_prints, presence: true
  validates :type, presence: true
  validates :status, presence: true
  validates :ill_numbers, presence: true
end