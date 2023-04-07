class AddColumnsToMedia < ActiveRecord::Migration[6.1]
  def change
    add_column :media, :name, :string, null: false
    add_column :media, :type, :integer, null: false
    add_column :media, :metadata_source, :integer
    add_column :media, :metadata_id, :integer
    add_column :media, :status, :integer, null: false
  end
end
