class Customers::OrdersController < ApplicationController
    before_action :authenticate_customer!
    before_action :ensure_cart_items, only: [:new, :confirm, :create, :error]

    def new
        @order = Order.new
    end
    
    def confirm
        @order = Order.new(order_params)
        if params[:select_address] == "0"
            @order.shipping_infomation(current_customer)
        elsif params[:select_address] == "1"
            @order.shipping_information(current_customer.addresses.find(params[:address_id]))
        elsif params[:select_address] == "2"
            # 不要
        else
            render :new
        end
    end
    
    def create
        @order = current_customer.orders.new(order_params)
        @order.complete(current_customer) ? (redirect_to thanks_path) : (render :new)
    end
    
    def thanks
    end
    
    def index
        @orders = current_customer.orders.includes(:order_details, :items).page(params[:page]).reverse_order
    end
    
    def show
        @order = Order.find(params[:id])
        @order_details = @order.order_details.includes(:item)
    end
    
    private

    def order_params
        params.require(:order).permit(:postal_code, :destination, :name, :payment_method, :grand_total).merge(shipping_cost: 800)
    end
    
    def ensure_cart_items
    @cart_items = current_customer.cart_items.includes(:item)
    redirect_to items_path unless @cart_items.first
  end
end
