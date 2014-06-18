# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'world_cup/version'

Gem::Specification.new do |spec|
  spec.name          = "worldcup"
  spec.version       = WorldCup::VERSION
  spec.authors       = ["Henry Poydar"]
  spec.email         = ["hpoydar@gmail.com"]
  spec.summary       = %q{Provides command line access to World Cup 2014 information and results.}
  spec.homepage      = "https://github.com/hpoydar/worldcup"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "terminal-table", "~> 1.4.5"
  spec.add_runtime_dependency 'colorize', '~> 0.7.3'
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency 'timecop', '~> 0.7.1'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
