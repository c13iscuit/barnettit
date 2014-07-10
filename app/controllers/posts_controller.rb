class PostsController < ApplicationController
  def index
    if params[:sort] == 'votes'
      @posts = Post.order('value').page(params[:page]).per(6)
    else
      @posts = Post.order(created_at: :desc).page(params[:page]).per(6)
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = Comment.where(post_id: params[:id])
    @vote = Vote.new
  end

  def new
    if !current_user
      flash[:notice] = "You must be logged in to post!"
      redirect_to :posts
    else
      @post = Post.new
    end
  end

  def create
    @params = params_with_uid(post_params)
    @post = Post.new(@params)
    if current_user
      if @post.save
        redirect_to :posts
      else
        flash[:notice] = "Title can't be blank!"
        render :new
      end
    else
      flash[:notice] = "You must log in to post!"
      redirect_to :new_post
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to :posts
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    @post.comments.destroy_all
    flash[:notice] = "That post was deleted."
    redirect_to :posts
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :image, :url)
  end
end
