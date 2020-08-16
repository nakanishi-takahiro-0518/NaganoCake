class Customers::CustomersController < ApplicationController
    before_action :authenticate_customer!
    before_action :set_current_customer

    def show
    end
    
    def edit
    end
    
    def update
        @customer.update(customer_params) ? (redirect_to mypage_path) : (render :edit)
    end
    
    def unsubscribe
    end

    def withdraw
        @customer.update(is_active: false)
        reset_session
        redirect_to root_path
    end
    private

    def set_current_customer
        @customer = current_customer
    end
    
    def customer_params
    params.require(:customer).permit(:last_name, :first_name, :first_name_kana, :last_name_kana, :email, :postal_code, :address, :telephone_number)
    end
    
end
