module Transplant
  class Stats

    def initialize(transplanter)
      @planter = transplanter
    end

    def output_all_info(opts = {})
      total_import_time(opts[:measurement]) if opts[:measurement].present?
      total_import_records
      successes
      failures
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
            puts tabs(depth + 1) + "* #{key}: #{value}"
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
      puts "Estimated number of records imported into #{@planter.app_name}: #{@planter.total_successes}"
    end

    def total_import_time(m)
      puts "Total time taken to import everything into #{@planter.app_name}: #{(m.real/60).round(2)} minutes"
    end

    def successes
      if @planter.successes.count <= 0
        puts "\nNo records were imported! Boo!!!!\n"
      else
        count = Hash[@planter.successes.map { |key, value| [key.tableize.humanize, value] }]
        self.class.output("\nEstimated number of successful imports to #{@planter.app_name}", count)
      end
    end

    def failures
      if @planter.failures.count <= 0
        puts "\nNo failed record imports!!!! Time to par-tay!!!!\n"
      else
        count = Hash[@planter.failures.map { |key, value| [key.tableize.humanize, value] }]
        self.class.output("\nEstimated number failed imports to #{@planter.app_name}", count)
      end
    end

  end
end
