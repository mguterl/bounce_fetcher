# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bounce_fetcher/version"

Gem::Specification.new do |s|
  s.name        = "bounce_fetcher"
  s.version     = BounceFetcher::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michael Guterl"]
  s.email       = ["michael@diminishing.org"]
  s.homepage    = "http://github.com/mguterl/bounce_fetcher"
  s.summary     = %q{A set of tools for processing email bounces in a flexible way.}
  s.description = %q{A set of tools for processing email bounces in a flexible way.}

  s.rubyforge_project = "bounce_fetcher"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'tmail', '~> 1.2'
  s.add_dependency 'bounce-email', '~> 0.0.1'
end
