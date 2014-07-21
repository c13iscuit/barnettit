class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    if User.find_by(provider: auth['provider'], uid: auth['uid'])
      user = User.find_by(provider: auth['provider'], uid: auth['uid'])
    else
      user = User.create_with_omniauth(auth)
      user.subscribe_all
    end
    session[:user_id] = user.id
    redirect_to :posts, notice: 'Signed in!'
  end

  def destroy
    session[:user_id] = nil
    redirect_to :posts, notice: 'Signed out!'
  end
end
