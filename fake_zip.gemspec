# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fake_zip/version'

Gem::Specification.new do |spec|
  spec.name          = "fake_zip"
  spec.version       = FakeZip::VERSION
  spec.authors       = ["Alexander K"]
  spec.email         = ["xpyro@ya.ru"]
  spec.description   = %q{ build zip files with given file structure for testing }.strip
  spec.summary       = %q{ build zip files with given file structure for testing }.strip
  spec.homepage      = "https://github.com/sowcow/fake_zip"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  # deps:
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "rubyzip"  
end
