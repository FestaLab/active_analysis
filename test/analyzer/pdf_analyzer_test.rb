# frozen_string_literal: true

require "test_helper"

module ActiveAnalysis
  class Analyzer::PDFAnalyzerTest < ActiveSupport::TestCase
    test "analyzing a pdf" do
      blob = create_file_blob(filename: "cropped.pdf", content_type: "application/pdf")
      metadata = Analyzer::PDFAnalyzer.new(blob).metadata

      assert_equal 429, metadata[:width]
      assert_equal 144, metadata[:height]
      assert_equal 1, metadata[:pages]
    end
  end
end
