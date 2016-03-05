class MessageBoardsController < ApplicationController
    before_action :logged_in_user, only: [:create]
    before_action :url_reset, only: [:index, :show]
    
    def index
        @message_boards = MessageBoard.all.order(updated_at: :desc)
        @message_board = current_user.message_boards.build
    end
    
    def create
        session[:url] ||= request.referrer
        @path = Rails.application.routes.recognize_path(session[:url])
        @message_board = current_user.message_boards.build(message_board_params)
        
        if @message_board.save
            session.delete(:url)
            flash[:success] = "MessageBoard created!"
            redirect_to @message_board
        else
            if @path[:controller] == "items"
                @item = Item.find(@path[:id])
                @want_users = @item.want_users
                @have_users = @item.have_users
                @message_boards = @item.message_boards.order(updated_at: :desc)
                render template: 'items/show'
                return
            else
                @message_boards = MessageBoard.all.order(updated_at: :desc)
                render action: 'index'
                return
            end
        end
    end
    
    def show
        @message_board = MessageBoard.find(params[:id])
        @message = current_user.messages.build
        @messages = @message_board.messages.order(updated_at: :asc)
    end
    
    def destroy
        @message_board = current_user.message_boards.find_by(id: params[:id])
        return redirect_to :back if @message_board.nil?
        @message_board.destroy
        flash[:success] = "MessageBoard deleted"
        redirect_to :back
    end
    
    private
    
    def message_board_params
        params.require(:message_board).permit(:title , :item_id)
    end
        
end
