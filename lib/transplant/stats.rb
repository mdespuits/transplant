module Transplant
  class Stats

    def initialize(transplanter)
      @transplanter = transplanter
    end

    def output_all_info(opts = {})
      total_import_time(opts[:measurement]) if opts[:measurement].present?
      total_import_records
      @transplanter.failures
    end

    class << self

      def output(header, input, depth = 0, sub_output = false)
        if input.is_a? Hash
          hash_output(header, input, depth, sub_output)
        elsif input.is_a? Array
          array_output(header, input, depth, sub_output)
        end
      end

      def hash_output(header, hash, depth = 0, sub_hash = false)
        puts tabs(depth) + "#{header}:" if hash.any? && header.present?
        hash.each_pair do |key, value|
          if value.is_a?(Hash) || value.is_a?(Array)
            output(key, value, depth + 1, sub_hash = true)
          else
            puts tabs(depth + 1) + "#{key}: #{value}"
          end
        end
      end

      def array_output(header, array, depth = 0, sub_array = false)
        puts tabs(depth) + "#{header}:" if array.any? && header.present?
        array.each do |item|
          if item.is_a?(Hash) || item.is_a?(Array)
            output("", item, depth + 1, sub_hash = true)
          else
            puts tabs(depth + 1) + "* #{item}"
          end
        end
      end

      def tabs(count)
        "\t"*count
      end
      private :tabs

    end

    def total_import_records
      puts "Estimated number of records imported into #{@transplanter.app_name}: #{@transplanter.total_records}"
    end

    def total_import_time(measurement)
      puts "Total time taken to import everything into #{@transplanter.app_name}: #{(measurement.real/60).round(2)} minutes"
    end

    def failures
      if @transplanter.failures.count <= 0
        puts "\nNo failed record imports!!!! Time to par-tay!!!!\n"
      else
        failures = Hash[@transplanter.failures.map { |key, value| [key.tableize.humanize, value] }]
        self.class.output("\nTotal number failed imports to #{@transplanter.app_name}:", failures)
      end
    end

  end
end
