module ApplicationHelper

  def market_list
    Market.all.map { |market| [market.name, market.id] }
  end

  def market_type_list
    MarketType.all.map { |market_type| [market_type.name, market_type.id] }
  end
end
