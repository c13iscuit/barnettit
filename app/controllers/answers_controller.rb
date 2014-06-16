class AnswersController < ApplicationController
  def create
    @answer = Answer.new(answer_params)
    @question = Question.find(params[:question_id])
    if @answer.save
      redirect_to @question, notice: "Success!"
    else
      flash[:notice] = "Answer must contain at least 50 characters"
      redirect_to @question
    end
  end

  def show
    @question = Question.find(params[:question_id])
    @answer = Answer.find_by(question_id: params[:question_id], id: params[:id])
    @answer.upvotes += 1
    @answer.save
    redirect_to @question
  end

  private

  def answer_params
    result = params.require(:answer).permit(:description)
    result[:question_id] = params[:question_id]
    result
  end
end
