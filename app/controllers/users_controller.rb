class UsersController < ApplicationController

  before_action :authenticate!, only: [:edit, :update]

  def new #GET
    @user = User.new
  end

  def create #POST
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Thank you. You're now registered."
      redirect_to root_path
    else
      flash[:danger] = @user.errors.full_messages
      redirect_to root_path
    end
  end

  def edit
    @user = User.friendly.find(params[:id])
    authorize @user
  end

  def update
    @user = User.friendly.find(params[:id])
    authorize @user

    if @user.update(user_params)
      flash[:success] = "Updated!"
      redirect_to root_path
    else
      flash[:danger] = @user.errors.full_messages
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :image, :role, :password_reset_token, :password_reset_at)
  end

end
