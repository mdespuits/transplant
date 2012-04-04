module Transplant
  class Planter

    attr_accessor :app_name, :connection

    def initialize(app_name, connection)
      @app_name = app_name
      @connection = connection
      @queries ||= []
      @results ||= {}
    end

    def query(sql)
      return @results[sql] if @queries.include?(sql)
      @queries << sql
      @results[sql] = @connection.execute(sql)
    end

    def save(klass, other = {})
      klass_name = klass.class.to_s.tableize.humanize
      if klass.valid?
        klass.save!
        increment
        klass
      else
        increment_failure(klass.class.to_s)
        puts "Invalid #{klass_name} information:"
        Stats.output("Additional Info about #{klass_name}", other)
        Stats.output("#{klass_name} errors", klass.errors.full_messages)
        Stats.output("#{klass_name} attributes:", klass.attributes)
        return false
      end
    end

    def tables
      return @tables if @tables.present?
      @tables ||= @connection.tables
      @tables.delete 'schema_migrations'
      @tables
    end

    def column_names(table_name)
      connection.columns(table_name).map(&:name)
    end

    def truncate(*tables)
      tables.each { |table| self.query "TRUNCATE TABLE #{table.to_s}" }
    end

    def truncate_all
      truncate *tables
    end

    def increment
      @total_records ||= 0
      @total_records += 1
    end

    def increment_failure(klass_name)
      @failures              ||= Hash.new
      @failures[klass_name]  ||= 0
      @failures[klass_name]  += 1
    end

    def failures
      @failures
    rescue
      @failures ||= Hash.new
    end

    def total_records
      @total_records
    rescue
      @total_records ||= Hash.new
    end
  end
end
