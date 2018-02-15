require 'rails_helper'

RSpec.describe Market, :type => :model do
  it { should have_one(:trading) }
end