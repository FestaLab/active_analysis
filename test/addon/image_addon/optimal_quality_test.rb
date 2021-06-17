require "test_helper"

module ActiveAnalysis
  class Addon::ImageAddon::OptimalQualityTest < ActiveSupport::TestCase
    setup do
      ActiveAnalysis.addons = [Addon::ImageAddon::OptimalQuality]
    end

    test "that it detects the optimal quality for the image" do
      blob = create_file_blob(filename: "racecar.jpg", content_type: "image/jpeg")
      metadata = extract_metadata_from(blob)

      assert_equal 70, metadata[:optimal_quality]
    end
  end
end
