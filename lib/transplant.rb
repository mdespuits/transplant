require 'active_support/all'

require 'transplan/configuration'
require 'transplan/stats'
require 'transplan/planter'

Transplant::Configuration.setup do |config|
  config.root_path = Rails.root if defined?(Rails)
  config.output_style = :both
end
