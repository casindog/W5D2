class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def log_in_user(user)
    session[:session_token] = user.reset_session_token!
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def logged_in?
    !!current_user
  end

  def require_log_in
    redirect_to new_session_url unless logged_in?
  end

  def log_out
    current_user.reset_session_token!
    session[:session_token] = nil
  end
end
