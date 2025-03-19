# frozen_string_literal: true

require_relative "lib/shadcn_phlexcomponents/version"

Gem::Specification.new do |spec|
  spec.name = "shadcn_phlexcomponents"
  spec.version = ShadcnPhlexcomponents::VERSION
  spec.authors = ["Sean Yeoh"]
  spec.email = ["sysxdev@protonmail.com"]

  spec.summary = "Shadcn Phlexcomponents is a UI Component library built for Ruby on Rails."
  spec.homepage = "https://github.com/sean-yeoh/shadcn_phlexcomponents"
  spec.required_ruby_version = ">= 3.3.0"

  spec.license = "MIT"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/sean-yeoh/shadcn_phlexcomponents/blob/main/CHANGELOG.md"

  spec.files = Dir["{app,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency("lucide-rails", "~> 0.5.1")
  spec.add_dependency("phlex-rails", "~> 2.1")
  spec.add_dependency("railties", "~> 8.0")
  spec.add_dependency("tailwind_merge", "~> 1.0")
end
