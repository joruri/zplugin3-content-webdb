class CreateWebdbItems < ActiveRecord::Migration[5.0]
  def change
    create_table :webdb_items do |t|
      t.belongs_to :db
      t.integer    :reference_id
      t.integer    :reference_item_id
      t.string     :state
      t.string     :name
      t.string     :title
      t.string     :item_type
      t.text       :item_options
      t.string     :style_attribute
      t.integer    :sort_no
      t.boolean    :is_target_sort
      t.boolean    :is_target_search
      t.boolean    :is_target_keyword
      t.boolean    :is_limited_access
      t.timestamps
    end
  end
end
