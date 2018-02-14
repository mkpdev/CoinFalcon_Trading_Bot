class CreateTradings < ActiveRecord::Migration[5.1]
  def change
    create_table :tradings do |t|
      t.references :market
      t.string :order_type
      t.integer :order_count
      t.decimal :price_variation
      t.boolean :order_placed, default: false
      t.decimal :market1_amount
      t.decimal :market2_amount
      t.string :error_message

      t.timestamps
    end
  end
end
