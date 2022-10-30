class CreateOnairseries < ActiveRecord::Migration[6.1]
  def change
    create_table :onairseries do |t|

      t.timestamps
    end
    add_column :onairseries, :series_id, :integer
    add_column :onairseries, :day, :integer
    add_column :onairseries, :time, :string
    add_column :onairseries, :status, :integer
  end
end
