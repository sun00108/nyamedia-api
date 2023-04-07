class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|
      t.bigint :media, null: true, foreign_key: true
      t.bigint :season, null: true, foreign_key: true
      t.timestamps
    end
  end
end
