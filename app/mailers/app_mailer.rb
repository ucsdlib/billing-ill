#---
# @author hweng@ucsd.edu
#---

class AppMailer < ActionMailer::Base
  def send_recharge_email(user, email_date, file_name, record_count)
    @user = user
    @email_date = email_date
    @file_name = file_name
    @record_count = record_count

    send_mail_to(user.email, "ILL Billing Recharge File")
  end

  def send_invoice_email(user, email_date, file_name, lfile_name, record_count)
    @user = user
    @email_date = email_date
    @charge_file = file_name[:charge]
    @entity_file = file_name[:entity]
    @person_file = file_name[:person]
    @lcharge_file = lfile_name[:charge]
    @lentity_file = lfile_name[:entity]
    @lperson_file = lfile_name[:person]
    @charge_count = record_count[:charge]
    @entity_count = record_count[:entity]
    @person_count = record_count[:person]

    send_mail_to(user.email, "ILL Billing Invoice File")
  end

  def send_mail_to(mail_address,subject)
    if Rails.env.production?
     mail to: "act-prodcontrol@ucsd.edu", from: mail_address, subject: subject
    else
     mail to: mail_address, from: mail_address, subject: subject 
    end
  end
end

