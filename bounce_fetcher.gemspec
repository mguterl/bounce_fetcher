# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bounce_fetcher/version"

Gem::Specification.new do |s|
  s.name        = "bounce_fetcher"
  s.version     = BounceFetcher::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TODO: Write your email address"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "bounce_fetcher"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'tmail'
  s.add_dependency 'bounce-email', '0.0.1'
end
