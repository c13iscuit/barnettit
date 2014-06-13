class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers

  validates :title, length: {
    maximum: 255,
    minimum: 40}
  validates :description, length: {
    maximum: 2000,
    minimum: 150}
end
