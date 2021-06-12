require "active_analysis/version"
require "active_analysis/engine"

module ActiveAnalysis
  extend ActiveSupport::Autoload

  autoload :FixtureSet

  mattr_accessor :logger
  mattr_accessor :image_library
  mattr_accessor :image_analyzer
  mattr_accessor :audio_analyzer
  mattr_accessor :pdf_analyzer
  mattr_accessor :video_analyzer
end
