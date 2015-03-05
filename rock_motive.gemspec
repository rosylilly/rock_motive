$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'rock_motive/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'rock_motive'
  s.version     = RockMotive::VERSION
  s.authors     = ['Sho Kusano']
  s.email       = ['rosylilly@aduca.org']
  s.homepage    = 'https://github.com/rosylilly/rock_motive'
  s.summary     = 'RockMotive provides DCI architecture to Rails'
  s.description = s.summary
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'activesupport', '>= 4.0.0'
  s.add_dependency 'uninclude'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'minitest-power_assert'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'ruby-prof'
  s.add_development_dependency 'benchmark-ips'
end
