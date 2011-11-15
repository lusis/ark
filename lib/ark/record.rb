module Ark
  module Record
    # Ignore this for now
    # I've been dithering back and forth on the API all night
    # The way you use this is:
    # class Host; include Ark::Record; end
    # As long as there's a valid schema for `host`,
    # you'll have a workable class
    # 
    # However, I think there's a use case for combo record+schema creation..

    def self.included(base)
      db = Ark::Repo.db || Ark::Repo.connect
      base.extend ClassMethods
      klass = base.to_s.gsub(/^.*::/, '').downcase
      begin
        record = db.get("_schema/#{klass}.json")
        raise Ark::SchemaNotFoundError if record.nil?
        data = ::JSON.parse(record)
      end
      base.class_eval do
        attr_accessor *data['attributes']
        attr_reader :schema, :basepath, :errors, :record_type, :db

        define_method("schema") { instance_variable_set("@schema", data) }
        define_method("basepath") { instance_variable_set("@basepath", "_objects") }        
        define_method("record_type") { instance_variable_set("@record_type", data['id']) }
        define_method("db") { instance_variable_set("@db", db) }
      end
    end

    module ClassMethods
      include Ark::Validations::Record

      def valid?
        validate_record
      end

      def save
        self.valid? ? @db.set("#{@basepath}/#{@name}.json", data, "Setting #{@record_type} - #{@name}") : false
      end

      def self.[](key)
      end

    end
  end
end
