class SessionController < ApplicationController
  def new
  end

  def create
    auth = Account.authenticate(params[:email], params[:password])
    if auth
      session[:user_id] = auth.user_id
      flash[:notice] = 'Logged in!'
      redirect_to session[:return_to] || root_path
    else
      redirect_to action: 'new', alert: 'Wrong user name or password!'
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'Logged out!'
  end
end
