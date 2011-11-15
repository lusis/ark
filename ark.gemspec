# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ark/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["John E. Vincent"]
  gem.email         = ["lusis.org+github.com@gmail.com"]
  gem.description   = %q{Special purpose data store built on Git}
  gem.summary       = ""
  gem.homepage      = "https://github.com/lusis/ark"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "ark"
  gem.require_paths = ["lib"]
  gem.version       = Ark::VERSION
  gem.add_dependency("grit", "= 2.4.1")
  gem.add_dependency("slop", "= 2.3.1")
end
