require "test_helper"

module ActiveAnalysis
  class Addon::ImageAddon::WhiteBackgroundTest < ActiveSupport::TestCase
    test "that white background is detected" do
      with_white_background_addon do
        blob = create_file_blob(filename: "opaque.png", content_type: "image/png")
        metadata = extract_metadata_from(blob)
        assert metadata[:white_background]

        blob = create_file_blob(filename: "racecar.jpg", content_type: "image/jpg")
        metadata = extract_metadata_from(blob)
        assert_not metadata[:white_background]
      end
    end

    private
      def with_white_background_addon
        previous_addons, ActiveAnalysis.addons = ActiveAnalysis.addons, [Addon::ImageAddon::WhiteBackground]
        yield
      ensure
        ActiveAnalysis.addons = previous_addons
      end
  end
end
