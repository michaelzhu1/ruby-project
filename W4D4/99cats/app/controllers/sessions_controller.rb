class SessionsController < ApplicationController
  before_action :redirect_to_index
  skip_before_action :redirect_to_index, only: [:destroy]

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(user_params[:user_name], user_params[:password])
    if user
      user.reset_session_token!
      login!(user)
      redirect_to cats_url
    else
      flash[:errors] = ["Invalid username or password"]
      redirect_to new_session_url
    end
  end

  def destroy
    log_out!
    redirect_to cats_url
  end

  def redirect_to_index
    redirect_to cats_url if logged_in?
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end

end
