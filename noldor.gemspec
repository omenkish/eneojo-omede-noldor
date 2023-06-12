# frozen_string_literal: true

require_relative 'lib/noldor/version'

Gem::Specification.new do |spec|
  spec.name = 'noldor'
  spec.version = Noldor::VERSION
  spec.authors = ['Eneojo Omede']
  spec.email = ['omenkish@gmail.com']

  spec.summary = 'Easily get The Lord of the Rings movies, quotes and characters.'
  spec.description = <<-DESCRIPTION
    Noldor (also spelled Ñoldor, meaning those with knowledge in the constructed language Quenya) are a kindred of Elves who migrate west to the blessed realm of Valinor from the continent of Middle-earth,
    splitting from other groups of Elves as they went. The Noldor gem provides a set of utilities to easily access The Lord of the Rings movies, quotes and characters.
  DESCRIPTION
  spec.homepage = 'https://github.com/omenkish/noldor'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.2'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  ignored = Regexp.union(
    "noldor-0.1.1.gem",
    /\A\.git/,
    /\A\.vscode/,
    /\Aspec/
  )
  spec.files = `git ls-files`.split("\n").reject { |f| ignored.match(f) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency 'example-gem', '~> 1.0'

  spec.add_runtime_dependency "faraday", "~> 0.14"
  spec.add_runtime_dependency "faraday_middleware", "~> 0.12"
  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
