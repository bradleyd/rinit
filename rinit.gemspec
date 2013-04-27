# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rinit/version'

Gem::Specification.new do |spec|
  spec.name          = "rinit"
  spec.version       = Rinit::VERSION
  spec.authors       = ["Bradley Smith"]
  spec.email         = ["bradleydsmith@gmail.com"]
  spec.description   = %q{ Provides init-like script structure for ruby}
  spec.summary       = %q{ Provides init-like script structure for ruby so you can control your daemons. }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sys-proctable"
  spec.add_dependency "open4"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "minitest"
end
