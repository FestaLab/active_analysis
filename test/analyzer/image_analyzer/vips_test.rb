# frozen_string_literal: true

require "test_helper"

module ActiveAnalysis
  class Analyzer::ImageAnalyzer::VipsTest < ActiveSupport::TestCase
    test "analyzing a JPEG image" do
      analyze_with_vips do
        blob = create_file_blob(filename: "racecar.jpg", content_type: "image/jpeg")
        metadata = extract_metadata_from(blob)

        assert_equal 4104, metadata[:width]
        assert_equal 2736, metadata[:height]
        assert metadata[:opaque]
      end
    end

    test "analyzing a rotated JPEG image" do
      analyze_with_vips do
        blob = create_file_blob(filename: "racecar_rotated.jpg", content_type: "image/jpeg")
        metadata = extract_metadata_from(blob)

        assert_equal 2736, metadata[:width]
        assert_equal 4104, metadata[:height]
      end
    end

    test "analyzing an SVG image without an XML declaration" do
      analyze_with_vips do
        blob = create_file_blob(filename: "icon.svg", content_type: "image/svg+xml")
        metadata = extract_metadata_from(blob)

        assert_equal 792, metadata[:width]
        assert_equal 584, metadata[:height]
        assert_not metadata[:opaque]
      end
    end

    test "analyzing a transparent PNG" do
      analyze_with_vips do
        blob = create_file_blob(filename: "transparent.png", content_type: "image/png")
        metadata = extract_metadata_from(blob)

        assert_not metadata[:opaque]
      end
    end

    test "analyzing an opaque PNG with alpha channel" do
      analyze_with_vips do
        blob = create_file_blob(filename: "opaque.png", content_type: "image/png")
        metadata = extract_metadata_from(blob)

        assert metadata[:opaque]
      end
    end

    test "analyzing an unsupported image type" do
      analyze_with_vips do
        blob = create_blob(data: "bad", filename: "bad_file.bad", content_type: "image/bad_type")
        metadata = extract_metadata_from(blob)

        assert_nil metadata[:width]
        assert_nil metadata[:height]
        assert_nil metadata[:opaque]
      end
    end

    private
      def analyze_with_vips
        previous_processor, ActiveAnalysis.image_library = ActiveAnalysis.image_library, :vips
        require "ruby-vips"

        yield
      rescue LoadError
        ENV["CI"] ? raise : skip("Variant processor vips is not installed")
      ensure
        ActiveAnalysis.image_library = previous_processor
      end
  end
end
