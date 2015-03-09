class WelcomeEmail < ApplicationMailer
  def welcome(account)
    @user = account.user
    @email = account.email
    @url = 'http://localhost:3000/log_in'
    mail(to: @email, subject: 'Welcome to Bookparking.')
  end
end
