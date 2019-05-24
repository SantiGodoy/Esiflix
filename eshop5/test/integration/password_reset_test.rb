# coding: utf-8
require File.dirname(__FILE__) + '/../test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest

  def setup
    User.create(:name => 'George Smith', :login => 'george', :email => 'george@emporium.com',
                :password => 'cheetah', :password_confirmation => 'cheetah')
  end

  test "forgot_password" do
    george = new_session_as(:george)
    george.goes_to_forgot_password_form
    george.sends_mistaken_email(:email => 'george@bookshop.com')
    george.sends_correct_email(:email => 'george@emporium.com')
    george.resets_mismatched_password(:user => { :id => User.first.id, :password => 'gold',
                                                 :password_confirmation => 'silver' })
    george.resets_correct_password(:user => { :id => User.first.id, :password => 'gold',
                                              :password_confirmation => 'gold' })
  end

  private

  module BrowsingTestDSL
    include ERB::Util
    attr_writer :name

    def goes_to_forgot_password_form
      get '/password_reset/new'
      assert_response :success
      assert_template 'password_reset/new'
      assert_select 'div#content' do
        assert_select 'h1', 'Restaurar contraseña'
        assert_select "input#email"
      end
    end

    def sends_mistaken_email(email)
      post_email(email)
      assert_response :success
      assert_template 'password_reset/new'
      assert_select 'div#content' do
        assert_select 'h1', 'Restaurar contraseña'
      end
      assert_equal flash[:notice], 'No se ha encontrado ningún usuario con ese email.'
      assert_select 'div#notice', 'No se ha encontrado ningún usuario con ese email.'
    end

    def sends_correct_email(email)
      post_email(email)
      mail = ActionMailer::Base.deliveries.last
      assert_equal ['george@emporium.com'], mail.to
      assert_equal 'noreply@esiflix.es', mail[:from].value
      assert_equal 'Instrucciones para restaurar contraseña', mail.subject
      assert_response :redirect
      follow_redirect!
      assert_response :success
      assert_template 'user_sessions/new'
      assert_select 'div#content' do
        assert_select 'h1', 'Iniciar sesión'
      end
      assert_equal flash[:notice], 'Las instrucciones para restaurar su contraseña se les han sido enviadas. Por favor, compruebe su email.'
      assert_select 'div#notice', 'Las instrucciones para restaurar su contraseña se les han sido enviadas. Por favor, compruebe su email.'
      assert_select 'input#user_session_login'
    end

    def resets_mismatched_password(parameters)
      user = User.find_by_id(parameters[:user][:id])
      edit_password_reset_url = url_for :controller => 'password_reset', :action => 'edit'
      edit_password_reset_url += "?id=#{user.perishable_token}"
      get edit_password_reset_url
      assert_response :success
      assert_template 'password_reset/edit'
      assert_select 'div#content' do
        assert_select 'h1', 'Editar contraseña'
        assert_select 'input#user_password'
        assert_select 'input#user_password_confirmation'
      end
      post '/password_reset/update', :params => parameters
      assert_response :success
      assert_template 'password_reset/edit'
      assert_select 'div#content' do
        assert_select 'h1', 'Editar contraseña'
        assert_select 'h2', 'Esta cuenta no puede ser creada debido a 1 error'
        assert_select 'li', "Password confirmation doesn\'t match Password"
        assert_select 'input#user_password'
        assert_select "div[class=\"field_with_errors\"]"
      end
    end

    def resets_correct_password(parameters)
      user = User.find_by_id(parameters[:user][:id])
      edit_password_reset_url = url_for :controller => 'password_reset', :action => 'edit'
      edit_password_reset_url += "?id=#{user.perishable_token}"
      get edit_password_reset_url
      assert_response :success
      assert_template 'password_reset/edit'
      assert_select 'div#content' do
        assert_select 'h1', 'Editar contraseña'
        assert_select 'input#user_password'
        assert_select 'input#user_password_confirmation'
      end
      post '/password_reset/update', :params => parameters
      assert_response :redirect
      follow_redirect!
      assert_response :success
      assert_template 'user/show'
      assert_equal flash[:notice], 'Contraseña actualizada correctamente. Usuario identificado.'
      assert_select 'div#content' do
        assert_select 'h1', user.name
        assert_select 'div#notice', 'Contraseña actualizada correctamente. Usuario identificado.'
        assert_select 'dt', 'Nombre'
        assert_select 'dd', user.login
      end
    end

    def post_email(email)
      post '/password_reset/create', :params => email
    end
  end

  def new_session_as(name)
    open_session do |session|
      session.extend(BrowsingTestDSL)
      session.name = name
      yield session if block_given?
    end
  end
end
