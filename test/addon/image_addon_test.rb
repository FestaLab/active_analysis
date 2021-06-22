# frozen_string_literal: true

require "test_helper"

module ActiveAnalysis
  class Addon::ImageAddonTest < ActiveSupport::TestCase
    test "that it accepts only image blobs" do
      blob = create_file_blob(filename: "racecar.jpg", content_type: "image/jpeg")
      assert Addon::ImageAddon.accept?(blob)

      blob = create_file_blob(filename: "audio.mp3", content_type: "audio/mp3")
      assert_not Addon::ImageAddon.accept?(blob)
    end

    test "that it does not accept variant records" do
      blob = create_file_blob(filename: "racecar.jpg", content_type: "image/jpeg")
      blob = blob.variant(resize_to_limit: [100, 100]).processed.blob

      assert Addon::ImageAddon.accept?(blob)
    end
  end
end
