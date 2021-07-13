# frozen_string_literal: true

require_relative "../image_addon"

module ActiveAnalysis
  class Addon::ImageAddon::WhiteBackground < Addon::ImageAddon
    def metadata
      { white_background: white_background? }
    end

    private
      def white_background?
        corners = extract_corner_areas(file)
        colors = corners.map { |corner| primary_color_for(corner) }
        colors.all? { |color| color.all? { |value| value > 250 } }
      rescue
        nil
      end

      def extract_corner_areas(image)
        paths = []

        image_path = ActiveAnalysis.image_library == :vips ? image.filename : image.path
        basename   = SecureRandom.urlsafe_base64
        width      = image.width
        height     = image.height
        size       = 8

        paths << Rails.root.join("tmp", "#{basename}_top_left.jpg")
        `vips im_extract_area #{image_path} #{paths.last} 0 0 #{size} #{size}`

        paths << Rails.root.join("tmp", "#{basename}_top_right.jpg")
        `vips im_extract_area #{image_path} #{paths.last} #{width - size} 0 #{size} #{size}`

        paths << Rails.root.join("tmp", "#{basename}_bottom_right.jpg")
        `vips im_extract_area #{image_path} #{paths.last} #{width - size} #{height - size} #{size} #{size}`

        paths << Rails.root.join("tmp", "#{basename}_bottom_left.jpg")
        `vips im_extract_area #{image_path} #{paths.last} 0 #{height - size} #{size} #{size}`

        paths
      end

      def primary_color_for(filepath)
        histogram = generate_color_histogram(filepath)
        sorted = sort_by_frequency(histogram)
        extract_dominant_rgb(sorted)
      end

      def generate_color_histogram(path)
        `convert #{path} +dither -colors 5 -define histogram:unique-colors=true -format "%c" histogram:info:`
      end

      def sort_by_frequency(histogram)
        histogram.each_line.map { |line| parts = line.split(":"); [parts[0].to_i, parts[1]] }.sort_by { |line| line[0] }.reverse
      end

      def extract_dominant_rgb(array)
        array.map { |line| line[1].match(/\(([\d.,]+)/).captures.first.split(",").take(3).map(&:to_i) }.first
      end
  end
end
