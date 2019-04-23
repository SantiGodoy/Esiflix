class CreateCartItems < ActiveRecord::Migration[5.1]
  def change
    create_table :cart_items do |t|
      t.integer :film_id, :limit => 8
      t.integer :cart_id, :limit => 8
      t.float :price
      t.integer :amount
      t.timestamps
    end
  end
end
