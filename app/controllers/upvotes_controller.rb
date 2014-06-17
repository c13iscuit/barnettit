class UpvotesController < ApplicationController

  def create

    @question = Question.find(params[:question_id])

    @answer = Answer.find_by(question_id: params[:question_id], id: params[:answer_id])
    binding.pry
    if UpvotePair.find_by(upvote_id: @answer.upvote.id, user_id: session[:user_id]).nil?
      @answer.upvote.count += 1
      @answer.upvote.save
      UpvotePair.create(upvote_id: @answer.upvote.id, user_id: session[:user_id])

      redirect_to @question
    else
      flash[:notice] = "You already upvoted that answer!"
    end
  end

end
