module BatchUpdate
  extend ActiveSupport::Concern

  # included do
  #   before_create :generate_token
  # end

   def self.batch_update_status_field

    begin
      batch_update_status_item
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid record"
    end
    
  end

  def self.batch_update_status_item
    result_arr = Recharge.search_all_pending_status

    ActiveRecord::Base.transaction do
      result_arr.each do |ref_row|
        # add bang after update_attributes so that if it is not saved, it will raise error and roll back whole transaction.
        ref_row.update_attributes!(status: "submitted", submitted_at: Time.now ) 
      end
    end
  end
end