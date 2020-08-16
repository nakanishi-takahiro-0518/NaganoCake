class Customers::CartItemsController < ApplicationController
    before_action :authenticate_customer!
    before_action :set_cart_item, only: [:create, :update, :destroy]

    def index
        @cart_items = current_customer.cart_items
    end
    
    def create
        if @cart_item
            @cart_item.update(cart_item_params)
            redirect_to cart_items_path
        else
            @cart_item = current_customer.cart_items.new(cart_item_params)
            @cart_item.item_id = @item.id
            @cart_item.save ? (redirect_to cart_items_path) : (render 'customers/items/show')
        end
    end
    
    def update
        @cart_item.update(cart_item_params)
        redirect_to cart_items_path
    end
    
    def destroy
        @cart_item.destroy
        redirect_to cart_items_path
    end
    
    def destroy_all
        current_customer.cart_items.destroy_all
        redirect_to cart_items_path
    end
    
    private

    def set_cart_item
        @item = Item.find(params[:item_id])
        @cart_item = current_customer.has_in_cart(@item)
    end
    
    def cart_item_params
        params.require(:cart_item).permit(:amount)
    end
    
end
