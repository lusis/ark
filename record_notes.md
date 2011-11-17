# Current status

- Validation is partially broken right now.
- Need to refactor validation module once I get it fixed
- Consider moving given validation steps to its own method (i.e. `validate_uniques`, `validate_members`)
- Need to handle updates

# record validation flow

- Do all required attributes have a value?
- Are all unique keys actually unique unless we're updating existing
- If a member'd attribute is nil and it's not required, skip the validation
- If a member'd attribute is required, validate it
- If a member'd attribute isn't nil and isn't required, validate it

# schema versioning for records

## New records

- Before saving, get the most recent commit SHA for the schema we're validating against
- Add this as `schema_version` attribute to the record
- run validations
- save

## Existing records

- On load, take the `schema_version` attribute combined with `record_type`
- Pull in the schema at the specified version (commit SHA)
- On save, validate against specified version
- Offer a `#upgrade!` method to the object that revalidates against the new schema



