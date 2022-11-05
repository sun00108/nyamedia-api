class CreateSubtitles < ActiveRecord::Migration[6.1]
  def change
    create_table :subtitles do |t|

      t.timestamps
    end
    add_column :subtitles, :zh_CN_hash, :string
    add_column :subtitles, :zh_TW_hash, :string
  end
end
