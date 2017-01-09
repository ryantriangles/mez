Gem::Specification.new do |s|
  require_relative 'lib/mez/version'
  s.name = 'mez'
  s.version = Mez::VERSION
  s.date = '2017-01-08'
  s.authors = ['Ryan Plant']
  s.email = 'ryan@ryanplant.net'
  s.licenses = ['MIT']
  s.summary = 'A CLI utility to track directory sizes over time'
  s.executables << 'mez'
  s.homepage = 'https://github.com/ryantriangles/mez'
  s.post_install_message = 'Please configure your folders.json!'
  s.add_runtime_dependency 'os', '~> 0.9.6'
  s.add_runtime_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.files = Dir.glob('lib/**/*.rb')
end
