# frozen_string_literal: true

require_relative "lib/my_help/version"

Gem::Specification.new do |spec|
  spec.name = "my_help"
  spec.version = MyHelp::VERSION
  spec.authors = ["Shigeto R. Nishiani"]
  spec.email = ["daddygongon@users.noreply.github.com"]
  spec.license       = "MIT"
  spec.summary       = %q{user building help}
  spec.description   = %q{user building help}
  spec.homepage      = 'https://github.com/daddygongon/my_help'
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{\A(?:test|spec|features)/}) || f.include?("Zone.Identifier")
    end
  end
  spec.files << 'lib/my_help/translate.rb' unless spec.files.include?('lib/my_help/translate.rb')
  spec.files << 'lib/my_help/count.rb' unless spec.files.include?('lib/my_help/count.rb')
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "thor"
  spec.add_runtime_dependency "command_line"
  spec.add_runtime_dependency "colorize"
#  spec.add_development_dependency "aruba"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "rubocop"
  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
