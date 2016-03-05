class ItemsController < ApplicationController
  before_action :logged_in_user , except: [:show]
  before_action :set_item, only: [:show]
  before_action :url_reset, only: [:show]

  def new
    if params[:q]
      response = Amazon::Ecs.item_search(params[:q] , 
                                  :search_index => 'All' , 
                                  :response_group => 'Medium' , 
                                  :country => 'jp')
      @amazon_items = response.items
    end
  end

  def show
    @want_users = @item.want_users
    @have_users = @item.have_users
    @message_boards = @item.message_boards.order(updated_at: :desc)
    @message_board = current_user.message_boards.build(item_id: @item.id)
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end
end
