class FixInfoToSeries < ActiveRecord::Migration[6.1]
  def change
    remove_column :series, :original
    remove_column :series, :director
    remove_column :series, :script
  end
end
