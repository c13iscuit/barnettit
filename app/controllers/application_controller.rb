class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :params_with_uid

  def params_with_uid(object)
    object.merge!(user_id: session[:user_id])
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authorize_user
    unless current_user
      redirect_to :back, notice: "You must be logged in to do that!"
    end
  end
end
