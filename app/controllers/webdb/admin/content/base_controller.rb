# Controller For Managing Content Data

class Webdb::Admin::Content::BaseController < Cms::Admin::Content::BaseController
  layout  'admin/cms'
  def model
    Webdb::Content::Db
  end
end