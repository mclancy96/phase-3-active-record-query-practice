class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :title, null: false
      t.string :director, null: false
      t.string :genre, null: false
      t.integer :release_year, null: false
      t.decimal :rating, precision: 3, scale: 1
      t.decimal :budget, precision: 15, scale: 2
      t.decimal :box_office, precision: 15, scale: 2
      t.integer :runtime
      t.string :country
      t.string :language
      t.string :studio

      t.timestamps
    end

    add_index :movies, :director
    add_index :movies, :genre
    add_index :movies, :release_year
    add_index :movies, :rating
    add_index :movies, :studio
  end
end
