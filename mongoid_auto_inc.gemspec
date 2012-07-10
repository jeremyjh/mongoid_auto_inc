# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mongoid_auto_inc/version"

Gem::Specification.new do |s|
  s.name        = "mongoid_auto_inc"
  s.version     = MongoidAutoInc::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Carsten Block"]
  s.email       = ["info@block-consult.com"]
  s.homepage    = "https://github.com/cblock/mongoid_auto_inc"
  s.summary     = %q{Adds auto increment capabilities to Mongoid::Document}
  s.description = %q{Adds auto increment capabilities to Mongoid::Document}

  #s.rubyforge_project = "mongoid_auto_inc"

  s.add_dependency("moped", ">= 1.0.0.rc")
  s.add_dependency("mongoid", ">= 3.0.0.rc")
  s.add_dependency("activesupport", ">= 3.1")
  s.add_development_dependency("rake", ">= 0.9")
  s.add_development_dependency("rspec", ">= 2.0.0.beta.22")

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 1.8.6'
  s.required_rubygems_version = '>= 1.3.5'
end