# coding: utf-8
class Admin::FilmController < ApplicationController
  def new
    load_data
    @film = Film.new
    @page_title = 'Crear nueva película'
  end
  
  def create
    @film = Film.new(film_params)
    if @film.save
      flash[:notice] = "Película #{@film.title} creada correctamente."
      redirect_to :action => 'index'
    else
      load_data
      @page_title = 'Crear nueva película'
      render :action => 'new'
    end
  end
  
  def edit
    load_data
    @film = Film.find(params[:id])
    @page_title = 'Editar película'
  end
  
  def update
    @film = Film.find(params[:id])
    if @film.update_attributes(film_params)
      flash[:notice] = "Película #{@film.title} actualizada correctamente."
      redirect_to :action => 'show', :id => @film
    else
      load_data
      @page_title = 'Editar película'
      render :action => 'edit'
    end
  end

  def destroy
    @film = Film.find(params[:id])
    @film.destroy
    flash[:notice] = "Película #{@film.title} eliminada correctamente."
    redirect_to :action => 'index'
  end

  def show
    @film = Film.find(params[:id])
    @page_title = @film.title
  end

  def index
    sort_by = params[:sort_by]
    @films = Film.order(sort_by).paginate(:page => params[:page], :per_page => 5)
    @page_title = 'Listado de películas'
  end

  private

    def load_data
      @directors = Director.all
      @producers = Producer.all
    end

    def film_params
      params.require(:film).permit(:title, :producer_id, :produced_at, { :director_ids => [] },
                                   :kind, :blurb, :price, :duration, :cover_image)
    end
end
