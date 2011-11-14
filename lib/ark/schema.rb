module Ark
  class Schema
    REQUIRED_KEYS = ["id","attributes"]
    OPTIONAL_KEYS = ["validations", "key"]
    VALIDATIONS = ["required", "unique", "member"]

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
    attr_accessor :definition, :errors

    def initialize(schema)
      @definition = schema
    end

    def save
      self.valid?
    end

    def self.add(definition)
      parsed_schema = validate_schema(definition)
    end

    def valid?
      validate_schema
    end

    private
    def validate_schema
      errors = []
      begin
        # Is it valid JSON?
        schema = ::JSON.parse(self.definition)

        # Some shortcuts
        keys = schema.keys
        schema_id = schema['id']
        attributes = schema['attributes']
        validations = schema['validations']
        key = schema['key'] || schema['attributes']['name']

        # Are all the required keys there?
        errors << [:schema, :missing_required_keys] if keys.sort != REQUIRED_KEYS.sort

        # Is id a string?
        errors << [:id, :not_string] if schema_id.class != String

        # Do we have a key?
        errors << [:primary_key, :not_defined] if key.nil?

        # If we have validations
        # Are they ones we understand?
        unless validations.nil?
          validations.each do |validation, attrs|
            # Match against known validation types
            errors << [validation.to_sym, :unknown_validation_type] unless VALIDATIONS.member?(validation)
            if validation == "member"
              attrs.each do |attr, opt|
                if opt.class != Array
                  errors << [attr.to_sym, :member_must_be_array]
                else
                  errors << [attr.to_sym, :unknown_attribute_in_validation] unless attributes.member?(attr)
                end
              end
            else
              if attrs.class != Array
                errors << [attr.to_sym, "#{validation}_must_be_array".to_sym]
              else
                errors << [attr.to_sym, :unknown_attribute_in_validation] unless attributes.member?(attr)
              end
            end
          end
        end
      rescue JSON::ParserError
        @errors = [:schema, :not_valid_json]
      end
      @errors << errors
    end

  end
end
