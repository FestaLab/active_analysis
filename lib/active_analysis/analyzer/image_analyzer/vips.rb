# frozen_string_literal: true

require_relative "../image_analyzer"

module ActiveAnalysis
  # This analyzer relies on the third-party {ruby-vips}[https://github.com/libvips/ruby-vips] gem. Ruby-vips requires
  # the {libvips}[https://libvips.github.io/libvips/] system library.
  class Analyzer::ImageAnalyzer::Vips < Analyzer::ImageAnalyzer
    def self.accept?(blob)
      super && ActiveAnalysis.image_library == :vips
    end

    private
      def read_image
        download_blob_to_tempfile do |file|
          require "ruby-vips"
          image = ::Vips::Image.new_from_file(file.path)

          if valid_image?(image)
            yield image
          else
            logger.info "Skipping image analysis because Vips doesn't support the file"
            {}
          end
        end
      rescue LoadError
        logger.info "Skipping image analysis because the ruby-vips gem isn't installed"
        {}
      rescue ::Vips::Error => error
        logger.error "Skipping image analysis due to an Vips error: #{error.message}"
        {}
      end

      ROTATIONS = /Right-top|Left-bottom|Top-right|Bottom-left/

      def rotated_image?(image)
        ROTATIONS === image.get("exif-ifd0-Orientation")
      rescue ::Vips::Error
        false
      end

      def opaque?(image)
        return true unless image.has_alpha?
        image[image.bands - 1].min == 255
      rescue ::Vips::Error
        false
      end

      def valid_image?(image)
        image.avg
        true
      rescue ::Vips::Error
        false
      end
  end
end
