$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..", "lib")))
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..", "test")))
require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
  coverage_dir "/test/coverage"
end
require 'test/unit'
require 'test/unit/autorunner'
require 'test/unit/coverage'
require 'ark'
require 'tc_repo'
require 'tc_schema'
require 'tc_schema_validations'
require 'tc_schema_repo'