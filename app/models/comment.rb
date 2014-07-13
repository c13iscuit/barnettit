class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  has_many :votes, as: :votable

  validates :description, length: { minimum: 1 }

  def score_count
    Vote.where(votable_id: id, votable_type: "Comment").sum(:value)
  end
end
