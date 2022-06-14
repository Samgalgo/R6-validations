class OrdersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :set_customer, only: %i[ create update ] #unsure if i need this
  before_action :set_order, only: %i[ show edit destroy update]
  layout 'customer_layout'

  # GET /orders or /orders.json FOR INDEX
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json FOR SHOW
  def show
  end

  # GET /orders/new FOR NEW
  def new
    @order = Order.new
  end

  # GET /orders/1/edit FOR EDIT
  def edit
  end

  # POST /orders or /orders.json FOR CREATE
  def create
    @order = @customer.orders.create(order_params)
    if @order.save
      flash.notice = "The order record was created successfully."
      redirect_to @order
    else
      flash.now.alert = @order.errors.full_messages.to_sentence
      render :new  
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json FOR UPDATE
  def update
    if @order.update(order_params)
      flash.notice = "The order record was updated successfully."
      redirect_to @order
    else
      flash.now.alert = @order.errors.full_messages.to_sentence
      render :edit
    end
  end

  # DELETE /orders/1 or /orders/1.json FOR DESTROY
  def destroy
    @order.destroy
    redirect_to  customer_path(@order.customer_id) #order_path #unsure if this line is correct, once the order is
    # deleted we should go back to all the orders page, i believe.
  end


private
  def set_order
    @order = Order.find(params[:id])
  end

  def set_customer
    @customer = Customer.find(params[:order][:customer_id])
  end

  def order_params
    params.require(:order).permit(:product_name, :product_count, :customer_id)
  end

  def catch_not_found(e)
    Rails.logger.debug("We had a NOT found exception.")
    flash.alert = e.to_s
    redirect_to orders_path
  end  

end
