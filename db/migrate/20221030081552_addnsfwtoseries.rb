class Addnsfwtoseries < ActiveRecord::Migration[6.1]
  def change
    add_column :series, :nsfw, :integer
  end
end
