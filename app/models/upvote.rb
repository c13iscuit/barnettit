class Upvote < ActiveRecord::Base
  belongs_to :answer
  has_many :upvote_pairs
end
