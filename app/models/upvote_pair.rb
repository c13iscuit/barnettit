class UpvotePair < ActiveRecord::Base
  belongs_to :upvote
  belongs_to :user
end
