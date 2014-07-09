class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_one :upvote, as: :upvotable
  mount_uploader :image, ImageUploader

  validates :title, length: {
    maximum: 255,
    minimum: 10}
  validates :description, length: {
    maximum: 2000,
    minimum: 25}
end
