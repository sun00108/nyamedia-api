class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|

      t.timestamps
    end
    add_column :relationships, :staff_id, :integer
    add_column :relationships, :series_id, :integer
    add_column :relationships, :role, :integer
  end
end
