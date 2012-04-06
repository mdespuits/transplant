module Transplant
  class Planter

    attr_accessor :app_name, :connection, :statistician

    def initialize(app_name, connection)
      @app_name = app_name
      @connection = connection
      @statistician = Stats.new(self)
      @queries ||= []
      @results ||= {}
    end

    def query(sql)
      return @results[sql] if @queries.include?(sql)
      @queries << sql
      @results[sql] = @connection.execute(sql)
    end

    def save(klass, other = {})
      klass_name = klass.class.to_s.tableize.humanize.singularize
      if klass.valid?
        klass.save!
        succeed klass_name
        klass
      else
        fail(klass_name)
        @statistician.output "Invalid #{klass_name} information:"
        @statistician.output("Additional Info about #{klass_name}", other)
        @statistician.output("#{klass_name} errors", klass.errors.full_messages)
        @statistician.output("#{klass_name} attributes", klass.attributes)
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

    def succeed(klass_name)
      @successes              ||= Hash.new
      @successes[klass_name]  ||= 0
      @successes[klass_name]  += 1
    end

    def fail(klass_name)
      @failures              ||= Hash.new
      @failures[klass_name]  ||= 0
      @failures[klass_name]  += 1
    end

    def failures
      @failures ||= Hash.new
    end

    def successes
      @successes ||= Hash.new
    end

    def total_successes
      @successes.map { |table, count| count }.inject{ |sum,x| sum + x }
    end
  end
end
