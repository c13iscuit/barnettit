class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :votes, as: :votable

  validates_presence_of :title
  validates_presence_of :description

  mount_uploader :image, ImageUploader

  def score
    Vote.where(votable_id: id, votable_type: "Post").sum(:value)
  end
end
