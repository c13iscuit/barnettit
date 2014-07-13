class UsersController < ApplicationController
  def show
    if params[:sort] == 'votes'
      @posts = Post.where(user_id: params[:id]).order('score desc')
    else
      @posts = Post.where(user_id: params[:id]).order(created_at: :desc)
    end
  end
end
