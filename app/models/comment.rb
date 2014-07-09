class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  has_many :votes, as: :votable

  validates :description, length: { minimum: 10 }
end
