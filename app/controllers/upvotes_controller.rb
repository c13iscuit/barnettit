class UpvotesController < ApplicationController

  def create
    @answer = Answer.find(params[:answer_id])
    if current_user
      @upvote_pair = UpvotePair.find_by(upvote_id: @answer.upvote.id, user_id: current_user.id)
      if @upvote_pair.nil?
        @answer.upvote.count += 1
        @answer.upvote.save
        UpvotePair.create(upvote_id: @answer.upvote.id, user_id: current_user.id)
        flash[:notice] = "Successfully voted!"
      else
        flash[:notice] = "You already upvoted that answer!"
      end
    else
      flash[:notice] = "You must log in to upvote!"
    end
    redirect_to @answer.question
  end
end