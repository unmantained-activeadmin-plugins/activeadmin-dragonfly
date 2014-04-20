$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_admin/dragonfly/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "activeadmin-dragonfly"
  s.version     = ActiveAdmin::Dragonfly::VERSION
  s.authors     = ["Stefano Verna"]
  s.email       = ["stefano.verna@gmail.com"]
  s.homepage    = "http://github.com/cantierecreativo/activeadmin-dragonfly"
  s.summary     = "Adds a new :dragonfly field type to ActiveAdmin"
  s.description = "Adds a new :dragonfly field type to ActiveAdmin"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "activeadmin"
  s.add_dependency "dragonfly"
  s.add_dependency "rack-cache"
end

