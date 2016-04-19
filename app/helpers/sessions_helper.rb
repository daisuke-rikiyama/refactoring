module SessionsHelper
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !!current_user
  end
  
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
    session[:expires_at] = Time.zone.now
  end
  
  # ユーザーを永続的セッションに記憶する
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # ユーザーの永続セッションを忘れる
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # 現在のユーザーをログアウトする
  def log_out
    current_user.forget
    session.delete(:user_id)
    @current_user = nil
  end
  
  # セッションタイムアウトの設定
  def time_out
    if logged_in? && !cookies.signed[:user_id]
      if session[:expires_at] < 60.minutes.ago
        session.delete(:expires_at)
        log_out
        redirect_to root_url, notice: "セッションタイムアウト。再ログインしてください。"
      else
        session[:expires_at] = Time.zone.now
      end
    end
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
  
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
end