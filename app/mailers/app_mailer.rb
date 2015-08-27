#---
# @author hweng@ucsd.edu
#---

class AppMailer < ActionMailer::Base
  def send_recharge_email(user, email_date)
    @user = user
    @email_date = email_date
    @file_name = Recharge.create_file
    @record_count = Recharge.search_all_pending_status.size + 2

    send_mail_to(user.email, "ILL Billing Recharge File")
  end

  def send_invoice_email(user, email_date)
    @user = user
    @email_date = email_date
    @charge_count = Invoice.search_all_pending_status.size + 2
    @entity_count = Invoice.get_entity_count + 2
    @person_count = Invoice.get_person_count + 2
    @charge_file = Invoice.create_charge_file
    @entity_file = Invoice.create_entity_file
    @person_file = Invoice.create_person_file
    @lcharge_file = Invoice.get_charge_lfile_name
    @lentity_file = Invoice.get_entity_lfile_name
    @lperson_file = Invoice.get_person_lfile_name

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

