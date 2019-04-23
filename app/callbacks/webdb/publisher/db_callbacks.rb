class Webdb::Publisher::DbCallbacks < PublisherCallbacks
  def enqueue(item)
    @item = item
    return unless enqueue?
    enqueue_pieces
  end

  private

  def enqueue?
    return unless super
    @item.state.in?(%w(public closed draft))
  end

  def enqueue_pieces
    Cms::Publisher::PieceCallbacks.new.enqueue(@item.content.public_pieces)
  end

end
