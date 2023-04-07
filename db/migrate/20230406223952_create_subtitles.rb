class CreateSubtitles < ActiveRecord::Migration[6.1]
  def change
    create_table :subtitles do |t|
      t.bigint :video, null: false, foreign_key: true
      t.timestamps
    end
  end
end
