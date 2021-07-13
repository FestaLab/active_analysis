# frozen_string_literal: true

require "test_helper"

module ActiveAnalysis
  class Addon::ImageAddon::WhiteBackgroundTest < ActiveSupport::TestCase
    test "that white background is detected with vips" do
      with_white_background_addon(:vips) do
        blob = create_file_blob(filename: "opaque.png", content_type: "image/png")
        metadata = extract_metadata_from(blob)
        assert metadata[:white_background]

        blob = create_file_blob(filename: "racecar.jpg", content_type: "image/jpg")
        metadata = extract_metadata_from(blob)
        assert_not metadata[:white_background]
      end
    end

    test "that white background is detected with image_magick" do
      with_white_background_addon(:mini_magick) do
        blob = create_file_blob(filename: "opaque.png", content_type: "image/png")
        metadata = extract_metadata_from(blob)
        assert metadata[:white_background]

        blob = create_file_blob(filename: "racecar.jpg", content_type: "image/jpg")
        metadata = extract_metadata_from(blob)
        assert_not metadata[:white_background]
      end
    end

    private
      def with_white_background_addon(library)
        previous_addons, ActiveAnalysis.addons = ActiveAnalysis.addons, [Addon::ImageAddon::WhiteBackground]
        previous_library, ActiveAnalysis.image_library = ActiveAnalysis.image_library, library
        yield
      ensure
        ActiveAnalysis.addons = previous_addons
        ActiveAnalysis.image_library = previous_library
      end
  end
end
