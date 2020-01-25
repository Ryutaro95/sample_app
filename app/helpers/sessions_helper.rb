module SessionsHelper

  # 引数で渡されたユーザーでログイン
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    # cookies に 有効期限 20年、ユーザーIDが暗号化され保存される
    cookies.permanent.signed[:user_id] = user.id
    # cookies の remember_token に有効期限 20年で保存される
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 渡されたユーザーがログイン済みユーザーであれば true を返す
  def current_user?(user)
    user == current_user
  end

  # 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていれば true、その他なら false を返す
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 記憶したURL（もしくはデフォルト値）にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    # request.original_url でリクエスト先を取得
    # request.get? でGETリクエストが送信されたときのみ session[:forwarding_url] に格納
    session[:forwarding_url] = request.original_url if request.get?
  end
end