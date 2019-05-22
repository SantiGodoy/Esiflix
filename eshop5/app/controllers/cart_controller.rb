# coding: utf-8
class CartController < ApplicationController
  before_action :initialize_cart

  def add
    @film = Film.find params[:id]
    @page_title = 'Añadir artículo'
    respond_to do |format|
      format.js { @item = @cart.add params[:id]
        flash.now[:cart_notice] = "Añadido <em>#{@item.film.title}</em>"
        render :controller => 'cart', :action => 'add_with_ajax' }
      format.html {
        if request.post?
          @item = @cart.add params[:id]
          flash[:cart_notice] = "Añadido <em>#{@item.film.title}</em>."
          redirect_to :controller => 'catalog'
        else
          render :controller => 'cart', :action => 'add', :template => 'cart/add'
        end }
    end
  end
  
  def remove
    @film = Film.find params[:id]
    @page_title = 'Eliminar artículo'
    respond_to do |format|
      format.js { @item = @cart.remove params[:id]
        flash.now[:cart_notice] = "Eliminado <em>#{@item.film.title}</em>"
        render :controller => 'cart', :action => 'remove_with_ajax' }
      format.html { if request.post?
        @item = @cart.remove params[:id]
        flash[:cart_notice] = "Eliminado <em>#{@item.film.title}</em>."
        redirect_to :controller => 'catalog'
      else
        render :controller => 'cart', :action => 'remove', :template => 'cart/remove'
      end }
    end
  end

  def clear
    @page_title = 'Vaciar carrito'
    respond_to do |format|
      format.js { @cart.cart_items.destroy_all
        flash.now[:cart_notice] = "Carrito vaciado"
        render :controller => 'cart', :action => 'clear_with_ajax' }
      format.html { if request.post?
        @cart.cart_items.destroy_all
        flash[:cart_notice] = "Carrito vaciado."
        redirect_to :controller => 'catalog'
      else
        render :controller => 'cart', :action => 'clear', :template => 'cart/clear'
      end }
    end
  end
end
  
