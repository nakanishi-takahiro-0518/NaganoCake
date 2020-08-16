class Customers::ItemsController < ApplicationController
  def top

  end

  def index
    @genres = Genre.where(is_active: true)
    if params[:genre_id]
      @genre = @genres.find(params[:genre_id])
      all_items = @genre.items
    else
      all_items = Item.where(is_active: true)
    end
    @items = all_items.page(params[:page]).per(12)
    @all_items_count = all_items.count
  end
  
  def show
    @item = Item.find(params[:id])
    @genres = Genre.where(is_active: true)
    @cart_item = CartItem.new
  end
  
end
