class AnswersController < ApplicationController
  def create
    @answer = Answer.new(params_with_uid(answer_params))
    @question = Question.find(params[:question_id])

    if @answer.save
      @upvote = Upvote.new({answer_id: @answer.id, count: 0, user_id: session[:user_id]})
      @upvote.save
      redirect_to @question, notice: "Success!"
    else
      flash[:notice] = "Answer must contain at least 50 characters"
      redirect_to @question
    end
  end

  private

  def answer_params
    result = params.require(:answer).permit(:description, :user_id)
    result[:question_id] = params[:question_id]
    result
  end
end
