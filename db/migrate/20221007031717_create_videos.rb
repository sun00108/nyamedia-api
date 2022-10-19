class CreateVideos < ActiveRecord::Migration[6.1]
  def change
    create_table :videos do |t|

      t.timestamps
    end
    add_column :videos, :name, :string
    add_column :videos, :episode, :integer
    add_column :videos, :series_id, :integer
    add_column :videos, :video_hash, :string
  end
end
