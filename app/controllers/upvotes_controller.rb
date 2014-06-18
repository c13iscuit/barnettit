class UpvotesController < ApplicationController

  def create
    if params.has_key?(:answer_id)
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
    else
      @question = Question.find(params[:question_id])
      if current_user
        @upvote_pair = UpvotePair.find_by(upvote_id: @question.upvote.id, user_id: current_user.id)
        if @upvote_pair.nil?
          @question.upvote.count += 1
          @question.upvote.save
          UpvotePair.create(upvote_id: @question.upvote.id, user_id: current_user.id)
          flash[:notice] = "Successfully voted!"
        else
          flash[:notice] = "You already upvoted that answer!"
        end
      else
        flash[:notice] = "You must log in to upvote!"
      end
      redirect_to :questions
    end
  end
end
