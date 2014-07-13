class User < ActiveRecord::Base

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.username = auth['info']['name']
    end
  end

  has_many :posts
  has_many :comments
  has_many :votes

  validates_uniqueness_of :uid, scope: :provider
  validates_presence_of :username
end
