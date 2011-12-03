module Ark::Validations::Schema

  private
  def required_keys
    ["id", "attributes"]
  end

  def optional_keys
    ["validations", "key"]
  end

  def validation_keys
    ["required", "unique", "member"]
  end

  def validate_schema(schema_def=self.definition)
    errors = []
    begin
      schema = ::JSON.parse(schema_def)
      @parsed_schema = schema

      keys = schema.keys
      schema_id = schema['id']
      attributes = schema['attributes']
      validations = schema['validations']
      key = schema['key']

      required_keys.each do |key|
        errors << [:schema, "missing_required_key_#{key}".to_sym] unless keys.member?(key)
      end

      errors << [:id, :not_string] if schema_id.class != String

      errors << [:primary_key, :not_defined] if key.nil? && attributes.member?('name').nil?

      unless validations.nil?
        validations.each do |type, values|
          errors << [type.to_sym, :unknown_validation_type] unless validation_keys.member?(type)
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
    rescue TypeError
      errors << [:schema, :not_valid_json]
    end
    @errors = errors
    errors.size > 0 ? false : true
  end

end
