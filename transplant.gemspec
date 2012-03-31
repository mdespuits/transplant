# -*- encoding: utf-8 -*-
require File.expand_path('../lib/transplant/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Matt Bridges"]
  gem.email         = ["mbridges.91@gmail.com"]
  gem.description   = %q{Transplant your data from your old database into your new Rails application}
  gem.summary   = %q{Transplant your data from your old database into your new Rails application}
  gem.homepage      = "http://github.com/mattdbridges/transplant"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "transplant"
  gem.require_paths = ["lib"]
  gem.version       = Transplant::VERSION

  gem.add_dependency "activesupport", "~> 3.2.2"
  gem.add_dependency "mysql2", "~> 0.3.11"
  gem.add_development_dependency "rspec", "~> 2.9.0"
  gem.add_development_dependency "rake", "~> 0.9.2.2"
end
