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
        @db.set("#{self.class.basepath}/#{@parsed_schema['id']}.json", @definition, "Adding schema - #{@parsed_schema['id']}")
      else
        false
      end
    end

  end
end
