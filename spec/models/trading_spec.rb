require 'rails_helper'

RSpec.describe Trading, :type => :model do
  let(:market) { create(:market) }
  let(:trading) { create(:trading, market: market) }
  
  describe "Validations" do
    it { is_expected.to validate_presence_of(:market_id) }
    it { is_expected.to validate_presence_of(:order_type) }
    it { is_expected.to validate_presence_of(:order_count) }
    it { is_expected.to validate_presence_of(:price_variation) }
    it { is_expected.to validate_presence_of(:market1_amount) }
  end

  describe "Associations" do
    it { should belong_to(:market) }
  end
end
