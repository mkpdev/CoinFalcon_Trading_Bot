class TradingsController < ApplicationController

  def index
    render 'new'
  end

  def new
    @trading = Trading.new
  end

  def create
    @trading = Trading.new(trading_params)

    if @trading.save
      redirect_to @trading
    else
      render 'new'
    end
  end

  def show
    @trading = Trading.find(params[:id])
  end

  def trade_list
    # Coinfalcon Exchange Market
    market_id = params[:market_id].nil? ? Market.first.id : params[:market_id]
    @market = Market.find(market_id)
    coinfalcon_exchange(@market.name)

    # My listed Tradings
    my_tradings = Trading.where(market: @market)
    @buy_tradings = my_tradings.not_placed_buy_order
    @sell_tradings = my_tradings.not_placed_sell_order
    trading_bot(@client_orderbook, @client_trades) if Trading.where(order_placed: false).present?
  end

  def trading_bot(orderbook, trades)
    current_buy_price_variation = buy_price_variation_percent(orderbook_price('bids'))
    current_sell_price_variation = sell_price_variation_percent(orderbook_price('asks'))

    buy_trading_list = Trading.not_placed_buy_order.where("price_variation >= ?", current_buy_price_variation)
    buy_trading_list.each do |trade|
      if buy_order_conditions(current_buy_price_variation, trade.price_variation)
        create_order_of_trade(trade, @client)
      end
    end

    sell_trading_list = Trading.not_placed_sell_order.where("price_variation <= ?", current_sell_price_variation)
    sell_trading_list.each do |trade|
      if sell_order_conditions(current_sell_price_variation, trade.price_variation)
        create_order_of_trade(trade, @client)
      end
    end
  end

  private

  def trading_params
    params.require(:trading).permit(:market_id, :order_type, :order_count, :price_variation,
      :market1_amount, :market2_amount)
  end

  def coinfalcon_exchange(market)
    @client = CoinfalconExchange.new
    @client_orderbook = @client.orderbook(market)
    @client_trades = @client.trades(market)
    @my_order = @client.my_orders
    @my_order = @my_order['data'].paginate(per_page: 20)
  end

  def orderbook_price(type)
    @client_orderbook['data'][type][0]['price'].to_f
  end

  def buy_price_variation_percent(price)
    trade_price = @client_trades['data'][0]['price'].to_f
    (((trade_price - price)/trade_price)*100).round(2)
  end

  def sell_price_variation_percent(price)
    trade_price = @client_trades['data'][0]['price'].to_f
    (((price - trade_price)/price)*100).round(2)
  end

  def buy_order_conditions(current_buy_price, trade_price)
    (current_buy_price!=0.0) && (trade_price.present?) && (current_buy_price <= trade_price)
  end

  def sell_order_conditions(current_sell_price, trade_price)
    (current_sell_price!=0.0) && (trade_price.present?) && (current_sell_price >= trade_price)
  end

  def create_order_of_trade(trade, client)
    trade.order_count.times do
      trade.place_order(client, trade.order_type, trade.market1_amount)
    end
  end
end
