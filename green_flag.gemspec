$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "green_flag/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "green_flag"
  s.version     = GreenFlag::VERSION
  s.authors     = ["Tim Morton", "Jason Nappier", "Adeel Raza"]
  s.email       = ["tim@timothymorton.com"]
  s.homepage    = "https://github.com/websdotcom/green_flag"
  s.summary     = "A feature-flag system."
  s.description = <<-EOF
    A feature-flag system that makes it *really easy* for application developers
    to add and manage features.  You can roll out features to a percentage of 
    your users, or you can define groups to see the new feature.  
    Want to test a new feature on 50% of your premium-plan users named "Fred"?  
    GreenFlag can do that.
  EOF
  s.license = "MIT"

  s.files = `git ls-files`.split($/)
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2"
  s.add_dependency "pg"
  s.add_dependency "activerecord-concurrent-index"

  # Assets for the admin pages
  s.add_dependency "jquery-rails"
  s.add_dependency "sass-rails"
  s.add_dependency "uglifier"

  s.add_development_dependency 'rspec-rails', "~> 2"
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'gem-release'
end
