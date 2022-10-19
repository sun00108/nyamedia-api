class AddImagesToSeries < ActiveRecord::Migration[6.1]
  def change
    add_column :series, :poster_id, :integer
    add_column :series, :backdrop_id, :integer
    add_column :series, :logo_id, :integer
  end
end
