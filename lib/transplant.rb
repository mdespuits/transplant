require 'active_support/all'

%w[version configuration stats planter].each do |klass|
  require "transplant/#{klass}"
end

Transplant::Configuration.setup do |config|
  config.root_path = Rails.root if defined?(Rails)
  config.output_style = :both
end
