# API Braindump
Just some random stuff to help me clear my head

## Schema

```ruby
Ark::Schema.add(schema_json)
```

or

```ruby
s = Ark::Schema.new
s.definition = schema_json
s.valid?
s.save # also calls Ark::Schema#valid?
```

## Record

```ruby
class Host; include Ark::Record; end
# works if host is a valid schema
# this also works
class My::Random::Namespace::Host; include Ark::Record; end
```
however you might want to use a class name different from the schema name:

```ruby
class MyHost
  include Ark::Record
  validates_as :host
end
# this should give validate you against the `host` schema
```

I think there's a valid use case for schema+record creation at once like so

```ruby
class Host
  include Ark::Record

  attributes ["name","status"]

  validation :unique, ["name"]
  validation :require, ["name"]
  validation :member, "status", ["up","down","pending"]

end
```

## Repo
I'm not entirely happy with how this is API works but it's fine for now
