class AnswersController < ApplicationController
  def create
    @answer = Answer.new(answer_params)
    if @answer.save
      @question = Question.find(params[:question_id])
      redirect_to @question, notice: "Success!"
    else
      flash[:notice] = "Answer must contain at least 50 characters"
      @question = Question.find(params[:question_id])
      redirect_to @question
    end
  end

  private

  def answer_params
    result = params.require(:answer).permit(:description)
    result[:question_id] = params[:question_id]
    result
  end
end
