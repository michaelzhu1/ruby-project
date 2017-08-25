class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?


  def current_user
    # byebug
    User.find_by(session_token: session[:session_token])
  end

  def login!(user)
    session[:session_token] = user.session_token
  end

  def log_out!
    current_user.reset_session_token! if current_user
    session[:session_token] = ""
  end

  def logged_in?
    return false if current_user.nil?
    session[:session_token] == current_user.session_token
  end


end
