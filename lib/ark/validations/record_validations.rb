module Ark::Validations::Record

  # TODO: make private
  #       break each validation out (i.e. validate_required)
  def validate_record(record=nil, schema_def=nil)
    schema_def ||= self.schema.parsed_schema
    record ||= self
    errors = []
    # Sample schema def
    # {
    #  "id":"host",
    #  "attributes":["name","status"],
    #  "validations":{
    #    "required":["name"],
    #    "unique":["name"],
    #    "member":{
    #     "status":["up","down","pending"]
    #     }
    #   }
    # }
    # check that all required attributes are defined
    keys = schema_def.keys
    attrs = schema_def['attributes']
    validations = schema_def['validations']
    key = schema_def['key']

    unless validations.nil?
      required_keys = validations['required']
      unique_keys = validations['unique']
      member_keys = validations['member']
    end

    # Do we have our required keys
    unless required_keys.nil?
      required_keys.each do |rk|
        v = self.instance_variable_get "@#{rk}"
        errors << [rk.to_sym, :is_required] if v.nil?
      end
    end

    unless unique_keys.nil?
      unique_keys.each do |uk|
        v = self.instance_variable_get "@#{uk}"
        if v.nil?
          errors << [uk.to_sym, :unique_key_cannot_be_nil]
        else
          check = Ark::Record.find(self.record_type, uk)
          errors << [uk.to_sym, :not_unique] unless check.nil?
        end
      end
    end

    unless member_keys.nil?
      member_keys.each do |mk, allowed|
        v = self.instance_variable_get "@#{mk}"
        if required_keys.member?(mk)
          errors << [mk.to_sym, :invalid_option] unless allowed.member?(v)
        end
      end
    end
    @errors = errors
    errors.size > 0 ? false : true
  end
end
