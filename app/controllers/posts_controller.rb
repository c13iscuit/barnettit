class PostsController < ApplicationController
  before_action :authorize_user, only: [:create]

  def index
    if current_user
      if params[:sort] == 'date'
        posts = []
        current_user.subscriptions.each do |sub|
          posts << Post.where(source_id: sub.source.id)
        end
        flattened = posts.flatten.sort! { |a,b| b.created_at <=> a.created_at }
        @posts = Kaminari.paginate_array(flattened).page(params[:page]).per(15)

      elsif params[:sort] == 'votes'
        posts = []
        current_user.subscriptions.each do |sub|
          posts << Post.where(source_id: sub.source.id)
        end
        flattened = posts.flatten.sort! { |a,b| b.score <=> a.score }
        @posts = Kaminari.paginate_array(flattened).page(params[:page]).per(15)

      else
        posts = []
        current_user.subscriptions.each do |sub|
          posts << Post.where(source_id: sub.source.id)
        end
        flattened = posts.flatten.sort! { |a,b| b.score <=> a.score }.sort! { |a,b| b.created_at <=> a.created_at }
        @posts = Kaminari.paginate_array(flattened).page(params[:page]).per(15)
      end
    else
      if params[:sort] == 'votes'
        @posts = Post.order('score desc').page(params[:page]).per(15)
      elsif params[:sort] == 'date'
        @posts = Post.order(created_at: :desc).page(params[:page]).per(15)
      elsif params[:sort] == 'hot'
        @posts = Post.order( created_at: :desc, score: :desc).page(params[:page]).per(15)
      else
        @posts = Post.order(created_at: :desc, score: :desc).page(params[:page]).per(15)
      end
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
