class UsersController < ApplicationController
  before_action :redirect_to_index

  def new
    render :new
  end

  def create
    user = User.new(user_params)
    # byebug
    if user.save
      user.reset_session_token!
      login!(user)
      redirect_to cats_url
    else
      flash[:errors] = user.errors.full_messages
      # byebug
      redirect_to new_user_url
    end
  end

  def redirect_to_index
    redirect_to cats_url if logged_in?
  end

  
  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
