# -*- encoding: utf-8 -*-
require File.expand_path('../lib/custom_rails_importer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Matt Bridges"]
  gem.email         = ["mbridges.91@gmail.com"]
  gem.description   = %q{A Simple class to migrate data from an old system into your Rails applicaiton.}
  gem.summary       = %q{Migrate from an old application into Rails.}
  gem.homepage      = "http://github.com/mattdbridges/importer"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "custom_rails_importer"
  gem.require_paths = ["lib"]
  gem.version       = Importer::VERSION

  gem.add_dependency "activesupport", "~> 3.2.2"
  gem.add_dependency "mysql2", "~> 0.3.11"
  gem.add_development_dependency "rspec", "~> 2.9.0"
  gem.add_development_dependency "rake", "~> 0.9.2.2"
end
