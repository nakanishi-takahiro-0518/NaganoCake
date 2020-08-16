class Order < ApplicationRecord

    belongs_to :customer
    has_many :order_details
    has_many :items, through: :order_details

    validates :postal_code, presence: true, format: { with: /\A\d{7}\z/ }
    validates :destination, presence: true
    validates :name, presence: true
    validates :shipping_cost, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
    validates :grand_total, presence: true, :numericality => { :greater_than_or_equal_to => 0 }

    scope :ordered_today, -> { where(created_at: Constants::BEGINNING_OF_TODAY...Constants::BEGINNING_OF_TOMORROW) }

    enum payment_method: { credit_card: 0, transfer: 1 }
    enum status: { waiting_deposit: 0, confirm_deposit: 1, in_production: 2, preparing_shipment: 3, shipped: 4 }


    def shipping_information(resource)
        class_name = resource.class.name
        if class_name == "Customer"
            self.postal_code = resource.postal_code
            self.destination = resource.destination
            self.name = resource.full_name
        elsif class_name == "Address"
            self.postal_code = resource.postal_code
            self.destination = resource.destination
            self.name = resource.name
        end
    end
    
    def complete(user)
        Order.transaction do
            self.save!
            user.cart_items.each do |item|
                OrderDetail.create!(order_id: self.id, item_id: item.item.id, price: item.item.price, amount: item.amount)
                item.destroy!
            end
        end
    end
    
    def all_details_completed?
        order_details.completed.count == order_details.count
    end
    
end
