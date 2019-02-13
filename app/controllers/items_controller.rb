class ItemsController < ApplicationController
  include GetCategories
  include GetPoints
  before_action :get_root
  before_action :set_item, only: [:show, :own]
  before_action :get_category_tree, only: [:show, :own]
  before_action :total_point, only: [:show]

  def index
    @items = Item.with_category.includes(:item_photos, :favorite_items).new_arrival
    @ladies_items = @items.search_with_root_id(1).first(4)
    @mens_items = @items.search_with_root_id(2).first(4)
    @baby_items = @items.search_with_root_id(3).first(4)
    @cosme_items = @items.search_with_root_id(7).first(4)
  end

  def show
  end

  def buy
  end

  def new
    @item = Item.new
    10.times { @item.item_photos.build }
  end

  def create
    item  = Item.new(item_params)
    if item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def onsale
    @items = Item.includes(:item_photos).where(user_id: current_user.id).new_arrival
  end

  def show
    @users_item = Item.includes(:item_photos, :favorite_items).where(user_id: @item.user_id).all
    @previous = @item.next_to_item("previous")
    @next_item = @item.next_to_item("next_item")
  end

  def own
  end

  def edit
  end

  def update
  end

  def destroy
    item = Item.find(params[:id])
    if item.user_id == current_user.id
      item.destroy
      redirect_to onsale_user_items_path, flash: {success: '商品を削除しました'}
    end
  end

  def search
    @items = Item.includes([:item_photos, :category]).where('items.name LIKE ? OR comment LIKE ?', "%#{params[:keyword]}%", "%#{params[:keyword]}%").page(params[:page]).per(NUM_PER_PAGE)
  end

  private

  def item_params
    params.require(:item).permit(:name, :comment, :category_id, :brand_id, :shipping_fee, :prefecture_id, :days_to_ship, :price, :condition, :closed, item_photos_attributes: [:image]).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.includes([:user, :item_photos, :category, :favorite_items]).find(params[:id])
  end

  def get_category_tree
    category = Category.find(@item.category_id)
    categories = category.ancestry.split('/')
    if categories.length == 3
      @parent_category, @child_category, @grandchild_category = Category.find(categories)
    else
      @parent_category, @child_category = Category.find(categories)
      @grandchild_category = Category.find(@item.category_id)
    end
  end


end
