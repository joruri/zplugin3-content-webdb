# Controller For Managing Piece Settings
class Webdb::Admin::Piece::GroupsController < Cms::Admin::Piece::BaseController

  def base_params_item_in_settings
    [:target_db_id, :target_field_id, :grouping_field_id, :value_field_id, :sort_field_id, :target_url]
  end
end
