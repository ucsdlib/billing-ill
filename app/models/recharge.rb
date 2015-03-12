#---
# by hweng@ucsd.edu
#---

class Recharge < ActiveRecord::Base
  belongs_to :fund

  validates :charge, presence: true, format: { :with => /\A\d+(?:\.\d{0,2})?\z/ }, numericality: {greater_than: 0, less_than: 1000000}
  validates :number_copies, presence: true
  validates :status, presence: true 
  validates :fund_id, presence: true

  delegate :org_code, to: :fund, prefix: :fund
  delegate :index_code, to: :fund, prefix: :fund
  delegate :fund_code, to: :fund, prefix: :fund
  delegate :program_code, to: :fund, prefix: :fund

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

  
end