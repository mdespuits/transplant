require 'active_support/core_ext/class'

module Transplant
  class Configuration

    cattr_accessor :root_path
    cattr_accessor :output_style
    cattr_accessor :file_output_format

    class << self

      def setup
        yield self
      end

    end

  end
end
