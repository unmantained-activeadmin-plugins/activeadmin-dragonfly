require 'dragonfly'

module ActiveAdmin
  module Dragonfly
    class Engine < ::Rails::Engine

      initializer "Railsyard precompile hook" do |app|
        app.config.assets.precompile += [
          "active_admin/active_admin_dragonfly.js",
          "active_admin/active_admin_dragonfly.css"
        ]
      end

      config.to_prepare do
        ActiveAdmin.application.register_stylesheet "active_admin/active_admin_dragonfly.css", :media => :screen
      end

    end
  end
end
