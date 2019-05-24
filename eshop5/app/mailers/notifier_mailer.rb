# encoding: utf-8
class NotifierMailer < ActionMailer::Base
  def password_reset_instructions(user)
    @edit_password_reset_url = url_for :controller => 'password_reset', :action=> 'edit'
    @edit_password_reset_url += "?id=#{user.perishable_token}"
    @user = user
    mail to: user.email, from: "noreply@esiflix.es",:subject => "Instrucciones para restaurar contraseña"
  end
end
