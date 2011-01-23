# -*- encoding: utf-8 -*-
require File.expand_path("../lib/dynamic_methods/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "dynamic_methods"
  s.version     = DynamicMethods::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Marian Theisen"]
  s.email       = ["marian@cice-online.net"]
  s.homepage    = "http://rubygems.org/gems/dynamic_methods"
  s.summary     = "dynamics_methods is a simple gem to easily define ... dynamic methods"
  s.description = "dynamics_methods is a simple gem to easily define ... dynamic methods"

  s.required_rubygems_version = ">= 1.3.6"
  # s.rubyforge_project         = "dynamic_methods"

  s.add_dependency 'activesupport', ">= 3.0.0"
  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
