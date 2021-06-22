# frozen_string_literal: true

module ActiveAnalysis
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
