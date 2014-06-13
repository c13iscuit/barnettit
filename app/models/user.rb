class User < ActiveRecord::Base
  has_many :questions
end
