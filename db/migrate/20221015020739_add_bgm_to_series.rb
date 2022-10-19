class AddBgmToSeries < ActiveRecord::Migration[6.1]
  def change
    add_column :series, :bgm_id, :integer
  end
end
