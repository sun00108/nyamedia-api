class AddStaffToSeries < ActiveRecord::Migration[6.1]
  def change
    add_column :series, :year, :integer
    add_column :series, :original, :integer
    add_column :series, :director, :integer
    add_column :series, :script, :integer
  end
end
