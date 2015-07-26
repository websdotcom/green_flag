$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "green_flag/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "green_flag"
  s.version     = GreenFlag::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of GreenFlag."
  s.description = "TODO: Description of GreenFlag."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.22"
  s.add_dependency "pg"
  s.add_dependency "activerecord-concurrent-index"
  s.add_dependency "sass-rails"

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'capybara'
end
