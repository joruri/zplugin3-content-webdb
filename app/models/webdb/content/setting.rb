class Webdb::Content::Setting < Cms::ContentSetting

  belongs_to :content, foreign_key: :content_id, class_name: 'Webdb::Content::Db'

  set_config :map_setting,
    name: '地図設定',
    form_type: :radio_buttons,
    options: [['使用する', 'enabled'], ['使用しない', 'disabled']],
    default_value: 'enabled',
    default_extra_values: {
      lat_lng: ''
    }

  def extra_values=(params)
    ex = extra_values
    case name
    when 'map_setting'
      ex[:lat_lng] = params[:lat_lng]
    end
    super(ex)
  end

end
