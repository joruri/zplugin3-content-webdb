class CreateWebdbCsvs < ActiveRecord::Migration[5.0]
  def change
    create_table :webdb_csvs do |t|
      t.column :db_id, :integer
      t.column :csv_type , :string, :limit => 255
      t.column :parse_state , :string, :limit => 255
      t.column :parse_start_at , :timestamp
      t.column :parse_end_at , :timestamp
      t.column :parse_total , :integer
      t.column :parse_success, :integer
      t.column :parse_failure , :integer
      t.column :register_state , :string, :limit => 255
      t.column :register_start_at , :timestamp
      t.column :register_end_at, :timestamp
      t.column :register_total, :integer
      t.column :register_success, :integer
      t.column :register_failure, :integer
      t.column :filename, :string, :limit => 255
      t.column :filedata, :text
      t.column :extras, :jsonb
      t.timestamps
    end
  end
end
