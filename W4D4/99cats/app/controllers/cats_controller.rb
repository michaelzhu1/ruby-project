class CatsController < ApplicationController

  # before_action :check_if_logged_in?
  before_action  :own_cats?
  # skip_before_action :check_if_logged_in?, only: [:index, :show]
  skip_before_action :own_cats?, only: [:index, :show]


  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  # def check_if_logged_in?
  #   unless logged_in?
  #
  #     redirect_to new_session_url
  #   end
  # end

  def own_cats?
    if logged_in?
      unless params[:id].nil?
        @cat = Cat.find(params[:id])
        unless current_user.cats.include?(@cat)
          flash[:errors] = ["Not your damn cat!"]
          redirect_to cats_url
        end
      end
    else
      flash[:errors] = ["Must be logged in to edit/create cats"]
      redirect_to new_session_url
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :description, :name, :sex)
  end
end
