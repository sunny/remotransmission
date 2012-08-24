require "./lib/remotransmission/version"

Gem::Specification.new do |s|
  s.name        = 'remotransmission'
  s.version     = RemoTransmission::Version::STRING
  s.date        = '2012-08-24'
  s.summary     = "Remote Transmission"
  s.description = "A gem that can talk to remote Transmission demons"
  s.authors     = ["Sunny Ripert"]
  s.email       = 'sunny@sunfox.org'
  s.files       << "lib/remotransmission.rb"
  s.files       << "lib/remotransmission/client.rb"
  s.files       << "lib/remotransmission/version.rb"
  s.executables << 'remotransmission'
  s.homepage    = 'http://github.com/sunny/remotransmission'
  s.license     = 'MIT'
  s.add_runtime_dependency "choice", "~> 0.1"
  s.add_runtime_dependency "json", "~> 1.7"
  s.requirements << "Curl command line"
end
