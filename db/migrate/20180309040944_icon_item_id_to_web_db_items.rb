class IconItemIdToWebDbItems < ActiveRecord::Migration[5.0]
  def change
    add_column :webdb_items, :icon_item_id, :integer
  end
end
