# frozen_string_literal: true

require_relative "../addon"

module ActiveAnalysis
  # This is an abstract base class for image addons
  class Addon::ImageAddon < Addon
    def self.accept?(blob)
      blob.image?
    end

    def metadata
      raise NotImplementedError
    end
  end
end

