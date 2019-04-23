class Webdb::Piece::Form < Cms::Piece

  default_scope { where(model: 'Webdb::Form') }

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


end
