class CreateWebdbCsvLines < ActiveRecord::Migration[5.0]
  def change
    create_table :webdb_csv_lines do |t|
      t.column :csv_id , :integer
      t.column :line_no, :integer
      t.column :data , :jsonb
      t.column :data_type  , :string, :limit => 255
      t.column :data_attributes , :jsonb
      t.column :data_extras, :jsonb
      t.column :data_invalid , :integer
      t.column :data_errors , :jsonb
      t.timestamps
    end
  end
end
