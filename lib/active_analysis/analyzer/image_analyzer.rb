# frozen_string_literal: true

require_relative "../analyzer"

module ActiveAnalysis
  # This is an abstract base class for image analyzers, which extract width and height from an image blob.
  #
  # If the image contains EXIF data indicating its angle is 90 or 270 degrees, its width and height are swapped for convenience.
  #
  # Example:
  #
  #   ActiveAnalysis::Analyzer::ImageAnalyzer::ImageMagick.new(blob).metadata
  #   # => { width: 4104, height: 2736 }
  class Analyzer::ImageAnalyzer < Analyzer
    def self.accept?(blob)
      blob.image?
    end

    def metadata
      read_image do |image|
        if rotated_image?(image)
          { width: image.height, height: image.width, opaque: opaque?(image) }
        else
          { width: image.width, height: image.height, opaque: opaque?(image) }
        end
      end
    end

    private
      def read_image
        raise NotImplementedError
      end

      def rotated_image?(image)
        raise NotImplementedError
      end

      def opaque?(image)
        raise NotImplementedError
      end
  end
end

