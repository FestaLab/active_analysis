require "test_helper"

module ActiveAnalysis
  class Addon::ImageAddon::OptimalQualityTest < ActiveSupport::TestCase
    test "that it detects the optimal quality for the image" do
      with_optimal_image_addon do
        blob = create_file_blob(filename: "racecar.jpg", content_type: "image/jpeg")
        metadata = extract_metadata_from(blob)

        assert_equal 70, metadata[:optimal_quality]
      end
    end

    private
      def with_optimal_image_addon
        previous_addons, ActiveAnalysis.addons = ActiveAnalysis.addons, [Addon::ImageAddon::OptimalQuality]
        yield
      ensure
        ActiveAnalysis.addons = previous_addons
      end
  end
end
