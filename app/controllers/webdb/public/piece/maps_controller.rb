class Webdb::Public::Piece::MapsController < Sys::Controller::Public::Base
  def pre_dispatch
    @piece = Webdb::Piece::Map.find_by(id: Page.current_piece.id)
    return render plain: '' if @piece.blank?
    @content = @piece.content
    @db      = @piece.target_db
    return render plain: '' if @db.blank?
  end

  def index
    @items   = @db.entries.public_state
    @markers = @items.joins(maps: :markers)
  end

end
