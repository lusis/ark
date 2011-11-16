module Ark
  class Schema
    include Ark::Validations::Schema

    attr_accessor :errors, :definition
    attr_reader :db, :parsed_schema

    class << self

      def add(definition)
        s = self.new
        s.definition = definition
        s.save
      end

      def [](key)
        self.load(key)
      end

      def load(key)
        self.new(key)
      end

      def basepath
        "_schema"
      end

    end

    def initialize(schema_name=nil)
      @db = Ark::Repo.db || Ark::Repo.connect
      load_schema(schema_name) if schema_name
    end

    def valid?
      validate_schema
    end

    def save
      if valid?
        @db.set("#{self.class.basepath}/#{@parsed_schema['id']}.json", @definition, "Adding schema - #{@parsed_schema['id']}")
      else
        false
      end
    end

    private
    def load_schema(name)
      @definition = @db.get("#{self.class.basepath}/#{name}.json").gsub(/\n|\s+/,'')
      @definition.nil? ? @parsed_schema=nil : @parsed_schema=::JSON.parse(@definition)
    end
  end
end
