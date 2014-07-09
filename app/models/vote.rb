class Vote < ActiveRecord::Base
  belongs_to :votable, :polymorphic => true
end
