# UsersController handles user account actions
class UsersController < ApplicationController

  before_action :require_logged_user, only: [:edit, :update]
  before_action :set_user, only: [:edit, :update]
  before_action :require_same_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Custom Field Editor, #{@user.name}"
      session[:user_id] = @user.id
      redirect_to contacts_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Your account was updated successfully"
      redirect_to contacts_path
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def require_same_user
      unless @user == current_user
        flash[:danger] = 'Operation requires account owner to be logged in'
        redirect_to root_path
      end
    end
end
