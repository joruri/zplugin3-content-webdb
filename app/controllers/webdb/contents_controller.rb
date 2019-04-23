class Webdb::ContentsController < Cms::Controller::Admin::Base
  layout  'admin/cms'

  def pre_dispatch
    return http_error(403) unless Core.user.root?
  end

  def index
    @items = Webdb::Content::Db.paginate(page: params[:page], per_page: 10)
  end

  def install
    Zplugin3::Content::Webdb::Engine.install
    redirect_to url_for(action: :index), notice: 'インストールしました。'
  end

end
