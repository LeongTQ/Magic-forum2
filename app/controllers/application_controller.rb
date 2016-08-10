class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Pundit
   protect_from_forgery with: :exception

   rescue_from Pundit::NotAuthorizedError do |exception|
     flash[:danger] = "You're not authorized"
     redirect_to request.referrer || root_path
   end

  private

  def authenticate!
    unless current_user
      redirect_to root_path
      flash[:danger] = "You need to login first"
    end
  end

  def current_user
    return unless session[:id]
    @user ||= User.find_by(id: session[:id])
  end
  helper_method :current_user

end
