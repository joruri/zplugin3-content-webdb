class CreateWebdbGroupPages < ActiveRecord::Migration[5.0]
  def change
    create_table :webdb_group_pages do |t|
      t.belongs_to :db
      t.belongs_to :group
      t.string     :style_type
      t.text :body
      t.timestamps
    end
  end
end
