# frozen_string_literal: true

module ActiveAnalysis
  # This is an abstract base class for analyzers, which extract metadata from blobs. See
  # Analyzer::AudioAnalyzer for an example of a concrete subclass.
  class Analyzer < ActiveStorage::Analyzer
  end
end
