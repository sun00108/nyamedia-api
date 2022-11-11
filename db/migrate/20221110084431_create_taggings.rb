class CreateTaggings < ActiveRecord::Migration[6.1]
  def change
    create_table :taggings do |t|

      t.timestamps
    end
    add_column :taggings, :tag_id, :integer
    add_column :taggings, :series_id, :integer
    add_column :taggings, :weight, :integer
  end
end
