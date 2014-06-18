class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_one :upvote, :as => :upvotable
  validates :description, length: { minimum: 10}
end
