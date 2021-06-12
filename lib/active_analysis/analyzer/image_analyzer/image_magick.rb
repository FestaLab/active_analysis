# frozen_string_literal: true

require_relative "../image_analyzer"

module ActiveAnalysis
  # This analyzer relies on the third-party {MiniMagick}[https://github.com/minimagick/minimagick] gem. MiniMagick requires
  # the {ImageMagick}[http://www.imagemagick.org] system library.
  class Analyzer::ImageAnalyzer::ImageMagick < Analyzer::ImageAnalyzer
    def self.accept?(blob)
      super && ActiveAnalysis.image_library == :mini_magick
    end

    private
      def read_image
        download_blob_to_tempfile do |file|
          require "mini_magick"
          image = MiniMagick::Image.new(file.path)

          if image.valid?
            yield image
          else
            logger.info "Skipping image analysis because ImageMagick doesn't support the file"
            {}
          end
        end
      rescue LoadError
        logger.info "Skipping image analysis because the mini_magick gem isn't installed"
        {}
      rescue MiniMagick::Error => error
        logger.error "Skipping image analysis due to an ImageMagick error: #{error.message}"
        {}
      end

      def rotated_image?(image)
        %w[ RightTop LeftBottom TopRight BottomLeft ].include?(image["%[orientation]"])
      end

      def opaque?(image)
        return true unless image.data["channelDepth"].key?("alpha")
        image.data["channelStatistics"]["alpha"]["min"] == 255
      end
  end
end

