FactoryBot.define do
  factory :trading, class: 'Trading' do
    order_type "sell"
    order_count 2
    price_variation 0.001
    order_placed false
    market1_amount 0.00003
  end
end