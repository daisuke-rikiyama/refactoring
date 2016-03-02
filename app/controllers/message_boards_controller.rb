class MessageBoardsController < ApplicationController
    before_action :logged_in_user, only: [:create]
    
    def index
        @message_boards = MessageBoard.all.order(updated_at: :desc)
        @message_board = current_user.message_boards.build
    end
    
    def create
        @message_board = current_user.message_boards.build(message_board_params)
        
        if @message_board.save
            flash[:success] = "MessageBoard created!"
            redirect_to @message_board
        else
            flash[:danger] = "Failed to create!!"
            redirect_to :back
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
    def general_board_params
        params.require(:message_board).permit(:title)
    end
    
    def message_board_params
        params.require(:message_board).permit(:title, :item_id)
    end
end
