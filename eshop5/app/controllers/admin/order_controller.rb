class Admin::OrderController < ApplicationController
  def close
    order = Order.find(params[:id])
    order.close
    flash[:notice] = "El pedido ##{order.id} ha sido cerrado."
    redirect_to :action => 'index'
  end

  def show
    @order = Order.find(params[:id])
    @page_title = "Mostrando pedido ##{@order.id}"
  end

  def index
    @status = params[:id]
    if @status.blank?
      conditions = nil
      @status = 'all'
      @page_title = 'Listando todos los pedidos'
    else
      conditions = "status = '#{@status}'"
      @estado = 'abierto' if @status == 'open'
      @estado = 'procesado' if @status == 'processed'
      @estado = 'cerrado' if @status == 'closed'
      @estado = 'fallido' if @status == 'failed'
      @page_title = "Listando pedidos #{@estado.pluralize}"
    end
    @orders = Order.where(conditions).paginate(:page => params[:page], :per_page => 10)
  end
end
