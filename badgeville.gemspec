# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "badgeville_berlin/version"

Gem::Specification.new do |s|
  s.name        = "badgeville_berlin_opower"
  s.version     = BadgevilleBerlin::VERSION
  s.authors     = ["Justin Spradlin"]
  s.email       = ["justin@opower.com"]
  s.homepage    = "https://github.com/jspradlin/badgeville-ruby-opower"
  s.summary     = %q{A Ruby wrapper for the Badgeville RESTful Berlin API.  Forked from the original Badgeville Gem}
  s.description = %q{This is an open source Ruby wrapper for interacting with the Badgeville RESTful Berlin API.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here

  # development-only dependencies
  s.add_development_dependency "ruby-debug19"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "fakeweb"
  s.add_development_dependency "factory_girl", '=2.4.0'
  s.add_development_dependency "ZenTest"
  s.add_development_dependency "autotest"
  s.add_development_dependency "autotest-growl"
  s.add_development_dependency "logger", ">=1.2.8"

  s.add_runtime_dependency "activeresource", '>= 3.1.3'
  # s.add_runtime_dependency "rest-client"
end
