class Webdb::Piece::Space < Cms::Piece

  default_scope { where(model: 'Webdb::Space') }

  def content
    Webdb::Content::Db.find(super.id)
  end

  def target_db_id
    setting_value(:target_db_id).to_i
  end

  def target_db
    return nil if target_db_id.blank?
    target_dbs.find_by(id: target_db_id)
  end

  def target_dbs
    content.dbs
  end

  def target_dbs_for_option
    target_dbs.map {|g| [g.title, g.id] }
  end

  def target_field_ids
    setting_value(:target_field_ids).present? ? setting_value(:target_field_ids).split(/\s/) : []
  end

  def target_fields
    return [] if target_db.blank?
    return [] if target_field_ids.blank?
    target_db.items.where(id: target_field_ids)
  end

  def target_fields_for_option
    return [] if target_db.blank?
    target_db.items
      .where(Webdb::Item.arel_table[:item_type].matches('%blank%')).map {|g| [g.title, g.id] }
  end

  def field_options
    YAML.load(setting_value(:field_options).presence || '{}')
  end

  def options_for_field(field)
    return [] if field_options.blank?
    return [] if field_options[field.id.to_s].blank?
    return field_options[field.id.to_s]
  end

  def is_checked_option?(field, option)
    return false if field_options.blank?
    return false if field_options[field.id.to_s].blank?
    return field_options[field.id.to_s].include?(option)
  end

end
