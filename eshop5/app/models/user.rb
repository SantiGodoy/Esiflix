# coding: utf-8
class User < ApplicationRecord
  acts_as_authentic do |a|
    a.validate_login_field = true
    a.validate_password_field = true
    a.validates_length_of_password_field_options = { minimum: 4 }
    a.require_password_confirmation = true
    a.validates_length_of_password_confirmation_field_options = { minimum: 4 }
    a.logged_in_timeout = 5.minutes # default is 10.minutes
    # default encryption system uses "SCrypt" and requires 'scrypt' gem
    # for using previous encryption system uncomment next statement
    # a.crypto_provider = Authlogic::CryptoProviders::Sha512
  end

  validates_presence_of :name, :login, :email, :password, :password_confirmation, :message => 'no puede estar vacío'
  validates_length_of :name, :in => 3..225, :message => 'es demasiado corto (mínimo 3 caracteres)'
  validates_uniqueness_of :name, :login, :email, :message => 'ya existe'

  def deliver_password_reset_instructions
    self.reset_perishable_token!
    save(validate: false)
    
    Notifier.password_reset_instructions(self).deliver_now
  end
end
