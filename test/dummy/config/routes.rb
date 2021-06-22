# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActiveAnalysis::Engine => "/active_analysis"
end
