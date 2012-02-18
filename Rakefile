$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'padrino-csrf/version'

require 'rake'
require 'yard'
require 'rspec'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |task|
  task.pattern = 'spec/**/*_spec.rb'
end

YARD::Rake::YardocTask.new

task :build do
  `gem build padrino-csrf.gemspec`
end

task :install => :build do
  `gem install padrino-csrf-#{Padrino::CSRF::VERSION}.gem`
end

desc 'Releases the current version into the wild'
task :release => :build do
  `git tag -a v#{Padrino::CSRF::VERSION} -m "Version #{Padrino::CSRF::VERSION}"`
  `gem push padrino-csrf-#{Padrino::CSRF::VERSION}.gem`
  `git push --tags`
end

task :default => :spec