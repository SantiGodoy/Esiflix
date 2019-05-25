# coding: utf-8
class CatalogController < ApplicationController
  before_action :initialize_cart, :except => :show
  #before_action :require_no_user

  def show
    @film = Film.find(params[:id])
    @page_title = @film.title
  end

  def index
    @films = Film.order("films.id desc").includes(:directors, :producer).paginate(:page => params[:page], :per_page => 5)
    @page_title = 'Catálogo'
  end

  def latest
    @films = Film.latest 5 # invoques "latest" method to get the five latest films
    @page_title = 'Últimas películas'
  end

  def rss
    latest
    render :layout => false
    response.headers["Content-Type"] = "application/xml; version=1.0; charset=utf-8"
  end
  
  def search
    @page_title = "Buscar"
    if params[:commit] == "Buscar" || params[:q]
      @films = Film.where 'title LIKE ?', "%#{params[:q]}%"
      unless @films.size > 0
        flash.now[:notice] = "No se ha encontrado la película."
      end
    end
  end
end
