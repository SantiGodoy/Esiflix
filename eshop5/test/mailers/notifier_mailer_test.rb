# encoding: utf-8
require'test_helper'
class NotifierMailerTest < ActionMailer::TestCase
  test 'password_reset_instructions' do
    @user=User.create(:name=>'GeorgeJackson',
		:login=>'George',
		:email=>'godoy.programmer@gmail.com',
		:password=>'silver',
		:password_confirmation=>'silver')
    mail = NotifierMailer.password_reset_instructions(@user)
    assert_equal 'Instrucciones para restaurar contraseña', mail.subject
    assert_equal ['godoy.programmer@gmail.com'], mail.to
    assert_equal ['noreply@esiflix.es'], mail.from
    assert_match "Estimado #{@user.name}:", mail.body.encoded
    @edit_password_reset_url = "http://localhost:3000/password_reset/edit?id=#{@user.perishable_token}"
    assert_match @edit_password_reset_url, mail.html_part.body.encoded
    assert_match @edit_password_reset_url, mail.text_part.body.encoded
  end
end
