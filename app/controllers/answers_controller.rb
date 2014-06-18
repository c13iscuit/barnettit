class AnswersController < ApplicationController
  def create
    @answer = Answer.new(params_with_uid(answer_params))
    @question = Question.find(params[:question_id])
    if current_user
      if @answer.save
        @upvote = Upvote.create({upvotable_id: @answer.id, upvotable_type: 'Answer', count: 0, user_id: session[:user_id]})
        flash[:notice] = "Success!"
      else
        flash[:notice] = "Answer must contain at least 50 characters"
      end
    else
      flash[:notice] = "You must sign in to submit an answer!"
    end
    redirect_to @question
  end

  private

  def answer_params
    result = params.require(:answer).permit(:description, :user_id)
    result[:question_id] = params[:question_id]
    result
  end
end
