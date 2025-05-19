# frozen_string_literal: true

module ShadcnPhlexcomponents
  class FormHint < Base
    STYLES = "text-[0.8rem] text-muted-foreground"

    def initialize(message = nil, aria_id: nil, **attributes)
      @message = message
      @id = aria_id ? "#{aria_id}-description" : nil
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
