# Ark

Ark is a breakout of the ideas around the persistence mechanism for [Noah](https://github.com/lusis/noah).
You can read some of the discussions around these ideas here:

- [Noah Wiki Entry - Jordan's Ideas](https://github.com/lusis/Noah/wiki/Noah-Features-in-General-(scratchpad\))
- [Noah Wiki Entry - My Ideas](https://github.com/lusis/Noah/wiki/Possible-changes-in-Noah)
- [Gist with more Ideas](https://gist.github.com/1358889)

I am VERY thankful for the work done by @mattsears on [Gaga](https://github.com/mattsears/gaga).
I've wanted to do something Git-backed for a while but Gaga prompted me to consider it again. Noah, however, has some different requirements so I've hijacked his original code to roll Ark.

## Schemas
Unlike most key/value systems, objects in Ark are defined with a schema. This fits better into Noah.

Schemas are defined in the following format:

```json
{"id":"<String>",
  "key":"<optional String>"
  "attributes":"<Array>",
  "validations":{
    "required":"<optional Array>",
    "unique":"<optional Array>",
    "member":{
      "<attribute>":"<Array>"
    }
  }
}
```

The only requirements are that your schema must define

- an `id`
- either an attribute called `name` or a `key`

This would look like

```json
{"id":"host","key":"name"}
```
OR
```json
{"id":"host","attributes":["name"]}
```

Everything else is optional. The `name` attribute, should it exist, will automatically become the unique identifier for records using the schema. You can override this with the `key` attribute.

### Validations
Validations are, again, optional but should you choose to use them there are further requirements.

- Any validation must contain a valid attribute
- Attribute for validation must be an array (excluding `member` which is a valid attribute and array)

Using our previous example, if you wanted to ensure that every `host` had a status:

```json
{"id":"host",
  "attributes":["name", "status"],
  "validations":{
    "required":["name","status"],
    "unique":["name"]
  }
}
```
If you wanted to ensure that every host had a `status` and that it was one of `up`,`down` or `pending` you would also add a `member` validation:

```json
{"id":"host",
  "attributes":["name", "status"],
  "validations":{
    "required":["name","status"],
    "unique":["name"],
    "member":{
      "status":["up","down","pending"]
    }
  }
}
```

## Git layout
The actual on-disk persistence is handled as a bare Git repo via Grit. It contains the following structure:

```
<root>
     _schema
     _objects
```

Each schema is stored as a JSON file (`<id>.json`) in the `_schema` directory.
Each object created with a given schema is stored as a JSON file (`<key>.json`) in the `_objects` directory.

The reason for storing as a bare repo is to eliminate the temptation and confusion around it being a working repo. You could check out the repo elsewhere and make changes but this currently would bypass all validation (of both schemas and created objects).

## Object creation
Initial experiments around this idea were done in my person experiments repo. The general flow would work something like this:

- Schemas are loaded from disk
- Classes are dynamically created from schemas
- Classes subclass a base class that defines validation and persistence
- Classes gain various git-friendly abilities (versioning, checksum and the like)

So if you use our `host` example from above, you would get a new class called `Host` to work with.

# TODO
I've still got more code to move over from my experiments. I'm trying to keep the Noah-specific stuff OUT of this code base. For instance, the sinatra application in the experiments won't be a part of this.

Other things:

- Expose symlinks (while this is for Noah, it's still appropriate here)
- Modify `Ark::Repo` to take the schema name on operations.
- Flesh out pre/post CRUD hooks. (Either use git hooks or my own similar to ohm-contrib)
- Figure out where cluster consistency fits. (Noah is the user but it's probably a separate repo - ark-cluster maybe?)

# Contributions
I welcome any and all contributions. Wiki entries, bug reports, code...it's all valuable.
