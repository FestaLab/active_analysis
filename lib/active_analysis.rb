require "active_analysis/version"
require "active_analysis/engine"

module ActiveAnalysis
  extend ActiveSupport::Autoload

  autoload :FixtureSet

  mattr_accessor :logger
  mattr_accessor :analyzers
  mattr_accessor :image_library
end
