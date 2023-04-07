class CreateMetadata < ActiveRecord::Migration[6.1]
  def change
    create_table :metadata do |t|
      t.bigint :season, null: false, foreign_key: true
      t.timestamps
    end
  end
end
