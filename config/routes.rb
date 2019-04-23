mod = "webdb"

Zplugin3::Content::Webdb::Engine.routes.draw do
  root "#{mod}/contents#index"
  scope "/", :module => mod, :as => mod do
    resources :contents do
      collection do
        get :install
      end
    end
  end
end

