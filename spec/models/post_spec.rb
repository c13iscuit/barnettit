require 'rails_helper'

describe Post do
  it { should belong_to(:user) }
  it { should have_many(:comments) }
  it { should have_many(:votes) }

  it { should have_valid(:title).when("Look at this cat!", "Read this article!") }
  it { should_not have_valid(:title).when(nil, "") }

  it { should have_valid(:description).when("Spacecats rule", "RTFM") }
  it { should_not have_valid(:description).when(nil, "") }
end
