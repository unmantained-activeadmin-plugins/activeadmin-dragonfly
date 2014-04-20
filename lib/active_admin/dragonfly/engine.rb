require 'dragonfly'

module ActiveAdmin
  module Dragonfly

    class Engine < ::Rails::Engine
      initializer "Railsyard precompile hook", group: :all do |app|
        # check if someone already initialized Dragonfly for Rails
        if ::Dragonfly::VERSION < "1" and not ActiveRecord::Base.methods.include? :image_accessor
          require 'dragonfly/rails/images'
        end

        app.config.assets.precompile += [
          "active_admin/active_admin_dragonfly.js",
          "active_admin/active_admin_dragonfly.css"
        ]
      end

      initializer "register stylesheets" do
        ActiveAdmin.application.register_stylesheet "active_admin/active_admin_dragonfly.css", :media => :screen
      end
    end

  end
end
