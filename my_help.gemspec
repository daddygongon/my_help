# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','my_help','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'my_help'
  s.version = MyHelp::VERSION
  s.author = 'Shigeot R. Nishitani'
  s.email = ''
  s.homepage = 'https://github.com/daddygongon/my_help'
  s.platform = Gem::Platform::RUBY
  s.license       = "MIT"
  s.summary       = %q{user building help}
  s.description   = %q{user building help}
  s.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  s.require_paths = ["lib"]
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('yard')
  s.add_runtime_dependency('thor')
  s.add_runtime_dependency "colorize"
  s.add_runtime_dependency "command_line"
end
