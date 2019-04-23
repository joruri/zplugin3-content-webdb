class CreateWebdbEntryDates < ActiveRecord::Migration[5.0]
  def change
    create_table :webdb_entry_dates do |t|
      t.integer    :db_id
      t.integer    :entry_id
      t.datetime   :event_date
      t.string     :option_value
      t.string     :name
      t.timestamps
    end
  end
end
