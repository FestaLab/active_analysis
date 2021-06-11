# frozen_string_literal: true

require_relative "../analyzer"

module ActiveAnalysis
  # Extracts width, height in pixels and number of pages from a pdf blob.
  #
  # Example:
  #
  #   ActiveAnalysis::CoreExtensionsAnalyzer::PDFAnalyzer::Poppler.new(blob).metadata
  #   # => { width: 4104, height: 2736, pages: 10 }
  #
  # This analyzer requires the {poppler}[https://poppler.freedesktop.org/] system library, which is not provided by Rails.
  class Analyzer::PDFAnalyzer < Analyzer
    class << self
      def accept?(blob)
        blob.content_type == "application/pdf" && pdfinfo_exists?
      end

      def pdfinfo_path
        ActiveStorage.paths[:pdfinfo] || "pdfinfo"
      end

      def pdfinfo_exists?
        return @pdfinfo_exists if defined?(@pdfinfo_exists)

        @pdfinfo_exists = system(pdfinfo_path, "-v", out: File::NULL, err: File::NULL)
      end
    end

    def metadata
      { width: width, height: height, pages: pages }.compact
    end

    private
      def pages
        pages = info["Pages"]
        Integer(pages) if pages
      end

      def width
        (right - left).floor if cropbox.present?
      end

      def height
        (top - bottom).floor if cropbox.present?
      end

      def left
        Float cropbox[0]
      end

      def bottom
        Float cropbox[1]
      end

      def right
        Float cropbox[2]
      end

      def top
        Float cropbox[3]
      end

      def cropbox
        return @cropbox if defined?(@cropbox)
        @cropbox = (info["CropBox"] || "").split
      end

      def info
        @info ||= download_blob_to_tempfile { |file| info_from(file) }
      end

      def info_from(file)
        IO.popen([self.class.pdfinfo_path, "-box", file.path]) do |output|
          output.read.scan(/^(.*?): *(.*)?/).to_h
        end
      rescue Errno::ENOENT
        logger.info "Skipping pdf analysis due to an error"
        {}
      end
  end
end
