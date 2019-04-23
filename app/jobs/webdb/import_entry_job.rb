class Webdb::ImportEntryJob < ApplicationJob
  queue_as :import_webdb_entry

  MAX_LOOP = 1000

  def perform(item_id)
    csv = Webdb::Entry::Csv.find_by(id: item_id)
    csv.parse_state = 'progress'
    csv.parse_start_at = Time.now
    csv.parse_success = 0
    csv.parse_failure = 0
    csv.save
    rows = CSV.parse(csv.filedata, :headers => true)
    csv.parse_total = rows.size
    rows.each_with_index do |row, i|
      if line = csv.parse_line(row, i)
        if line.data_invalid == 0
          csv.parse_success += 1
        else
          csv.parse_failure += 1
        end
        csv.save if i%100 == 0
      end
    end
    csv.parse_state = 'finish'
    csv.parse_end_at = Time.now
    csv.save
    register(csv.id)
  end

private
  def register(item_id)
    csv = Webdb::Entry::Csv.find_by(id: item_id)
    csv.register_state = 'progress'
    csv.register_start_at = Time.now
    csv.register_total = csv.valid_csv_lines.count
    csv.register_success = 0
    csv.register_failure = 0
    csv.save
    csv.valid_csv_lines.each_with_index do |line, i|
      model = csv.register(line)

      if model && model.errors.size == 0
        csv.register_success += 1
      else
        line.data_errors = model.errors.full_messages.to_a
        csv.register_failure += 1
      end
      csv.save if i%100 == 0
    end

    csv.register_state = 'finish'
    csv.register_end_at = Time.now
    csv.save
  end

end
