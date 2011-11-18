$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..", "lib")))
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..", "test")))
require 'simplecov'
SimpleCov.start
require 'test/unit'
require 'test/unit/autorunner'
require 'test/unit/coverage'
require 'test/unit/color'
require 'ark'

require 'tc_repo'
require 'tc_schema'
require 'tc_schema_validations'

