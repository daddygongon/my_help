# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','my_help','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'my_help'
  s.version = MyHelp::VERSION
  s.author = 'Shigeot R. Nishitani'
  s.email = ''
  s.homepage = ''
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','my_help.rdoc']
  s.rdoc_options << '--title' << 'my_help' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'my_help'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_development_dependency('rspec')
  s.add_runtime_dependency('gli','2.17.1')
  s.add_runtime_dependency "colorize"

  s.add_runtime_dependency 'thor'
end
