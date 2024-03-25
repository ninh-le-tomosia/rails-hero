# frozen_string_literal: true

require_relative "lib/rails_hero/version"

Gem::Specification.new do |spec|
  spec.name = "rails_hero"
  spec.version = RailsHero::VERSION
  spec.authors = ["Ninh Tomosia"]
  spec.email = ["ninh.le@tomosia.com"]
  spec.homepage              = 'https://github.com/ninh-le-tomosia/rails-hero'
  spec.summary               = 'Init project with auto config'
  spec.license               = 'MIT'
  spec.files                 = Dir['lib/**/*', 'README.md']
  spec.executables           = %w[rhero]
  spec.required_ruby_version = '>= 2.5.0'
  spec.metadata = {
    'bug_tracker_uri' => "#{spec.homepage}/issues",
    'documentation_uri' => spec.homepage,
    'source_code_uri' => spec.homepage,
    'rubygems_mfa_required' => 'true'
  }

  spec.add_dependency 'thor', '~> 1.2.0'
  spec.add_dependency 'tty-prompt', '~> 0.23.0'
end
