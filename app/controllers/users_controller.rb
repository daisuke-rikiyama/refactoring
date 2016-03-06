class UsersController < ApplicationController
    before_action :set_user, only: [:show]
    
    def show
      @items = @user.items.group('items.id')
    end
    
    def message_boards
      @message_boards = current_user.message_boards.order(updated_at: :desc)
      @favorite_boards = current_user.favorited_message_boards
    end
    
    private
    
    def set_user
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end