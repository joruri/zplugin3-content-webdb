class Webdb::Admin::ItemsController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base

  def pre_dispatch
    @content = Webdb::Content::Db.find(params[:content])
    return error_auth unless Core.user.has_priv?(:read, item: @content.concept)
    @db = @content.dbs.find(params[:db_id])
  end

  def index
    items = @db.items
    @items = items.paginate(page: params[:page], per_page: params[:limit])
    respond_to do |format|
      format.html { render }
      format.json  { render :json => items.to_json }
    end
  end

  def show
    @item = @db.items.find(params[:id])
    respond_to do |format|
      format.html { render }
      format.json  { render :json => @item.to_json }
    end
  end

  def new
    @item = @db.items.build
  end

  def create
    @item = @db.items.build(item_params)
    _create @item
  end

  def update
    @item = @db.items.find(params[:id])
    @item.attributes = item_params
    _update @item
  end

  def destroy
    @item = @db.items.find(params[:id])
    _destroy @item
  end

  def build
    @item_values = params[:item] && params[:item][:item_values] ? params[:item][:item_values] : {}
    render 'build', layout: false
  end

  private

  def item_params
    params.require(:item).permit(:item_options, :item_type, :name, :sort_no,
      :state, :style_attribute, :title, :is_target_sort, :is_target_search,
      :is_target_keyword, :is_limited_access, :reference_id, :reference_item_id, :icon_item_id,
      :creator_attributes => [:id, :group_id, :user_id])
  end
end
