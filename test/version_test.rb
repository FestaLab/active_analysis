# frozen_string_literal: true

require "test_helper"

module ActiveAnalysis
  class VersionTest < ActiveSupport::TestCase
    test "that version is set" do
      assert ActiveAnalysis::VERSION
    end
  end
end
