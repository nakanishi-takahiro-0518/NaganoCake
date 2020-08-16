class Customers::AddressesController < ApplicationController
    before_action :authenticate_customer!
    before_action :set_address, only: [:edit, :update, :destroy]

    def index
        @address  = Address.new
        @addresses = current_customer.addresses
    end
    
    def create
        # current_customer.addresses.newにするとエラー時にからレコードができてエラーになる。
        # ストロングパラメーターの中にユーザー情報入れて解決
        @address = Address.new(address_params)
        @addresses = current_customer.addresses
        @address.save ? (redirect_to addresses_path) : (render :index)
    end
    
    def edit
    end
    
    def update
        @address.update(address_params) ? (redirect_to addresses_path) : (render :edit)
    end
    
    def destroy
        @address.destroy
        redirect_to addresses_path
    end
    
    private
    def set_address
        @address = Address.find(params[:id])
    end
    
    def address_params
        params.require(:address).permit(:postal_code, :destination, :name).merge(customer_id: current_customer.id)
    end
    
end
