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

  def self.search_by_patron_name(search_term)
    return [] if search_term.blank?

    if Patron.where(name: search_term).first != nil
      patron_id = Patron.where(name: search_term).first
      result = where("patron_id = ? ", patron_id).order("created_at DESC") 
    else
      result = []
    end
  end

  def self.search_by_invoice_num(search_term)
    return [] if search_term.blank?

    if where("id = ?", search_term).first != nil
      
      result = where("id = ?", search_term) 
    else
      result = []
    end
  end
end