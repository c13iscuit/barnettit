class UsersController < ApplicationController
  def show
    if params[:sort] == 'upvotes'
      @posts = Post.where(user_id: current_user.id).joins(:upvote).order('count desc')
    else
      @posts = Post.where(user_id: current_user.id).order(created_at: :desc)
    end
  end
end
