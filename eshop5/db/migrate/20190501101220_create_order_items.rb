class CreateOrderItems < ActiveRecord::Migration[5.1]
  def self.up
    create_table :order_items do |t|
      t.integer :film_id, :limit => 8
      t.integer :order_id, :limit => 8
      t.float :price
      t.integer :amount
      t.timestamps
    end

    say_with_time 'Adding foreing keys' do
      # Add foreign key reference to order_items table
      execute 'ALTER TABLE order_items ADD CONSTRAINT fk_order_items_orders
              FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE'
    end
  end

  def self.down
    drop_table :order_items
  end
end
