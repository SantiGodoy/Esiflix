# coding: utf-8
class UserSessionsController < ApplicationController
  before_action :require_no_user, :only => [:new, :create]

  def new
    @user_session = UserSession.new
    @page_title = 'Iniciar sesión'
  end

  def create
    @user_session = UserSession.new(user_session_params)
    @user_session.remember_me = false # just in case
    if @user_session.save
      flash[:notice] = "Sesión iniciada correctamente."
      redirect_back_or_default :controller => '/admin/director', :action => :index # default login route
    else
      render :action => :new
    end
  end

  def destroy
    if current_user_session # only for an authenticated user
      current_user_session.destroy
      flash[:notice] = "Sesión cerrada correctamente."
    end  
    redirect_to :controller => :catalog, :action => :index # logout route
  end

  private
    def user_session_params
      params.require(:user_session).permit(:login, :password, :remember_me)
    end
end
