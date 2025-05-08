# frozen_string_literal: true

module ShadcnPhlexcomponents
  class FormError < Base
    STYLES = "text-[0.8rem] font-medium text-destructive"

    def initialize(message: nil, aria_id: nil, **attributes)
      @message = message
      @id = aria_id ? "#{aria_id}-message" : nil
      super(**attributes)
    end

    def view_template(&)
      p(id: @id, **@attributes) { @message }
    end
  end
end
