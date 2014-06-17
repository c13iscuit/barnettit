class QuestionsController < ApplicationController
  def index
    @questions = Question.all.order(created_at: :asc)
  end

  def show
    @question = Question.find(params[:id])
    @answer = Answer.new
    @answers = Answer.where(question_id: params[:id]).includes(:upvote)
    @upvote = Upvote.new
  end

  def new
    @question = Question.new
  end

  def create
    @params = params_with_uid(question_params)
    @question = Question.new(@params)
    if @question.save
      redirect_to :questions
    else
      flash[:notice] = "Title must contain at least 10 characters and Description must contain at least 25 characters"
      render :new
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    @question.update(question_params)
    redirect_to :questions
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    @question.answers.destroy_all
    flash[:notice] = "That question was deleted."
    redirect_to :questions
  end

  private

  def question_params
    params.require(:question).permit(:title, :description)
  end
end
