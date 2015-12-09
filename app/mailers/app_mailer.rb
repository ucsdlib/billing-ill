# encoding: utf-8
#---
# @author hweng@ucsd.edu
#---

class AppMailer < ActionMailer::Base
  def send_recharge_email(user, email_date)
    @user = user
    @email_date = email_date
    @file_name = Recharge.create_file
    @record_count = Recharge.search_all_pending_status.size + 2
    
    send_mail_to(user.email, 'ILL Billing Recharge File')
  end

  def send_invoice_email(user, email_date)
    @user = user
    @email_date = email_date
    @charge_count = Invoice.search_all_pending_status.size + 2
    @entity_count = Invoice.entity_count + 2
    @person_count = Invoice.person_count + 2
    @charge_file = Invoice.charge_file_name
    @entity_file = Invoice.entity_file_name
    @person_file = Invoice.person_file_name
    @lcharge_file = Invoice.charge_lfile_name
    @lentity_file = Invoice.entity_lfile_name
    @lperson_file = Invoice.person_lfile_name

    send_mail_to(user.email, 'ILL Billing Invoice File')
  end

  def send_mail_to(mail_address, subject)
    recipients = "#{Rails.configuration.emails_recipients}#{mail_address}"
    
    mail to: recipients, from: mail_address, subject: subject
  end
end
