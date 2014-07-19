class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :source
  has_many :comments
  has_many :votes, as: :votable

  validates_presence_of :title
  validates :url, uniqueness: true, allow_nil: true

  mount_uploader :image, ImageUploader

  def score_count
    Vote.where(votable_id: id, votable_type: "Post").sum(:value)
  end
end
