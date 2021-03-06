# encoding: utf-8
#
# @author hweng@ucsd.edu
#

class Patron < ActiveRecord::Base
  has_many :invoices

  # validates :email_address, presence: true
  validates :name, presence: true, length: { maximum: 35 }
  validates :ar_code, presence: true, uniqueness: true, format: { with: /\AA[A\d]\d{7}\z/ }, length: { is: 9 }
  validates :address1, presence: true, length: { maximum: 35 }
  validates :address2, length: { maximum: 35 }
  validates :address3, length: { maximum: 35 }
  validates :address4, length: { maximum: 35 }
  validates :city, presence: true, length: { maximum: 18 }
  validates :state, presence: true, length: { is: 2 }
  validates :zip1, presence: true, length: { maximum: 5 }
  validates :zip2, length: { maximum: 4 }
  validates :country_code, length: { maximum: 2 }
end
