class Webdb::Public::Piece::FormsController < Sys::Controller::Public::Base
  def pre_dispatch
    @piece = Webdb::Piece::Form.find_by(id: Page.current_piece.id)
    return render plain: '' if @piece.blank?
    @content = @piece.content
    @db      = @piece.target_db
    @node    = @content.public_node
    return render plain: '' if @db.blank?
    return render plain: '' if @node.blank?
  end

  def index
    @items = @db.public_items.target_search_state
  end

end
