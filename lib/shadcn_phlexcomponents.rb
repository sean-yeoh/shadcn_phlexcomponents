# frozen_string_literal: true

require_relative "shadcn_phlexcomponents/version"
require_relative "shadcn_phlexcomponents/engine"
require_relative "shadcn_phlexcomponents/configuration"

module ShadcnPhlexcomponents
  class Error < StandardError; end

  class << self
    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
