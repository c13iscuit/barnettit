require 'rails_helper'

describe Vote do
  it { should belong_to(:user) }
  it { should belong_to(:votable) }

  it { should have_valid(:value).when(-1, 1) }
  it { should_not have_valid(:value).when(0, 6, 10, -50, nil, '') }
end
