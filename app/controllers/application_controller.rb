class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_person
  helper_method :logged_in?

  private

  def current_person
    Person.find(session[:user_id]) if session[:user_id]
  end

  def authenticate_user
    session[:return_to] = request.fullpath
    redirect_to log_in_path, alert: 'You are not logged in!' unless session[:user_id].present?
  end

  def logged_in?
    session[:user_id].present?
  end
end
