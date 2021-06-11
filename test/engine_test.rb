# frozen_string_literal: true

require "test_helper"

module ActiveAnalysis
  class EngineTest < ActiveSupport::TestCase
    test "that analyzers are loaded" do
      analyzers = Rails.application.config.active_storage.analyzers
      assert_includes analyzers, Analyzer::ImageAnalyzer::Vips
      assert_includes analyzers, Analyzer::ImageAnalyzer::ImageMagick
      assert_includes analyzers, Analyzer::VideoAnalyzer
      assert_includes analyzers, Analyzer::AudioAnalyzer
      assert_includes analyzers, Analyzer::PDFAnalyzer
    end
  end
end
