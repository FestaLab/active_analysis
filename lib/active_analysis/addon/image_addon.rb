# frozen_string_literal: true

require_relative "../addon"

module ActiveAnalysis
  # This is an abstract base class for image addons. Image addons are only executed for original
  # blobs.
  class Addon::ImageAddon < Addon
    def self.accept?(blob)
      blob.image? && blob.attachments.none? { |attachment| attachment.record_type == ActiveStorage::VariantRecord }
    end

    def metadata
      raise NotImplementedError
    end
  end
end
