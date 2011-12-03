module Ark
  class Schema
    include Ark::Validations::Schema
    include Ark::Helpers

    attr_accessor :errors, :definition
    attr_reader :db, :parsed_schema, :version

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

    def is_new?
      # logic here for marking a record new or not
      # existing records will need to be diffed first
    end

    def save
      if valid?
        commit = @db.set("#{self.class.basepath}/#{@parsed_schema['id']}.json", @definition, "Adding schema - #{@parsed_schema['id']}")
        self.instance_variable_set "@version", commit
        commit
      else
        false
      end
    end

    # Here's the deal
    # working copies of repos work differently than bare repos (duh!)
    # the git binary does the magic of determining if something in your working directory
    # is different than what's in the repo
    #
    # Grit provides a diff command but we're working with a bare repo
    # So we just minify the json and do our own comparison
    def diff(old_val, new_val)
      minify_json(old_val) == minify_json(new_val)
    end

    private
    def load_schema(name)
      @definition = minify_json(@db.get("#{self.class.basepath}/#{name}.json"))
      @definition.nil? ? @parsed_schema=nil : @parsed_schema=::JSON.parse(@definition)
    end
  end
end
