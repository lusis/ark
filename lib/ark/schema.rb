module Ark
  class Schema
    include Ark::SchemaValidations

    attr_accessor :errors, :definition
    attr_reader :db, :parsed_schema

    class << self

      def add(definition)
        s = self.new
        s.definition = definition
        s.save
      end

      def load(schema_name)
        s = self.new
        data = s.db.get("#{BASEPATH}/#{schema_name}.json")
        s.definition = data
        s.valid? ? create_class(s.parsed_schema) : false
      end

      def basepath
        "_schema"
      end
    end

    def initialize
      @db = Ark::Repo.db || Ark::Repo.connect
    end

    def valid?
      validate_schema
    end

    def save
      if valid?
        @db.set("#{basepath}/#{@parsed_schema['id']}.json", @definition, "Adding schema - #{@parsed_schema['id']}")
      else
        false
      end
    end

    private
    def self.create_class(schema)
      klass_name = schema['id'].capitalize
      klass = Ark.const_set(klass_name, Class.new(Ark::Record))
      klass.class_eval do
        attr_accessor *schema['attributes']
      end
    end

  end
end
