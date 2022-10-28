class CreateStaffs < ActiveRecord::Migration[6.1]
  def change
    create_table :staffs do |t|

      t.timestamps
    end
    add_column :staffs, :name, :string
    add_column :staffs, :name_cn, :string
  end
end
