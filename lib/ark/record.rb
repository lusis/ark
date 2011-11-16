module Ark
  module Record

    attr_reader :record_type, :schema

    def initialize(opts={})
      @record_type = opts[:record_type] || self.class.record_type || self.class.to_s.gsub(/^.*::/, '').downcase
      @schema = Ark::Schema[@record_type] || Ark::Schema.new
      unless @schema.parsed_schema.nil?
        #load attributes as keys
      end
    end

    def valid?
    end

    def save
    end

    def self.included(base)
      base.extend ClassMethods
    end

    def self.included(base)
      db = Ark::Repo.db || Ark::Repo.connect
      base.extend ClassMethods
    end

    module ClassMethods
      attr_accessor :record_type

      def validate_as(val)
        @record_type = val
        return
      end

      def [](key)
      end
    end
  end
end
