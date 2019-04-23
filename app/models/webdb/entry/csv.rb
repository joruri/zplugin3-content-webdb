class Webdb::Entry::Csv < Webdb::Csv
  default_scope { where(:csv_type => self.name) }

  def parse_line(row, i)

    line = csv_lines.build(:line_no => i+2, :data => row.fields, :data_type => 'Webdb::Entry')

    entry = db.entries.where(id: row['ID']).first || db.entries.new
    entry_attributes = {}
    delete_attributes = {}

    item_name = ""
    maps_attributes = []
    entry_attributes['db_id'] = db.id
    entry_attributes['id']    = row['ID']
    entry_attributes['title'] = row['タイトル']
    entry_attributes['state'] = state_to_status(entry, row['状態'])
    delete_attributes['delete'] = row['削除']

    if row['編集許可ログイン'] && db.editor_content.present?
      editor = db.editor_content.users.find_by(account: row['編集許可ログイン'])
      entry_attributes['editor_id'] = editor.id if editor.present?
    end

    json_attributes = {}
    in_target_dates = {}

    date_idx = 0
    db.items.each_with_index do |item, n|
      if row[item.title].blank? && item.item_type != 'office_hours'
        json_attributes[item.name] = nil
        next
      end
      case item.item_type
      when 'check_box'
        json_attributes[item.name] = {}
        checks = []
        row[item.title].split(/，/).each_with_index do |w, m|
          checks << w
        end
        json_attributes[item.name]['check'] = checks
      when 'check_data'
        json_attributes[item.name] = {}
        checks = []
        row[item.title].split(/，/).each{|w|
          item.item_options_for_select_data.each{|a| checks << a[1].to_s if a[0] == w}
        }
        json_attributes[item.name]['check'] = checks
      when 'select_data', 'radio_data'
        item.item_options_for_select_data.each{|a| json_attributes[item.name] = a[1] if a[0] == row[item.title] }
      when 'office_hours'
        json_attributes[item.name] = {}
        json_attributes[item.name]['open'] = {}
        json_attributes[item.name]['close'] = {}
        json_attributes[item.name]['open2'] = {}
        json_attributes[item.name]['close2'] = {}
        8.times do |idx|
          w = Webdb::Entry::WEEKDAY_OPTIONS[idx]
          json_attributes[item.name]['open'][idx.to_s]  = row["#{item.title}_#{w}_午前_開始"]
          json_attributes[item.name]['close'][idx.to_s]  = row["#{item.title}_#{w}_午前_終了"]
          json_attributes[item.name]['open2'][idx.to_s]  = row["#{item.title}_#{w}_午後_開始"]
          json_attributes[item.name]['close2'][idx.to_s]  = row["#{item.title}_#{w}_午後_終了"]
        end
        json_attributes[item.name]['remark'] = row["#{item.title}_備考"]
      when 'blank_weekday'
        json_attributes[item.name] = {}
        json_attributes[item.name]['weekday']= {}
        row[item.title].split(/／/).each do |d|
          week = d.gsub(/(.*)：(.*)/, '\1')
          opt = d.gsub(/(.*)：(.*)/, '\2')
          idx = entry.class::WEEKDAY_OPTIONS.index(week)
          next if idx.blank?
          json_attributes[item.name]['weekday'][idx.to_s] = opt
        end
      when 'blank_date'
        row[item.title].split(/／/).each do |d|
          date_val = d.split(/：/)
          in_target_dates[date_idx.to_s] = {
            option_value: date_val[1],
            name: item.name,
            event_date: date_val[0]
          }
          date_idx += 1
        end
      when 'ampm'
        json_attributes[item.name] = {}
        json_attributes[item.name]['am'] = {}
        json_attributes[item.name]['pm'] = {}
        row[item.title].split(/／/).each do |d|
          w = d.scan(/(.*?)(\s|　)午前：(.*?)(\s|　)午後：(.*)/)
          next if w.blank?
          idx = entry.class::WEEKDAY_OPTIONS.index(w[0][0])
          next if idx.blank?
          json_attributes[item.name]['am'][idx.to_s] = w[0][2].present? && w[0][2] == '○'
          json_attributes[item.name]['pm'][idx.to_s] = w[0][4].present? && w[0][4] == '○'
        end
      else
        json_attributes[item.name] = row[item.title]
      end
      item_name = json_attributes[item.name] if n == 0
    end

    entry_attributes[:json_values] = json_attributes

    entry_attributes.each do |key , value|
      next if key == :rid || key == :json_values
      entry[key] = value
    end

    if row['緯度'] && row['経度']
      maps_attributes = [{
          map_lat: row['緯度'], map_lng: row['経度'],
          map_zoom: 14,
          markers_attributes: [{lat: row['緯度'], lng: row['経度'], name: item_name}]
        }]
    end

    entry.validate
    line.data_attributes = {
      entry_attributes: entry_attributes,
      date_attributes: in_target_dates,
      maps_attributes: maps_attributes,
      delete_attributes: delete_attributes
    }
    line.data_invalid = entry.errors.blank? ? 0 : 1
    line.data_errors = entry.errors.full_messages.to_a if entry.errors.present?
    line
  end

  def state_to_status(entry, state_str)
    entry.class::STATE_OPTIONS.each{|a| return a[1] if a[0] == state_str }
    return nil
  end

  def register(line)
    entry_attributes  = line.csv_data_attributes['entry_attributes']
    date_attributes   = line.csv_data_attributes['date_attributes']
    maps_attributes   = line.csv_data_attributes['maps_attributes']
    delete_attributes = line.csv_data_attributes['delete_attributes']
    entry = db.entries.where(id: entry_attributes['id']).first || db.entries.new
    if entry_attributes['id'].present? && entry.present? &&  delete_attributes['delete'].present?
      entry.destroy if delete_attributes['delete'] == '削除'
    else
      entry.state = entry_attributes['state']
      if json_value = entry_attributes['json_values']
        item_values = entry.item_values.presence || {}
        json_value.each do |key , value|
          item_values[key] = value
        end
        entry.item_values = item_values
      end
      entry_attributes.each do |key , value|
        next if key == 'id' || key == 'json_values'
        entry[key] = value
      end
      entry.in_target_dates = date_attributes.with_indifferent_access if date_attributes.present?
      entry.maps_attributes = maps_attributes if maps_attributes.present?
      entry.save
    end
    entry
  end
end
