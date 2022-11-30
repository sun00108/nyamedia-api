class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|

      t.timestamps
    end
    add_column :movies, :name, :string
    add_column :movies, :name_cn, :string
    add_column :movies, :description, :text
    add_column :movies, :tmdb_id, :integer
    add_column :movies, :bgm_id, :integer
  end
end
