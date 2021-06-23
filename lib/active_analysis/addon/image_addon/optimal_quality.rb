# frozen_string_literal: true

require_relative "../image_addon"

module ActiveAnalysis
  class Addon::ImageAddon::OptimalQuality < Addon::ImageAddon
    def metadata
      { optimal_quality: calculate_optimal_quality }
    end

    private
      def calculate_optimal_quality
        optimal = 80

        loop do
          candidate = optimal - 5
          dssim = calculate_dssim(candidate)

          dssim >= target_dssim || candidate <= minimum_quality ? break : optimal = candidate
        end

        optimal
      end

      def calculate_dssim(quality)
        image_with_quality(quality) do |image|
          dssim = `dssim #{filepath} #{image.path}`
          Float dssim.split.first
        end
      end

      def image_with_quality(quality)
        extname  = File.extname(filepath)
        basename = File.basename(filepath, extname)

        Tempfile.create(["#{basename}_#{quality}", extname]) do |tempfile|
          processor.apply(saver: { format: "jpg", quality: quality }).call(filepath, destination: tempfile.path)
          yield tempfile
        end
      end

      def filepath
        ActiveAnalysis.image_library == :vips ? file.filename : file.path
      end

      def target_dssim
        0.001
      end

      def minimum_quality
        50
      end

      def processor
        ActiveAnalysis.image_library == :vips ? ::ImageProcessing::Vips : ::ImageProcessing::MiniMagick
      end
  end
end
