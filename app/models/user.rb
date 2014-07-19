class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes
  has_many :subscriptions

  validates_uniqueness_of :uid, scope: :provider
  validates_presence_of :username

  def self.create_with_omniauth(auth)
    if auth["provider"] == "twitter"
      create! do |user|
        user.provider = auth['provider']
        user.uid = auth['uid']
        user.username = auth['info']['name']
        user.avatar = auth['info']['image']
      end
    else
      create! do |user|
        user.provider = auth['provider']
        user.uid = auth['uid']
        user.username = auth['info']['name']
        user.avatar = auth[:info][:image]
      end
    end
  end
end
