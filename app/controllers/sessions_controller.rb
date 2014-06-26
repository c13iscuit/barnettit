class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by(provider: auth['provider'], uid: auth['uid']) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to :posts, :notice => 'Signed in!'
    # raise request.env["omniauth.auth"].to_yaml
  end

  def destroy
    session[:user_id] = nil
    redirect_to :posts, :notice => 'Signed out!'
  end
end
