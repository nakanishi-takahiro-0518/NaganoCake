class Admins::ItemsController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_item, only: [:edit, :show, :update]

    def index
        if params[:genre_id]
            @genre = Genre.find(params[:genre_id])
            @items = @genre.items.page(params[:page])
        else
            @items = Item.all.page(params[:page])
        end
        @items_count = @items.count
    end
    
    def create
        @item.new(item_params)
        @item.save ? (redirect_to admins_item_path(@item)) : (render :new)
    end
    
    def new
        @item = Item.new
    end
    
    def edit
    end
    
    def show
    end
    
    def update
        @item.update(item_params) ? (redirect_to admins_item_path(@item)) : (render :edit)
    end
    
    private
    def item_params
        params.require(:item).permit(:genre_id, :name, :introduction, :image, :price, :is_active)
    end
    
    def set_item
        @item = Item.find(params[:id])
    end
    
end
