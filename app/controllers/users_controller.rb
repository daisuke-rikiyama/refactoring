class UsersController < ApplicationController
    before_action :set_user, only: [:show]
    def new
      @user = User.new
    end
    
    def create
      @user = User.new(user_params)
      if @user.save
        @user.send_activation_email
        flash[:info] = "メールをチェックしてアカウントを有効化してください。"
        redirect_to root_url
      else
        render 'new'
      end
    end
    
    def show
      @items = @user.items.group('items.id')
    end
    
    def message_boards
      @user = User.find(params[:user_id])
      @message_boards = @user.message_boards.order(updated_at: :desc)
      @favorite_boards = @user.favorited_message_boards
    end
    
    private
    
    def set_user
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
