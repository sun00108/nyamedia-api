class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|

      t.timestamps
    end
    add_column :tags, :name, :string
    add_column :tags, :hidden, :boolean, default: false
  end
end
