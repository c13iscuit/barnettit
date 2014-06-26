class UpvotesController < ApplicationController

  def create
    object_type
    if current_user
      @upvote_pair = UpvotePair.find_by(upvote_id: @upvotable_object.upvote.id, user_id: current_user.id)
      if @upvote_pair.nil?
        @upvotable_object.upvote.count += 1
        @upvotable_object.upvote.save
        UpvotePair.create(upvote_id: @upvotable_object.upvote.id, user_id: current_user.id)
        flash[:notice] = "Successfully voted!"
      else
        flash[:notice] = "You already upvoted this!"
      end
    else
      flash[:notice] = "You must log in to upvote!"
    end
    redirect_to object_path
  end

  private

  def object_type
    if params.has_key?(:comment_id)
      @upvotable_object = Comment.find(params[:comment_id])

    else
      @upvotable_object = Post.find(params[:post_id])
    end
  end

  def object_path
    if params.has_key?(:comment_id)
      @path = post_path(@upvotable_object.post.id)
    else
      @path = :posts
    end
  end

end
