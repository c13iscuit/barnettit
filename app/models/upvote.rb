class Upvote < ActiveRecord::Base
  belongs_to :upvotable, :polymorphic => true
  has_many :upvote_pairs
end
