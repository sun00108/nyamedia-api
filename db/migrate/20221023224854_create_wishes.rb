class CreateWishes < ActiveRecord::Migration[6.1]
  def change
    create_table :wishes do |t|

      t.timestamps
    end
    add_column :wishes, :bgm_id, :integer
    add_column :wishes, :bgm_user, :string
  end
end
