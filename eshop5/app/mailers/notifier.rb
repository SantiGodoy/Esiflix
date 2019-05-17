# coding: utf-8
class Notifier < ActionMailer::Base
  def password_reset_instructions(user)
    @url = edit_password_reset_url(token: user.perishable_token)
    
    mail to: user.email, from: "noreply@esiflix.es",:subject => "Instrucciones para restaurar contraseña"
  end
end
