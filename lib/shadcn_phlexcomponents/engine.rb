# frozen_string_literal: true

require "rails"

module ShadcnPhlexcomponents
  class Engine < ::Rails::Engine
    config.app_generators do |g|
      g.template_engine(:shadcn_phlexcomponents)
    end
  end
end
