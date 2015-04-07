class AppMailer < ActionMailer::Base
  def send_recharge_email(user)
    @user = user

    mail to: "xxx", from: user.email, subject: "ILL Billing Recharge File"
  end
end