class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|

      t.timestamps
    end
    add_column :subscriptions, :series_id, :integer
    add_column :subscriptions, :rss_link, :string
    add_column :subscriptions, :active, :boolean
  end
end
