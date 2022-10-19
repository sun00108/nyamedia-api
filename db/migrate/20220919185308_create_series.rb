class CreateSeries < ActiveRecord::Migration[6.1]
  def change
    create_table :series do |t|

      t.timestamps
    end
    add_column :series, :name, :string
    add_column :series, :name_cn, :string
    add_column :series, :description, :text
    add_column :series, :tmdb_id, :integer
    add_column :series, :season, :integer
    add_column :series, :status, :integer
  end
end
