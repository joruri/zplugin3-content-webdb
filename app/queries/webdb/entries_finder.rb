class Webdb::EntriesFinder < ApplicationFinder
  def initialize(db, entries)
    @db = db
    @entries = entries
  end

  def search(criteria, model, keyword, sort_key, operator_type)

    search_queries = search_conditions(criteria, model, keyword, sort_key)

    if search_queries.present?
      search_queries.each_with_index do |q, i|
        @entries = @entries.merge(q) if operator_type == :and
        @entries = @entries.merge(q) if operator_type == :or && i == 0
        @entries = @entries.or(q) if operator_type == :or && i != 0
      end
    end

    sort_columns = @db.items.target_sort_state.pluck(:name)
    if sort_key && sort_columns
      key, order  = sort_key.split(/\s/)
      if idx = sort_columns.index(key)
        @entries = @entries.order(Arel.sql("item_values -> '#{sort_columns[idx]}' #{ordering(order)}"))
      end
    end
    @entries
  end

  def search_conditions(criteria, model, keyword, sort_key)

    search_queries = []
    keyword_columns = @db.items.target_keyword_state.pluck(:name)
    if keyword.present? && keyword_columns
      queries = keyword_columns.map{|w| %Q(item_values ->> '#{w}' like :keyword)}
      search_queries << model.where(queries.join(" OR "), keyword: "%#{keyword}%")
    end

    @db.public_items.each do |item|
      value = criteria[item.name.to_sym]
      next if value.blank?
      case item.item_type
      when 'check_box', 'check_data'
        search_queries << model.where("item_values -> '#{item.name}' -> 'check' ?| array[:keys]", keys: value)
      when 'ampm'
        am_idx = value['am'].present? ? value['am'].keys : []
        pm_idx = value['pm'].present? ? value['pm'].keys : []
        if am_idx.present? && pm_idx.present?
          search_queries << model.where(
            "(item_values -> '#{item.name}' -> 'am' ?| array[:am_keys]) OR" +
            "(item_values -> '#{item.name}' -> 'pm' ?| array[:pm_keys])", am_keys:am_idx, pm_keys: pm_idx
            )
        elsif am_idx.present?
          search_queries << model.where("item_values -> '#{item.name}' -> 'am' ?| array[:keys]", keys: am_idx)
        elsif pm_idx.present?
          search_queries << model.where("item_values -> '#{item.name}' -> 'pm' ?| array[:keys]", keys: pm_idx)
        end
      when 'blank_weekday'
        next if value[:weekday].blank? || value[:option].blank?
        qs = []
        day_values = {}
        if value[:option].kind_of?(Array)
          options = value[:option]
        else
          options = [value[:option]]
        end
        value[:weekday].each do |key, val|
          next if val.blank?
          options.each_with_index do |opt, n|
            option_key = "#{key}_#{n}"
            qs << "(item_values -> '#{item.name}' -> 'weekday' @> :day_value#{option_key})"
            day_values["day_value#{option_key}".to_sym] = {key => opt}.to_json
          end
        end
        search_queries << model.where(qs.join(' OR '), day_values)
      when 'blank_integer'
        if value
          search_queries << model.where("item_values ->> '#{item.name}' IS NOT NULL")
            .where("item_values ->> '#{item.name}' != ''")
            .where("(item_values ->> '#{item.name}')::int >= :value", value: 1)
        end
      when 'blank_date'
        next if value[:date].blank? || value[:option].blank?
        if date = Date.parse(value[:date]) rescue nil
          if value[:option].kind_of?(Array)
            search_queries << model.joins(:dates)
              .where(date_arel_table[:event_date].eq(date)
                .and(date_arel_table[:option_value].in(value[:option])))
          else
            search_queries << model.joins(:dates)
              .where(date_arel_table[:event_date].eq(date)
                .and(date_arel_table[:option_value].eq(value[:option])))
          end
        end
      when 'office_hours'
        weekday = value[:week]
        hour    = value[:hour]
        min     = value[:min]
        weekday_index = Webdb::Entry::WEEKDAY_OPTIONS.index(weekday)
        next if weekday_index.blank? || hour.blank? || min.blank?
        am_open_key = "item_values -> '#{item.name}' -> 'open' ->> '#{weekday_index}'"
        am_close_key = "item_values -> '#{item.name}' -> 'close' ->> '#{weekday_index}'"
        pm_open_key = "item_values -> '#{item.name}' -> 'open2' ->> '#{weekday_index}'"
        pm_close_key = "item_values -> '#{item.name}' -> 'close2' ->> '#{weekday_index}'"
        time_key  = "#{hour.to_i}:#{format("%02d", min.to_i)}"
        search_queries <<   @entries.where("item_values ->> '#{item.name}' IS NOT NULL")
        qs = [
          "(#{am_open_key} != '' AND #{am_close_key} != '' AND (#{am_open_key})::time <= :key::time AND (#{am_close_key})::time >= :key::time)",
          "(#{pm_open_key} != '' AND #{pm_close_key} != '' AND (#{pm_open_key})::time <= :key::time AND (#{pm_close_key})::time >= :key::time)"
        ]

        search_queries <<   @entries.where(qs.join("OR"), key: time_key)
      else
        if value.kind_of?(Array)
          search_queries << model.where("item_values ->> '#{item.name}' IN(:keys)", keys: value)
        else
          search_queries << model.where("item_values ->> '#{item.name}' like :keyword", keyword: "%#{value}%")
        end
      end
    end

    search_queries
  end

  private

  def date_arel_table
    Webdb::EntryDate.arel_table
  end

  def arel_table
    @entries.arel_table
  end

  def ordering(order)
    order == "desc" ? "DESC" : "ASC"
  end

end
