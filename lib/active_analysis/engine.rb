# frozen_string_literal: true

require "active_storage"

require "marcel"
require "ruby-vips"
require "mini_magick"

require_relative "analyzer"
require_relative "analyzer/image_analyzer"
require_relative "analyzer/image_analyzer/vips"
require_relative "analyzer/image_analyzer/image_magick"
require_relative "analyzer/audio_analyzer"
require_relative "analyzer/video_analyzer"
require_relative "analyzer/pdf_analyzer"

module ActiveAnalysis
  class Engine < ::Rails::Engine
    isolate_namespace ActiveAnalysis

    config.active_analysis                             = ActiveSupport::OrderedOptions.new
    config.eager_load_namespaces << ActiveAnalysis

    initializer "active_analysis.configs" do
      config.after_initialize do |app|
        ActiveAnalysis.logger                          = app.config.active_analysis.logger || Rails.logger
        ActiveAnalysis.analyzers                       = app.config.active_analysis.analyzers || []
        ActiveAnalysis.image_library                   = app.config.active_analysis.image_library || app.config.active_storage.variant_processor
      end
    end

    initializer "active_analysis.core_extensions" do
      config.after_initialize do |app|
        app.config.active_storage.analyzers.delete ActiveStorage::Analyzer::ImageAnalyzer
        app.config.active_storage.analyzers.delete ActiveStorage::Analyzer::VideoAnalyzer

        app.config.active_storage.analyzers.append Analyzer::ImageAnalyzer::Vips
        app.config.active_storage.analyzers.append Analyzer::ImageAnalyzer::ImageMagick
        app.config.active_storage.analyzers.append Analyzer::VideoAnalyzer
        app.config.active_storage.analyzers.append Analyzer::AudioAnalyzer
        app.config.active_storage.analyzers.append Analyzer::PDFAnalyzer
      end
    end
  end
end
