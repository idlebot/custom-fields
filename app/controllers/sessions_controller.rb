# SessionsController is responsible for handling login/logout
class SessionsController < ApplicationController

  def new

  end

  def create
    session_params = params[:session]
    user = User.find_by(email: session_params[:email].downcase)

    if user && user.authenticate(session_params[:password])
      session[:user_id] = user.id
      flash[:success] = 'You have successfully login'
      redirect_to contacts_path
    else
      flash.now[:danger] = 'There was something wrong with your login information'
      render 'new'
    end

  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'You have logged out'
    redirect_to root_path
  end

end
