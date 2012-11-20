# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mystro/common/version'

Gem::Specification.new do |gem|
  gem.name          = "mystro-common"
  gem.version       = Mystro::Common::Version::STRING
  gem.authors       = ["Shawn Catanzarite"]
  gem.email         = ["me@shawncatz.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "fog"                # talk to cloud
  gem.add_dependency "yell", "~> 1.2.0"   # logging
  gem.add_dependency "hashie"             # better data objects
  gem.add_dependency "activesupport"      # active support
  gem.add_dependency "ipaddress"          # ip address library
end
