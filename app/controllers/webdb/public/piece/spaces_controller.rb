class Webdb::Public::Piece::SpacesController < Sys::Controller::Public::Base
  def pre_dispatch
    @piece = Webdb::Piece::Space.find_by(id: Page.current_piece.id)
    return render plain: '' if @piece.blank?
    @content = @piece.content
    @db      = @piece.target_db
    @node    = @content.public_node
    return render plain: '' if @db.blank?
  end

  def index
    @items = @piece.target_fields
  end

end
