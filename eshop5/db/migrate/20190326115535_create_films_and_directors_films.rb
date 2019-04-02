class CreateFilmsAndDirectorsFilms < ActiveRecord::Migration[5.1]
  def up
    create_table :films do |t|
       t.string :title, :limit => 255, :null => false
       t.integer :producer_id, :limit => 8, :null => false
       t.datetime :produced_at
       t.string :kind, :limit => 15
       t.text :blurb
       t.integer :duration
       t.float :price
       t.timestamps
    end
    
    create_table :directors_films do |t|
      t.integer :director_id, :limit => 8, :null => false
      t.integer :film_id, :limit => 8, :null => false
      t.timestamps
    end

    say_with_time 'Adding foreing keys' do
      # Add foreign key reference to directors_films table
      execute 'ALTER TABLE directors_films ADD CONSTRAINT fk_directors_films_directors
              FOREIGN KEY (director_id) REFERENCES directors(id) ON DELETE CASCADE'      
      execute 'ALTER TABLE directors_films ADD CONSTRAINT fk_directors_films_films
              FOREIGN KEY (film_id) REFERENCES films(id) ON DELETE CASCADE'
      # Add foreign key reference to films table
      execute 'ALTER TABLE films ADD CONSTRAINT fk_films_producers
              FOREIGN KEY (producer_id) REFERENCES producers(id) ON DELETE CASCADE'
    end
  end
  
  def self.down
    drop_table :films
    drop_table :directors_films
  end
  
end
