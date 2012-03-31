module Transplant
  class Stats

    def initialize(transplanter)
      @transplanter = importer
    end

    def output_all_info(opts = {})
      total_import_time(opts[:measurement]) if opts[:measurement].present?
      total_import_records
      failures
    end

    def self.output(header, input, depth = 0, sub_output = false)
      if input.is_a? Hash
        hash_output(header, input, depth, sub_output)
      elsif input.is_a? Array
        array_output(header, input, depth, sub_output)
      end
    end

    def self.hash_output(header, hash, depth = 0, sub_hash = false)
      puts "#{"\t"*depth}#{header}:" if hash.any?
      hash.each_pair do |key, value|
        if value.is_a? Hash
          hash_output("", value, depth + 1, sub_hash = true)
        elsif value.is_a? Array
          array_output("", value, depth + 1, sub_array = true)
        else
          puts "#{"\t"*(depth + 1)}#{key}: #{value}"
        end
      end
    end

    def self.array_output(header, array, depth = 0, sub_array = false)
      puts "#{"\t"*depth}#{header}:" if array.any?
      array.each do |item|
        if item.is_a? Array
          array_output("", item, depth + 1, sub_array = true)
        elsif item.is_a? Hash
          hash_output("", item, depth + 1, sub_hash = true)
        else
          puts "#{"\t"*(depth + 1)}* #{item}"
        end
      end
    end

    def total_import_records
      puts "\nTotal number of records imported into myCollegePlus: #{@transplanter.total_records}"
    end

    def total_import_time(measurement)
      puts "Total time taken to import everything into myCollegePlus"
      puts measurement
    end

    def failures
      if @transplanter.failures.count <= 0
        puts "\nNo failed record imports!!!! Time to par-tay!!!!\n"
      else
        failures = Hash[@transplanter.failures.map { |key, value| [key.tableize.humanize, value] }]
        Stats.output("\nTotal number failed imports to myCollegePlus:", failures)
      end
    end

  end
end
