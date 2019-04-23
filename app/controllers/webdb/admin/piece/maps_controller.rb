# Controller For Managing Piece Settings
class Webdb::Admin::Piece::MapsController < Cms::Admin::Piece::BaseController
  private

  def base_params_item_in_settings
    [:target_db_id, :window_text]
  end
end
