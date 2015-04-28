#---
# by hweng@ucsd.edu
#---

class Invoice < ActiveRecord::Base
  belongs_to :patron

  monetize :charge_cents,  :numericality => {
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => 1000000
  }

  validates :number_prints, presence: true
  validates :invoice_type, presence: true
  validates :status, presence: true
  validates :ill_numbers, presence: true
  validates :patron_id, presence: true

  delegate :name, to: :patron, prefix: :patron
end