require 'custom_rails_importer/stats'

module Importer
  class Manager

    def self.connect(credentials = {}, local_conn)
      @@remote = Mysql2::Client.new credentials
      @@local ||= local_conn
    end

    def self.local(sql)
      @@local.execute sql
    end

    def self.save(klass, other = {})
      nice_class_name = klass.class.to_s.tableize.humanize
      if klass.valid?
        klass.save!
        increment
        klass
      else
        increment_failure(klass.class.to_s)
        puts "Invalid #{nice_class_name} information:"
        Stats.output("Additional Info about #{nice_class_name}", other)
        Stats.output("#{nice_class_name} errors", klass.errors.full_messages)
        Stats.output("#{nice_class_name} attributes:", klass.attributes)
        return false
      end
    end

    def self.remote(sql)
      @@remote.query(sql)
    end

    def self.local_tables
      tables = @@local.tables
      tables.delete 'schema_migrations'
      tables
    end

    def self.local_truncate(*tables)
      tables.each { |table| local "TRUNCATE TABLE #{table.to_s}" }
    end

    def self.local_truncate_all
      local_truncate *local_tables
    end

    def self.increment
      @@total_records ||= 0
      @@total_records += 1
    end

    def self.increment_failure(klass_name)
      @@failures              ||= Hash.new
      @@failures[klass_name]  ||= 0
      @@failures[klass_name]  += 1
    end

    def self.failures
      @@failures
    rescue
      @@failures ||= Hash.new
    end

    def self.total_records
      @@total_records
    rescue
      @@total_records ||= Hash.new
    end
  end
end
