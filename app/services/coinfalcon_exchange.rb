require 'rest-client'
require 'json'
require 'pry'

class CoinfalconExchange
  def initialize
    @key = ENV["coinfalcon_exchange_key"]
    @secret = ENV["coinfalcon_exchange_secret"]
    @end_point = 'https://staging.coinfalcon.com/api/v1/'
  end

  def headers(request_path, body, method)
    timestamp = Time.now.to_i
    signature = get_signature(timestamp, request_path, body, method)
    ap signature
    {
        "CF-API-KEY" => @key,
        "CF-API-TIMESTAMP" => timestamp,
        "CF-API-SIGNATURE" => signature
    }
  end

  def get_signature(timestamp, request_path='', body={}, method='GET')
    # Example for get
    # request_path = '/api/v1/user/orders'
    # timestamp = 1513411769
    # method = 'GET'
    # payload = '1513411769|GET|/api/v1/user/orders'

    # Example for post
    # request_path = '/api/v1/user/orders'
    # timestamp = 1513411657
    # method = 'POST'
    # body {market: 'IOT-BTC', operation_type: 'market_order', order_type: 'buy', size: '1'}
    # payload = '1513411657|POST|/api/v1/user/orders|{"market":"IOT-BTC","operation_type":"market_order","order_type":"buy","size":"1"}'

    if method == 'GET'
      payload = [timestamp, method, request_path].join("|")
    else
      body = URI.unescape(body.to_json) if body.is_a?(Hash)
      payload = [timestamp, method, request_path, body].join("|")
    end

    puts payload
    # create a sha256 hmac with the secret
    OpenSSL::HMAC.hexdigest('sha256', @secret, payload)
  end

  def accounts
    url = @end_point + "user/accounts"
    result = RestClient.get(url, headers(URI(url).request_uri, {}, 'GET'))
    JSON.parse(result.body)
  end

  def orderbook(market)
    url = @end_point + "markets/#{market}/orders"
    JSON.parse(RestClient.get(url).body)
  end

  def my_orders
    url = @end_point + "user/orders"
    result = RestClient.get(url, headers(URI(url).request_uri, {}, 'GET'))
    JSON.parse(result.body)
  end

  def my_trades

  end

  def trades(market)
    url = @end_point + "markets/#{market}/trades"
    JSON.parse(RestClient.get(url).body)
  end

  def create_order(body)
    url = @end_point + "user/orders"
    result = RestClient.post(url, body,headers(URI(url).request_uri, body, 'POST'))
    JSON.parse(result.body)
  end

  def order(id)
    url = @end_point + "user/orders/#{id}"
    result = RestClient.get(url, headers(URI(url).request_uri, {}, 'GET'))
    JSON.parse(result.body)
  end

  def cancel_order(id)
    url = @end_point + "user/orders/#{id}"
    begin
      result = RestClient.delete(url, headers(URI(url).request_uri, {}, 'DELETE'))
      JSON.parse(result.body)
    rescue RestClient::ExceptionWithResponse => e
      JSON.parse(e.response.body)
    end
  end

  def deposit_address(currency)
    url = @end_point + "account/deposit_address?currency=#{currency}"
    result = RestClient.get(url, headers(URI(url).request_uri, {}, 'GET'))
    JSON.parse(result.body)
  end

  def deposits(query = {})
    url = @end_point + "account/deposits?#{URI.encode_www_form(query)}".chomp('?')
    result = RestClient.get(url, headers(URI(url).request_uri, {}, 'GET'))
    JSON.parse(result.body)
  end

  def deposit(id)
    url = @end_point + "account/deposit/#{id}"
    result = RestClient.get(url, headers(URI(url).request_uri, {}, 'GET'))
    JSON.parse(result.body)
  end

  def create_withdrawal(body)
    url = @end_point + "account/withdraw"
    result = RestClient.post(url, body,headers(URI(url).request_uri, body, 'POST'))
    JSON.parse(result.body)
  end

  def withdrawals(query = {})
    url = @end_point + "account/withdrawals?#{URI.encode_www_form(query)}".chomp('?')
    result = RestClient.get(url, headers(URI(url).request_uri, {}, 'GET'))
    JSON.parse(result.body)
  end

  def withdrawal(id)
    url = @end_point + "account/withdrawal?id=#{id}"
    result = RestClient.get(url, headers(URI(url).request_uri, {}, 'GET'))
    JSON.parse(result.body)
  end

  def cancel_withdrawal(id)
    url = @end_point + "account/withdrawals/#{id}"
    result = RestClient.delete(url, headers(URI(url).request_uri, {}, 'DELETE'))
    JSON.parse(result.body)
  end

end

#staging
#client = CoinfalconExchange.new('70b23c92-51df-413d-8d2d-73504d85e2df', '0b63546f-983e-48ac-bed7-10e4d4a0dfed')

#development
# client = CoinfalconExchange.new('a41db994-1a1a-4256-8279-212f893cb6d1', 'bbcb7bce-d767-4b37-8257-667d0809936b')

# ap client.orderbook('IOT-BTC')
# ap client.my_orders
# ap client.accounts
#result = client.create_order({market: 'BTC-EUR', operation_type: 'market_order', order_type: 'sell', size: '0.01'})
#ap result
#ap client.order(result['data']['id'])
#ap client.cancel_order(result['data']['id'])
# ap client.deposit_address('btc')
#result = client.create_withdrawal({amount: '0.001', address: 'mszGuGEdvkRsnFaTymW9LHiMan1qcPH4wn', currency: 'btc'})
# ap client.withdrawal('9b25877a-35ae-4812-8d89-953ed4c55094')
# ap client.withdrawals(currency: 'btc', status: 'completed')
#ap result
#ap client.cancel_withdrawal(result['data']['id'])
# ap client.deposits(currency: 'btc', status: 'completed')
# ap client.deposit('e30a3ac8-33b1-46ed-8f54-1112417de581')
