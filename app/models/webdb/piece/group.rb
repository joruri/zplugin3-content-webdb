class Webdb::Piece::Group < Cms::Piece

  default_scope { where(model: 'Webdb::Group') }

  def content
    Webdb::Content::Db.find(super.id)
  end

  def target_url
    setting_value(:target_url)
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

  def target_field_id
    setting_value(:target_field_id).to_i
  end

  def target_field
    return nil if target_db.blank?
    return nil if target_field_id.blank?
    target_db.items.where(id: target_field_id).first
  end

  def target_fields_for_option
    return [] if target_db.blank?
    target_db.public_items
      .where(Webdb::Item.arel_table[:item_type].matches('%data%')).map {|g| [g.title, g.id] }
  end

  def grouping_field_id
    setting_value(:grouping_field_id).to_i
  end

  def grouping_field
    return nil if target_field.blank?
    return nil if grouping_field_id.blank?
    return nil unless referemce_db = target_field.reference_db
    referemce_db.items.where(id: grouping_field_id).first
  end

  def value_field_id
    setting_value(:value_field_id).to_i
  end

  def value_field
    return nil if target_field.blank?
    return nil if value_field_id.blank?
    return nil unless referemce_db = target_field.reference_db
    referemce_db.items.where(id: value_field_id).first
  end

  def sort_field_id
    setting_value(:sort_field_id).to_i
  end

  def sort_field
    return nil if target_field.blank?
    return nil if sort_field_id.blank?
    return nil unless referemce_db = target_field.reference_db
    referemce_db.items.where(id: sort_field_id).first
  end

  def grouping_fields_for_option
    return [] if target_field.blank?
    return [] unless referemce_db = target_field.reference_db
    referemce_db.items.map {|g| [g.title, g.id] }
  end

end
