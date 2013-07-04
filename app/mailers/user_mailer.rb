class UserMailer < ActionMailer::Base
  default from: "noreply@slnky.me"

  def welcome_email(user)
    @user = user
    @url = 'http://slnky.me/login'
    mail(to: @user.email, subject: 'Thanks for signing up for Slinky!')
  end

end
