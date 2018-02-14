module ApplicationHelper

  def market_list
    Market.all.collect { |market| [market.name, market.id] }
  end

  def client_orderbook_price(client, type)
    client.dig('data')[type][0]["price"]
  end
end
