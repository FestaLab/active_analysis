# frozen_string_literal: true

module ActiveAnalysis
  # This is an abstract base class for analyzer addons, which extract extra metadata from blobs.
  class Addon
    attr_reader :file

    def self.accept?(blob)
      false
    end

    def initialize(file)
      @file = file
    end

    def metadata
      raise NotImplementedError
    end
  end
end
