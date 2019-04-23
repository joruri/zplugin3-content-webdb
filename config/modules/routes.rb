mod = "webdb"
ZomekiCMS::Application.routes.draw do
  ## admin
  scope "#{ZomekiCMS::ADMIN_URL_PREFIX}/#{mod}/c:concept", :module => mod, :as => mod do
    resources :content_base,
      :controller => 'admin/content/base'

    resources :content_settings, :only => [:index, :show, :edit, :update],
      :controller => 'admin/content/settings',
      :path       => ':content/content_settings'

  #  ## contents
    resources(:dbs,
      :controller => 'admin/dbs',
      :path       => ':content/dbs') do
      member do
        get :delete_page
      end
      resources :items,
        :controller => 'admin/items' do
        collection do
          post :build
          put :build
        end
      end
      resources :entries,
        :controller => 'admin/entries' do
          get 'file_contents/(*path)' => 'admin/entries/files#content'
          member do
            get :delete_event
          end
          collection do
            post :import
            get  :import
          end
        end
      end

    ## nodes
    resources :node_dbs,
      :controller => 'admin/node/dbs',
      :path       => ':parent/node_dbs'

    ## pieces
    resources :piece_forms,
      :controller => 'admin/piece/forms'
    resources :piece_maps,
      :controller => 'admin/piece/maps'
    resources :piece_groups,
      :controller => 'admin/piece/groups'
    resources :piece_spaces,
      :controller => 'admin/piece/spaces'
  end


  ## public
  scope "_public/#{mod}", :module => mod, :as => '' do
    #db search
    get  'node_dbs(/index)'            => 'public/node/dbs#index'
    get  'node_dbs/list(/index)'       => 'public/node/dbs#editors'
    get  'node_dbs/:id(/index)'        => 'public/node/dbs#show'
    get  'node_dbs/:db_id/search'      => 'public/node/dbs#result'
    get  'node_dbs/:db_id/entry/:name(/index)' => 'public/node/dbs#entry'
    get  'node_dbs/:db_id/entry/:name/file_contents/(*path)' => 'public/node/dbs#file_content'
    get  'node_dbs/:db_id/edit/:name(/index)' => 'public/node/dbs#edit'
    put  'node_dbs/:db_id/edit/:name(/index)' => 'public/node/dbs#update'
    get  'node_dbs/:db_id/delete_event/:name(/index)' => 'public/node/dbs#delete_event'
  end

end
