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
  has_many :upvotes
  has_many :upvotepairs
  has_one :account
end
