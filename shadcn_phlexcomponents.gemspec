# frozen_string_literal: true

require_relative "lib/shadcn_phlexcomponents/version"

Gem::Specification.new do |spec|
  spec.name = "shadcn_phlexcomponents"
  spec.version = ShadcnPhlexcomponents::VERSION
  spec.authors = ["Sean Yeoh"]
  spec.email = ["seanysx@protonmail.com"]

  spec.summary = "TODO: Write a short summary, because RubyGems requires one."
  spec.description = "TODO: Write a longer description or delete this line."
  spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir["{app,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency("railties", "~> 8.0")
end
