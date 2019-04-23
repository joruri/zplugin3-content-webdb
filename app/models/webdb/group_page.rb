class Webdb::GroupPage < ApplicationRecord
  include Sys::Model::Base
  belongs_to :db
  validates :db_id, presence: true

  delegate :content, to: :db

  TYPE_OPTIONS = [['一覧形式HTML', 'list'], ['詳細形式HTML', 'detail']]

  def group
    return nil unless defined?(Zplugin3::Content::Login::Engine)
    Login::Group.find_by(id: group_id)
  end

  def style_type_text
    TYPE_OPTIONS.each{|a| return a[0] if a[1] == style_type }
    return nil
  end

end
