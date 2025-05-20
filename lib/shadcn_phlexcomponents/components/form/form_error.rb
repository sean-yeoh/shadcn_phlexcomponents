# frozen_string_literal: true

module ShadcnPhlexcomponents
  class FormError < Base
    STYLES = "text-[0.8rem] font-medium text-destructive"

    def initialize(message, aria_id: nil, **attributes)
      @message = message
      @id = aria_id ? "#{aria_id}-message" : nil
      super(**attributes)
    end

    def view_template(&)
      if @message
        p(id: @id, **@attributes) { @message }
      else
        p(id: @id, **@attributes, &)
      end
    end
  end
end
