class CommentsController < ApplicationController
  def create
    @comment = Comment.new(params_with_uid(comment_params))
    @post = Post.find(params[:post_id])
    if current_user
      if @comment.save
        @upvote = Upvote.create({upvotable_id: @comment.id, upvotable_type: 'comment', count: 0, user_id: session[:user_id]})
        flash[:notice] = "Success!"
      else
        flash[:notice] = "Comment must contain at least 50 characters"
      end
    else
      flash[:notice] = "You must sign in to submit an comment!"
    end
    redirect_to @post
  end

  private

  def comment_params
    result = params.require(:comment).permit(:description, :user_id)
    result[:post_id] = params[:post_id]
    result
  end
end
