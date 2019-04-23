class Webdb::Public::Piece::GroupsController < Sys::Controller::Public::Base
  def pre_dispatch
    @piece = Webdb::Piece::Group.find_by(id: Page.current_piece.id)
    return render plain: '' if @piece.blank?
    @content = @piece.content
    return render plain: '' if @content.blank?
    @db      = @piece.target_db
    @node    = @content.public_node
    @target_field = @piece.target_field
    return render plain: '' if @db.blank?
    return render plain: '' if @target_field.blank?
  end

  def index
    @reference_db = @target_field.reference_db
    return render plain: '' if @reference_db.blank?
    return render plain: '' unless @group_field = @piece.grouping_field
    return render plain: '' unless @value_field = @piece.value_field

    groups = @reference_db.entries.public_state
    if sort_field = @piece.sort_field
      groups = groups.order(Arel.sql("item_values -> '#{sort_field.name}' ASC"))
    end

    groups = groups.map{|a|
        { group: a.item_values.dig(@group_field.name),
          title: a.item_values.dig(@value_field.name),
          value: a.id} }
    @forms = groups.group_by{ |i| i[:group]}
    @target_url = @piece.target_url || "#{@node.try(:public_uri)}#{@db.id}/search"
  end

end
