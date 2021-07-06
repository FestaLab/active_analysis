# frozen_string_literal: true

require "active_storage"

require "marcel"
require "image_processing"
require "ruby-vips"
require "mini_magick"

require_relative "analyzer"
require_relative "analyzer/image_analyzer"
require_relative "analyzer/image_analyzer/vips"
require_relative "analyzer/image_analyzer/image_magick"
require_relative "analyzer/audio_analyzer"
require_relative "analyzer/video_analyzer"
require_relative "analyzer/pdf_analyzer"

require_relative "addon"
require_relative "addon/image_addon"
require_relative "addon/image_addon/white_background"

module ActiveAnalysis
  class Engine < ::Rails::Engine
    isolate_namespace ActiveAnalysis

    config.active_analysis = ActiveSupport::OrderedOptions.new
    config.active_analysis.addons = []

    config.eager_load_namespaces << ActiveAnalysis

    initializer "active_analysis.configs" do
      config.after_initialize do |app|
        ActiveAnalysis.logger         = app.config.active_analysis.logger         || Rails.logger

        ActiveAnalysis.image_library  = app.config.active_analysis.image_library  || app.config.active_storage.variant_processor || :mini_magick
        ActiveAnalysis.image_analyzer = app.config.active_analysis.image_analyzer || true
        ActiveAnalysis.audio_analyzer = app.config.active_analysis.audio_analyzer || true
        ActiveAnalysis.pdf_analyzer   = app.config.active_analysis.pdf_analyzer   || true
        ActiveAnalysis.video_analyzer = app.config.active_analysis.video_analyzer || true
        ActiveAnalysis.addons         = app.config.active_analysis.addons         || []
      end
    end

    initializer "active_analysis.analyzers" do
      config.after_initialize do |app|
        if ActiveAnalysis.image_analyzer
          app.config.active_storage.analyzers.delete ActiveStorage::Analyzer::ImageAnalyzer
          app.config.active_storage.analyzers.delete ActiveStorage::Analyzer::ImageAnalyzer::Vips if defined?(ActiveStorage::Analyzer::ImageAnalyzer::Vips)
          app.config.active_storage.analyzers.delete ActiveStorage::Analyzer::ImageAnalyzer::ImageMagick if defined?(ActiveStorage::Analyzer::ImageAnalyzer::ImageMagick)

          app.config.active_storage.analyzers.append Analyzer::ImageAnalyzer::Vips
          app.config.active_storage.analyzers.append Analyzer::ImageAnalyzer::ImageMagick
        end

        if ActiveAnalysis.video_analyzer
          app.config.active_storage.analyzers.delete ActiveStorage::Analyzer::VideoAnalyzer
          app.config.active_storage.analyzers.append Analyzer::VideoAnalyzer
        end

        if ActiveAnalysis.audio_analyzer
          app.config.active_storage.analyzers.delete ActiveStorage::Analyzer::AudioAnalyzer if defined?(ActiveStorage::Analyzer::AudioAnalyzer)
          app.config.active_storage.analyzers.append Analyzer::AudioAnalyzer
        end

        if ActiveAnalysis.pdf_analyzer
          app.config.active_storage.analyzers.append Analyzer::PDFAnalyzer
        end
      end
    end
  end
end
