module GreenFlag
  class Engine < ::Rails::Engine
    isolate_namespace GreenFlag

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer "green_flag.site_visitor_management" do |app|
      ActionController::Base.send :include, GreenFlag::SiteVisitorManagement
    end

    initializer "Asset precompilation", :group => :all do |app|
      app.config.assets.precompile += %w(
        green_flag/admin/feature-deletion.js
        green_flag/admin/features.js
        green_flag/admin/rules.js
        green_flag/admin/features.css
        green_flag/admin/rules.css
      )
    end
  end
end
