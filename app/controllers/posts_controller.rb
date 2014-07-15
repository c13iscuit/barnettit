class PostsController < ApplicationController
  before_action :authorize_user, only: [:create]

  def index
    if params[:sort] == 'votes'
      @posts = Post.order('score desc').page(params[:page]).per(6)
    elsif params[:sort] == 'date'
      @posts = Post.order(created_at: :desc).page(params[:page]).per(6)
    elsif params[:sort] == 'hot'
      @posts = Post.order('score desc', created_at: :desc).page(params[:page]).per(6)
    else
      @posts = Post.order('score desc', created_at: :desc).page(params[:page]).per(6)
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = Comment.where(post_id: params[:id]).order('score desc', created_at: :desc)
    @vote = Vote.new
  end

  def new
    @post = Post.new
  end

  def create
    @params = params_with_uid(post_params)
    @post = Post.new(@params)

    if @post.save
      redirect_to :posts
    else
      flash[:notice] = "Title can't be blank!"
      render :new
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
