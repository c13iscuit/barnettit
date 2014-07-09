class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :value, inclusion: { in: [-1, 1] }
end
