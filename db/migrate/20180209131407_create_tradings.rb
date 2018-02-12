class CreateTradings < ActiveRecord::Migration[5.1]
  def change
    create_table :tradings do |t|
      t.string :market
      t.integer :buy_order
      t.integer :sell_order
      t.decimal :sell_price_variation
      t.decimal :buy_price_variation
      t.decimal :market1_amount
      t.decimal :market2_amount

      t.timestamps
    end
  end
end
