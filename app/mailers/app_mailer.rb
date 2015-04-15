class AppMailer < ActionMailer::Base
  def send_recharge_email(user, email_date, file_name, record_count)
    @user = user
    @email_date = email_date
    @file_name = file_name
    @record_count = record_count
    
    if Rails.env.production?
     mail to: "act-prodcontrol@ucsd.edu", from: user.email, subject: "ILL Billing Recharge File"
    else
     mail to: user.email, from: user.email, subject: "ILL Billing Recharge File" 
    end
  end
end
