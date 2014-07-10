class VotesController < ApplicationController
  before_action :authorize_user, only: [:create]

  def create
    vote = Vote.find_or_initialize_by(vote_params)
    if vote.update_attributes(value: params[:value])
      flash[:notice] = "Successfully voted!"
    end
    vote.votable.update_attributes(score: vote.votable.score_count)
    redirect_to :back
  end

  protected
    def vote_params
      result = params.permit(:votable_id, :votable_type)
      result[:user_id] = current_user.id
      result
    end
end
