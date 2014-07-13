require 'rails_helper'

describe User do
  it { should validate_presence_of(:username) }
  #it { should validate_uniqueness_of(:uid).scoped_to(:provider) }

end
