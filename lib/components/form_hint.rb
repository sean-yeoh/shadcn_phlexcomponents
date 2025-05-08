# frozen_string_literal: true

module ShadcnPhlexcomponents
  class FormHint < Base
    STYLES = "text-[0.8rem] text-muted-foreground"

    def initialize(message: nil, aria_id: nil, **attributes)
      @message = message
      @id = aria_id ? "#{aria_id}-description" : nil
      super(**attributes)
    end

    def view_template(&)
      p(id: @id, **@attributes) { @message }
    end
  end
end
