$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..", "lib")))
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..", "test")))
require 'test/unit'
require 'ark'

require 'tc_schema'
require 'tc_schema_validations'
