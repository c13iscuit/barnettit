class UsersController < ApplicationController
  def show
    @posts = Question.where(user_id: current_user.id)
  end
end
