class TradingsController < ApplicationController

  before_action :coinfalcon_exchange

  def new
  end

  def create
    @trading = Trading.new(trading_params)

    @trading.save
    redirect_to @trading
  end

  def show
    @trading = Trading.find(params[:id])
  end

  private

  def trading_params
    params.require(:trading).permit(:market, :buy_order, :sell_order, :sell_price_variation,
      :buy_price_variation, :market1_amount, :market2_amount)
  end

  def coinfalcon_exchange
    @client = CoinfalconExchange.new
    @client_orderbook = @client.orderbook('BTC-EUR')
    @client_trades = @client.trades('BTC-EUR')
  end
end

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
