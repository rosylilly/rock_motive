begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'RockMotive'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path('../test/dummy/Rakefile', __FILE__)

load 'rails/tasks/engine.rake'
# load 'rails/tasks/statistics.rake'

Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new

namespace :bench do
  desc 'Run all benchmarks'
  task :all do
    Dir['./benchmarks/*.rb'].each do |file|
      ruby file
    end
  end

  Dir['./benchmarks/*.rb'].each do |bench|
    name = File.basename(bench, '.rb')

    desc "Run #{bench}"
    task name do
      ruby bench
    end
  end
end

task default: %i(rubocop app:db:drop app:db:migrate test)
