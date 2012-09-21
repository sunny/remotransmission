# encoding: utf-8

require './lib/remotransmission/version'

Gem::Specification.new do |gem|
  gem.name        = 'remotransmission'
  gem.version     = RemoTransmission::VERSION

  gem.authors     = ['Sunny Ripert']
  gem.email       = ['sunny@sunfox.org']
  gem.summary     = "Remote Transmission"
  gem.description = "A gem that can talk to remote Transmission demons"
  gem.homepage    = 'http://github.com/sunny/remotransmission'
  gem.license     = 'MIT'

  gem.files       = `git ls-files`.split("\n")
  gem.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  gem.add_runtime_dependency "choice", "~> 0.1"
  gem.add_runtime_dependency "json", "~> 1.7"

  gem.add_development_dependency "rake"
end
