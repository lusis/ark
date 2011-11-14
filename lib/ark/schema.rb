module Ark
  class Schema
    REQUIRED_KEYS = ["id","attributes"]
    OPTIONAL_KEYS = ["validations", "key"]
    VALIDATIONS = ["required", "unique", "member"]
    BASEPATH = "_schema"

    # A valid schema looks something like this:
    # {"id":"host",
    #   "attributes":["name","status"],
    #   "validations:{
    #     "required":["name"],
    #     "unique":["name"]
    #     "member":{
    #       "status":["up","down","pending-up","pending-down"]
    #     }
    #   }
    # }
    #
    # This says that a Host must have a unique name
    # and that status must be one of 'status'
    # If no key is defined, an attribute 'name' must be defined.
    attr_accessor :errors, :definition
    attr_reader :db, :parsed_schema

    def initialize
      @db = Ark::Repo.db || Ark::Repo.connect
    end

    def save
      self.valid? ? @db.set("#{BASEPATH}/#{@parsed_schema['id']}.json", @definition, "Adding schema - #{@parsed_schema['id']}") : false
    end

    def self.add(definition)
      s = self.new
      s.definition = definition
      s.save
    end

    def self.load(schema_name)
      s = self.new
      data = s.db.get("#{BASEPATH}/#{schema_name}.json")
      s.definition = data
      s.valid? ? create_class(s.parsed_schema) : false
    end

    def valid?
      validate_schema
    end

    private
    def self.create_class(schema)
      klass_name = schema['id'].capitalize
      klass = Ark.const_set(klass_name, Class.new(Ark::Record))
      klass.class_eval do
        attr_accessor *schema['attributes']
      end
    end

    def validate_schema(schema_def=self.definition)
      errors = []
      begin
        # Is it valid JSON?
        schema = ::JSON.parse(schema_def)
        @parsed_schema = schema

        # Some shortcuts
        keys = schema.keys
        schema_id = schema['id']
        attributes = schema['attributes']
        validations = schema['validations']
        key = schema['key']

        # Are all the required keys there?
        REQUIRED_KEYS.each do |key|
          errors << [:schema, "missing_required_key_#{key}".to_sym] unless keys.member?(key)
        end

        # Is id a string?
        errors << [:id, :not_string] if schema_id.class != String

        # Do we have a key?
        errors << [:primary_key, :not_defined] if key.nil? && attributes.member?('name').nil?

        # If we have validations
        # Are they ones we understand?
        unless validations.nil?
          validations.each do |type, values|
            # Match against known validation types
            errors << [type.to_sym, :unknown_validation_type] unless VALIDATIONS.member?(type)
            if type == "member"
              values.each do |member_key, member_opts|
                if member_opts.class != Array
                  errors << [:member, :member_must_be_array]
                else
                  errors << [:member, :unknown_attribute_in_validation] unless attributes.member?(member_key)
                end
              end
            else
              if validations[type].class != Array
                errors << [type.to_sym, "#{type}_must_be_array".to_sym]
              else
                validations[type].each do |attr|
                  errors << [type.to_sym, :unknown_attribute_in_validation] unless attributes.member?(attr)
                end
              end
            end
          end
        end
      rescue NoMethodError
        # bad form, I know..
        @errors = errors
      rescue JSON::ParserError
        errors << [:schema, :not_valid_json]
      end
      @errors = errors
      errors.size > 0 ? false : true
    end

  end
end
