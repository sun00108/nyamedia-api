class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|

      t.timestamps
    end
    add_column :images, :series_id, :integer
    add_column :images, :category, :integer
    add_column :images, :image_hash, :string
  end
end
