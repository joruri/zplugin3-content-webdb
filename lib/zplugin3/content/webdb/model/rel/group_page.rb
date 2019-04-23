# encoding: utf-8
module Zplugin3::Content::Webdb::Model::Rel::GroupPage

  def self.included(mod)
    mod.has_many :group_pages, class_name: 'Webdb::GroupPage', dependent: :destroy
    mod.after_save :save_group_pages
  end

  def build_default_group_pages
    return if group_pages.present?
    group_pages.build
  end

  def in_group_pages
    unless val = @in_group_pages
      val = []
      group_pages.each {|page| val << page.attributes}
      @in_group_pages = val
    end
    @in_group_pages
  end

  def in_group_pages=(values)
    @groups = values
    @in_group_pages = @dates
  end

  def save_group_pages
    return true  unless @groups
    return false unless id
    return false if @_sent_group_pages
    @_sent_group_pages = true
    @groups.each do |in_group_page|
      group_id   = in_group_page[:group_id] || nil
      style_type = in_group_page[:style_type] || 'list'
      next if group_id.blank?
      body = in_group_page[:body] || nil
      group_page = self.group_pages.find_by(group_id: group_id, style_type: style_type) || self.group_pages.build(group_id: group_id, style_type: style_type)
      group_page.db_id      = id
      group_page.group_id   = group_id
      group_page.style_type = style_type
      group_page.body       = body
      group_page.save
    end
    return true
  end


end