class MessagesController < ApplicationController
    before_action :logged_in_user, only: [:create, :edit]
    before_action :set_message, only: [:edit, :update]
    
    def create
        @message = current_user.messages.build(message_params)
        
        if @message.save
            flash[:success] = "Message created!"
            redirect_to :back
        else
            flash[:danger] = "Failed to create!!"
            redirect_to :back
        end
    end
    
    def destroy
        @message = current_user.messages.find_by(id: params[:id])
        return redirect_to :back if @message.nil?
        @message.destroy
        flash[:success] = "Message deleted"
        redirect_to :back
    end
    
    def edit
    end
    
    def update
        if @message.update(message_params)
            # 保存に成功した場合は掲示板ページへリダイレクト
            redirect_to message_board_path(id: params[:message_board_id]), notice: "メッセージを編集しました。"
        else
            #保存に失敗した場合は編集画面へ戻す
            render 'edit'
        end
    end
    
    private
    def message_params
        params.require(:message).permit(:message_board_id, :content)
    end
    
    def set_message
        @message = Message.find(params[:id])
    end
end
