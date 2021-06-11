# frozen_string_literal: true

require "active_storage"

require "marcel"
require "ruby-vips"
require "mini_magick"

module ActiveAnalysis
  class Engine < ::Rails::Engine
    isolate_namespace ActiveAnalysis

    config.active_analysis                             = ActiveSupport::OrderedOptions.new
    config.active_analysis.analyzers                   = [ActiveAnalysis::Analyzer::Url]

    config.eager_load_namespaces << ActiveAnalysis

    initializer "active_analysis.configs" do
      config.after_initialize do |app|
        ActiveAnalysis.logger                          = app.config.active_analysis.logger || Rails.logger
        ActiveAnalysis.analyzers                       = app.config.active_analysis.analyzers || []
        ActiveAnalysis.image_library                   = app.config.active_analysis.image_library || app.config.active_storage.variant_processor
      end
    end

    initializer "active_analysis.core_extensions" do
      require_relative "core_extensions/active_storage/image_analyzer"

      config.after_initialize do |app|
        app.config.active_storage.analyzers.delete ActiveStorage::Analyzer::ImageAnalyzer
        app.config.active_storage.analyzers.prepend CoreExtensions::ActiveStorage::ImageAnalyzer
      end
    end
  end
end
