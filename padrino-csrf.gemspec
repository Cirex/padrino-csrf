# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'padrino-csrf/version'

Gem::Specification.new do |s|
  s.name        = 'padrino-csrf'
  s.version     = Padrino::CSRF::VERSION
  s.authors     = ['Benjamin Bloch']
  s.email       = ['cirex@gamesol.org']
  s.homepage    = 'https://github.com/Cirex/padrino-csrf'
  s.description = 'A plugin for the Padrino web framework which adds CSRF protection'
  s.summary     = s.description

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'padrino-core'
  s.add_dependency 'padrino-helpers'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'webrat'
end