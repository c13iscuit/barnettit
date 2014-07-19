class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :source

  validates_presence_of :user
  validates_presence_of :source
end
