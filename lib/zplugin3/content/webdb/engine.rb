module Zplugin3
  module Content
    module Webdb
      class Engine < ::Rails::Engine
        config.autoload_paths << File.expand_path("../../../../../lib", __FILE__)
        config.after_initialize do |app|
          app.config.x.engines << self
        end

        class << self
          def install
            system("bundle exec rake #{engine_name}:install:migrations RAILS_ENV=#{Rails.env}")
            system("bundle exec rake db:migrate SCOPE=#{engine_name} RAILS_ENV=#{Rails.env}")
          end

          def uninstall
            ::Webdb::Content::Db.destroy_all

            system("bundle exec rake db:migrate SCOPE=#{engine_name} VERSION=0 RAILS_ENV=#{Rails.env}") &&
            system("rm -rf #{Rails.root.join("db/migrate/*.#{engine_name}.rb")}")
          end
        end
      end
    end
  end
end
