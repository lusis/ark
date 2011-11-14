require 'json'
require 'ark'
require 'ark/schema'
@j =<<EOF
{"id":"host",
  "attributes":["name","status"],
  "validations":{
    "required":["name"],
    "unique":["name"],
    "member":{
      "status":["up","down","pending"]
    }
  }
}
EOF
