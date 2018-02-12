
# Create Market
markets = ['BTC-EUR', 'IOT-BTC', 'ETH-BTC', 'BCH-BTC', 'LTC-BTC']
markets.each do |market|
  Market.where(name: market).first_or_create!
end
