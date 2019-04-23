# encoding: utf-8
module Zplugin3::Content::Webdb::Model::Rel::RelatedPage

  def self.included(mod)
    mod.after_save :save_html_cache
  end

  def save_html_cache
    Gis::CacheHtmlJob.perform_later
  end

end