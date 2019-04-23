class CreateWebdbDbs < ActiveRecord::Migration[5.0]
  def change
    create_table :webdb_dbs do |t|
      t.references :content
      t.string     :state
      t.string     :title
      t.integer    :sort_no
      t.text       :body
      t.text       :list_body
      t.text       :detail_body
      t.text       :member_list_body
      t.text       :member_detail_body
      t.integer    :display_limit
      t.references :member_content
      t.references :editor_content
      t.timestamps
    end
  end
end
