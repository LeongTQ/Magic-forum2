class UsersController < ApplicationController

  def new #GET
    @user= User.new
  end

  def create #POST
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Thank you. You're now registered."
      redirect_to root_path
    else
      flash[:danger] = @user.errors.full_messages
      render :new
    end
  end

  def edit
    @user = User.friendly.find(params[:id])
  end

  def update
    @user = User.friendly.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :image, :role, :password_reset_token, :password_reset_at)
  end

end
