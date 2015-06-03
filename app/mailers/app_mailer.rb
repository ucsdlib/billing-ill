#---
# @author hweng@ucsd.edu
#---

class AppMailer < ActionMailer::Base
  def send_recharge_email(user, email_date, file_name, record_count)
    @user = user
    @email_date = email_date
    @file_name = file_name
    @record_count = record_count
    
    if Rails.env.production?
     mail to: "act-prodcontrol@ucsd.edu", from: user.email, subject: "ILL Billing Recharge File Uploaded."
    else
     mail to: user.email, from: user.email, subject: "ILL Billing Recharge File" 
    end
  end

  def send_invoice_email(user, email_date, file_name, record_count)
    @user = user
    @email_date = email_date
    @charge_file = file_name[:charge]
    @entity_file = file_name[:entity]
    @person_file = file_name[:person]
    @charge_count = record_count[:charge]
    @entity_count = record_count[:entity]
    @person_count = record_count[:person]
    
    if Rails.env.production?
     mail to: "act-prodcontrol@ucsd.edu", from: user.email, subject: "ILL Billing Invoice File"
    else
     mail to: user.email, from: user.email, subject: "ILL Billing Invoice File Uploaded." 
    end
  end
end

