#---
# @author hweng@ucsd.edu
#---

class Invoice < ActiveRecord::Base
  belongs_to :patron

  monetize :charge_cents,  :numericality => {
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => 1000000
  }
  
  validates :invoice_num, presence: true, uniqueness: true
  validates :number_prints, presence: true
  validates :invoice_type, presence: true
  validates :status, presence: true
  validates :comments, presence: true
  validates :patron_id, presence: true

  delegate :name, to: :patron, prefix: :patron
  delegate :email_address, to: :patron, prefix: :patron
  delegate :ar_code, to: :patron, prefix: :patron
  delegate :address1, to: :patron, prefix: :patron
  delegate :address2, to: :patron, prefix: :patron
  delegate :address3, to: :patron, prefix: :patron
  delegate :address4, to: :patron, prefix: :patron
  delegate :city, to: :patron, prefix: :patron
  delegate :state, to: :patron, prefix: :patron
  delegate :zip1, to: :patron, prefix: :patron
  delegate :zip2, to: :patron, prefix: :patron
  delegate :country_code, to: :patron, prefix: :patron
  #delegate :entity_pending_status, to: :patron, prefix: :patron

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

    if where("invoice_num = ?", search_term).first != nil
      
      result = where("invoice_num = ?", search_term) 
    else
      result = []
    end
  end

  def self.search_all_pending_status
    result = where(status: "pending").order("created_at DESC")
  end

  def self.pending_status_count
    search_all_pending_status.count
  end

  def self.get_entity_lfile_name
    file_name = "ENTITY.D" + convert_to_julian_date + ".TXT"
  end

  def self.get_person_lfile_name
    file_name = "PERSON.D" + convert_to_julian_date + ".TXT"
  end

  def self.get_charge_lfile_name
    file_name = "CHARGE.D" + convert_to_julian_date + ".TXT"
  end

  def self.get_entity_file_name
    file_name = "SISP.ARD2501.LIBBUS.ENTITY.D" + convert_to_julian_date
  end

  def self.get_person_file_name
    file_name = "SISP.ARD2501.LIBBUS.PERSON.D" + convert_to_julian_date
  end

  def self.get_charge_file_name
    file_name = "SISP.ARD2501.LIBBUS.CHARGE.D" + convert_to_julian_date
  end

  def self.convert_to_julian_date
    output = Date.today.strftime("%y") + Date.today.yday.to_s
  end
end