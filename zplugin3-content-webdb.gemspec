$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "zplugin3/content/webdb/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "zplugin3-content-webdb"
  s.version     = Zplugin3::Content::Webdb::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "https://github.com/joruri/zplugin3-content-webdb"
  s.summary     = "CustomField Content for JoruriCMS2017"
  s.description = "Add Costum Field Database to JoruriCMS2017"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails"
  s.add_dependency 'will_paginate'
  s.add_dependency 'delayed_job'
  s.add_dependency 'delayed_job_active_record'
  s.add_dependency 'delayed_job_master'
  s.add_dependency "pg"

end
