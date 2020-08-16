class Admins::OrdersController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_order, only: [:show, :update]

    def index
        if params[:customer_id]
            @customer = Customer.find(params[:customer_id])
            @orders = @customer.orders.page(params[:page]).reverse_order
        elsif params[:created_at] == "today"
            @orders = Order.ordered_today.includes(:customer).page(params[:page]).reverse_order
        else
            @orders = Order.includes(:customer).page(params[:page]).reverse_order
        end
    end
    
    def show
        @customer = @order.customer
        @order_details = @order.order_details.includes(:item)
    end
    
    def update
        if @order.update(order_params) && @order.confirm_deposit?
            @order.order_details.update_all(making_status: 1)
        end
        redirect_to admins_order_path(@order)
    end
    
    private
    def set_order
        @order = Order.find(params[:id])
    end
    
    def order_params
        params.require(:order).permit(:status)
    end
    
end
