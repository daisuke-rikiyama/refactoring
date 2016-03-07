class SessionsController < ApplicationController
    def new
    end
    
    def create
        @user = User.find_by(email: params[:session][:email].downcase)
        if @user && @user.authenticate(params[:session][:password])
            log_in @user
            params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
            flash[:info] = "logged in as #{@user.name}"
            redirect_to @user
        else
            flash[:danger] = 'invalid email/password combination'
            render 'new'
        end
    end
    
    def destroy
        log_out if logged_in?
        redirect_to root_path, notice: "またのご利用をお待ちしております。"
    end
end
