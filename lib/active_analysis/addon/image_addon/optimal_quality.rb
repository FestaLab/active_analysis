# frozen_string_literal: true

require_relative "../image_addon"

module ActiveAnalysis
  class Addon::ImageAddon::OptimalQuality < Addon::ImageAddon
    def metadata
      { optimal_quality: calculate_optimal_quality }
    end

    private
      def calculate_optimal_quality
        quality = 85

        loop do
          new_quality = quality - 5
          dssim = calculate_dssim(new_quality)
          break if dssim > 0.001 || quality <= 50
          quality = new_quality
        end

        quality
      rescue
        nil
      end

      def calculate_dssim(quality)
        image_with_quality(quality) do |image|
          dssim = `dssim #{file.path} #{image.path}`
          Float dssim.split.first
        end
      end

      def image_with_quality(quality)
        extname  = File.extname(file.path)
        basename = File.basename(file.path, extname)

        Tempfile.create(["#{basename}_#{quality}", extname]) do |tempfile|
          ::ImageProcessing::MiniMagick.apply(saver: { format: "jpg", quality: quality }).call(file.path, destination: tempfile.path)
          yield tempfile
        end
      end

      def processor
        ActiveAnalysis.image_library == :vips ? ::ImageProcessing::Vips : ::ImageProcessing::MiniMagick
      end
  end
end

