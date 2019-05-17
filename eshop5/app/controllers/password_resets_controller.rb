# coding: utf-8
class PasswordResetsController < ApplicationController
  before_action :require_no_user
  before_action :load_user_using_perishable_token, :only => [ :edit, :update ]
 
  def new
  end
 
  def create
    @user = User.where(email: params[:email]).first
    if @user
      @user.deliver_password_reset_instructions
      flash[:notice] = "Le hemos enviado a su correo electrónico las instrucciones a seguir para restaurar su contraseña."
      redirect_to root_path
    else
      flash.now[:error] = "No se ha encontrado un usuario con el correo electrónico #{params[:email]}."
      render :action => :new
    end
  end
 
  def edit
    load_user_using_perishable_token
    @token = @user.perishable_token
  end
 
  def update
    load_user_using_perishable_token
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    
    if @user.save
      flash[:notice] = "Su contraseña ha sido modificada con éxito."
      redirect_to :controller => :catalog, :action => :index
    else
      @user.errors
      render :action => :edit
    end
  end
 
 
  private
 
  def load_user_using_perishable_token
    @user = User.where(perishable_token: params[:token]).first
    unless @user
      flash[:error] = "Lo sentimos, pero no hemos podido localizar su cuenta."
      redirect_to root_url
    end
  end
end
