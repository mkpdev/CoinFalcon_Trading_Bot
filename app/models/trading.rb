class Trading < ApplicationRecord
  belongs_to :market

  validates :market_id, :order_type, :order_count, :price_variation, :market1_amount, presence: true

  scope :not_placed_buy_order, -> { where(order_placed: false, order_type: "buy") }
  scope :not_placed_sell_order, -> { where(order_placed: false, order_type: "sell") }

  def place_order(client, type, size)
    result = client.create_order({market: market.name, operation_type: 'market_order', order_type: type, size: size})
    if result.dig("error").present?
      self.update_columns(error_message: result["error"])
    else
      self.update_columns(order_placed: true, error_message: nil)
    end
  end
end
