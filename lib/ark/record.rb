module Ark
  module Record
    class << self
      def find(type, key)
        db = Ark::Repo.db || Ark::Repo.connect
        db.get("_objects/#{type}/#{key}.json")
        # This is currently returning JSON,
        # needs to return instance of type class
      end

      def all(type)
        # This is going to suck balls and probably be slow.
        # God help me for even thinking about doing this.
      end
    end

    attr_reader :record_type, :schema, :attributes, :errors

    def initialize(opts={})
      @record_type = opts[:record_type] || self.class.record_type || self.class.to_s.gsub(/^.*::/, '').downcase
      @schema = Ark::Schema[@record_type] || Ark::Schema.new
      unless @schema.parsed_schema.nil?
        @schema.parsed_schema['attributes'].each {|a| self.class.send :attr_accessor, a}
        @attributes = @schema.parsed_schema['attributes']
      end
    end

    def valid?
      self.validate_record
    end

    def save
      if valid?
        @schema.db.set("_objects/#{@record_type}/#{@name}.json", self.to_hash.to_json, "Adding #{@record_type} - #{@name}")
      else
        false
      end      
    end

    def to_hash
      h = {}
      @attributes.each do |attr|
        a = instance_variable_get("@#{attr}")
        h[attr] = a unless a.nil?
      end
      h
    end

    def self.included(base)
      base.extend ClassMethods
    end

    def self.included(base)
      db = Ark::Repo.db || Ark::Repo.connect
      base.extend ClassMethods
      base.send :include, Ark::Validations::Record
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