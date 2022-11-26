class CreateStreams < ActiveRecord::Migration[6.1]
  def change
    create_table :streams do |t|

      t.timestamps
    end
    add_column :streams, :name, :string
    add_column :streams, :link, :string
  end
end
