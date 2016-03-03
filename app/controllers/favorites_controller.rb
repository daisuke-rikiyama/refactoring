class FavoritesController < ApplicationController
    before_action :logged_in_user
    
    def create
        @message_board = MessageBoard.find(params[:message_board_id])
        current_user.add_favorite(@message_board)
    end
    
    def destroy
        @message_board = current_user.favorites.find(params[:id]).message_board
        current_user.release_favorite(@message_board)
    end
end
