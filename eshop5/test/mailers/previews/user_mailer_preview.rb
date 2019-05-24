class UserMailerPreview < ActionMailer::Preview
  def password_reset_instructions
    User.first.reset_perishable_token!
    NotifierMailer.password_reset_instructions(User.first)
  end
end
