class PostsController < ApplicationController
  def index
    if params[:sort] == 'upvotes'
      @posts = Post.all.joins(:upvote).order('count desc')
    else
      @posts = Post.all.order(created_at: :desc)
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = Comment.where(post_id: params[:id]).joins(:upvote)
    @upvote = Upvote.new
  end

  def new
    @post = Post.new
  end

  def create
    @params = params_with_uid(post_params)
    @post = Post.new(@params)
    if current_user
      if @post.save
        @upvote = Upvote.create({upvotable_id: @post.id, upvotable_type: 'Post', count: 0, user_id: session[:user_id]})
        redirect_to :posts
      else
        flash[:notice] = "Title must contain at least 10 characters and Description must contain at least 25 characters"
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
    params.require(:post).permit(:title, :description, :image)
  end
end
