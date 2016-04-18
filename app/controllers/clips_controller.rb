class ClipsController < ApplicationController
    before_action :logged_in_user
    
    def create
        @message = Message.find(params[:message_id])
        current_user.clip(@message)
    end
    
    def destroy
        @message = current_user.clips.find(params[:id]).message
        current_user.unclip(@message)
    end
end
