require 'active_support/all'

%w[version configuration stats planter].each do |klass|
  require "transplant/#{klass}"
end
