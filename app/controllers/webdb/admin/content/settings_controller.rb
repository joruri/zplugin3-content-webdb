# Controller For Managing Content Settings
class Webdb::Admin::Content::SettingsController < Cms::Admin::Content::SettingsController
  def model
    Webdb::Content::Setting
  end
end