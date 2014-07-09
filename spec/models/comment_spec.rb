require 'rails_helper'

describe Comment do
  it { should belong_to(:post) }
  it { should belong_to(:user) }
  it { should have_many(:votes) }

  it { should have_valid(:description).when("Awesome post!", "Great job, dude") }
  it { should_not have_valid(:description).when(nil, '') }
end
