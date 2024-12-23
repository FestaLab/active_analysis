# coding: utf-8
# frozen_string_literal: true

require_relative "lib/active_analysis/version"

Gem::Specification.new do |spec|
  spec.name          = "active_analysis"
  spec.version       = ActiveAnalysis::VERSION::STRING
  spec.authors       = ["Breno Gazzola"]
  spec.email         = ["breno@festalab.com"]

  spec.summary       = "Collection of Active Storage analyzers"
  spec.homepage      = "https://github.com/FestaLab/active_analysis"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/FestaLab/active_analysis"
  spec.metadata["changelog_uri"]   = "https://github.com/FestaLab/active_analysis/CHANGELOG.mg"

  spec.files         = Dir["{app,config,db,lib}/**/*", "Rakefile", "MIT-LICENSE", "README.md", "CHANGELOG.md"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.add_dependency "activestorage",    ">= 7.0"
  spec.add_dependency "activesupport",    ">= 7.0"
  spec.add_dependency "image_processing", ">= 1.2"

  spec.add_development_dependency "sqlite3",             "~> 2.4"
  spec.add_development_dependency "byebug",              "~> 11.1"
  spec.add_development_dependency "rubocop",             "~> 1.14"
  spec.add_development_dependency "rubocop-performance", "~> 1.11"
  spec.add_development_dependency "rubocop-packaging",   "~> 0.5"
  spec.add_development_dependency "rubocop-rails",       "~> 2.10"
end
