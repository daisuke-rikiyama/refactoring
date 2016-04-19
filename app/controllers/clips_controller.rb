class ClipsController < ApplicationController
    before_action :logged_in_user
    
    def index
        @clips = current_user.clips
    end
    
    def create
        @message_board = MessageBoard.find(params[:message_board_id])
        @message = Message.find(params[:message_id])
        current_user.clip(@message)
    end
    
    def destroy
        @message_board = MessageBoard.find(params[:message_board_id])
        @message = current_user.clips.find(params[:id]).message
        current_user.unclip(@message)
    end
end
