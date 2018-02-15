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
