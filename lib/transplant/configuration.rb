module Transplant
  class Configuration
    class << self
      attr_accessor :root_path, :output_style, :file_output_format

      def setup
        yield self
      end
    end
  end
end
