class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  has_one :upvote, :as => :upvotable
  validates :description, length: { minimum: 10}
end
