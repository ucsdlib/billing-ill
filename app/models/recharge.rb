#---
# by hweng@ucsd.edu
#---

class Recharge < ActiveRecord::Base
  belongs_to :fund

  validates :charge, presence: true, format: { :with => /\A\d+(?:\.\d{0,2})?\z/ }, numericality: {greater_than: 0, less_than: 1000000}
  validates :number_copies, presence: true
  validates :status, presence: true 
  validates :fund_id, presence: true

  def self.search_by_ID(search_term)
    return [] if search_term.blank?

    where("fund_id = ? ", search_term).order("created_at DESC")
  end

  def self.search_by_index_code(search_term)
    return [] if search_term.blank?

    if Fund.where(index_code: search_term).first != nil
      fund_id = Fund.where(index_code: search_term).first
      result = where("fund_id = ? ", fund_id).order("created_at DESC") 
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

  def self.page_count
  end

  # def get_header_row
  #   result_arr = search_all_pending_status

  #   #@current_batch_count = Recharge.pending_status_count
  #   @current_batch_count = pending_status_count
  #   # header part
    
  #   document_Amount = 0
  #   result_arr.each_with_index do |recharge, index|
  #     document_Amount += recharge.charge
  #   end

  #   header_row = "#{SUBSYSTEM_ID}#{UNIVERSITY_ID}#{DOCUMENT_NUM}#{RECORD_TYPE}#{DESCRIPTION}#{TRANSACTION_DATE}#{document_Amount}\n"
  # end

  # def get_detail_rows 
  #   detail_rows = ""
  #   result_arr.each_with_index do |recharge, index|
  #     sequence_num = index
  #     detail_rows += "#{SUBSYSTEM_ID}#{UNIVERSITY_ID}#{DOCUMENT_NUM}#{RECORD_TYPE}"
  #     detail_rows += "#{sequence_num}\n"
  #   end
  # end

  # def process_output
    
  # end
end