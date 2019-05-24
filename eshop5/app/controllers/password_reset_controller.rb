# coding: utf-8
class PasswordResetController < ApplicationController
  before_action :require_no_user

  def new
    @page_title = 'Restaurar contraseña'
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.reset_perishable_token!
      NotifierMailer.password_reset_instructions(@user).deliver_now
      flash[:notice] = 'Las instrucciones para restaurar su contraseña se les han sido enviadas. ' +
                       'Por favor, compruebe su email.'
      redirect_to :controller => 'user_sessions', :action => 'new'
    else
      @page_title = 'Restaurar contraseña'
      flash[:notice] = 'No se ha encontrado ningún usuario con ese email.'
      render :action => :new
    end
  end

  def edit
    load_user_using_perishable_token
    @page_title = 'Editar contraseña'
  end

  def update
    @user = User.find_by_id(params[:user][:id])
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = 'Contraseña actualizada correctamente. Usuario identificado.'
      redirect_to :controller => 'user', :action => 'show'
    else
      @page_title = 'Editar contraseña'
      render :action => :edit
    end
  end

  private
    def load_user_using_perishable_token
      @user = User.find_using_perishable_token(params[:id])
      unless @user
        flash[:notice] = 'Su cuenta no ha sido localizada. ' +
                         'Si no puedes usar directamente la url del email, ' +
                         'prueba a copiarla y pegarla en su navegador o ' +
                         'reinicia el proceso de restauración de contraseña.'
        redirect_to :controller => 'user_sessions', :action => 'new'
      end
    end
end

