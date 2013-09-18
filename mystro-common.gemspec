# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mystro/common/version'

Gem::Specification.new do |gem|
  gem.name          = "mystro-common"
  gem.version       = Mystro::Common::Version::STRING
  gem.authors       = ["Shawn Catanzarite"]
  gem.email         = ["me@shawncatz.com"]
  gem.description   = %q{common functionality for Mystro}
  gem.summary       = %q{common functionality for Mystro}
  gem.homepage      = "http://github.com/mystro"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "fog", "~> 1.12.1"        # talk to cloud
  #gem.add_dependency "aws-sdk", "~> 1.0.0"     # talk to cloud
  gem.add_dependency "yell", "~> 1.2.0"        # logging
  gem.add_dependency "hashie"                  # better data objects
  gem.add_dependency "activesupport", "3.2.14" # active support
  gem.add_dependency "ipaddress"               # ip address library
  gem.add_dependency "erubis"                  # userdata templates
end
