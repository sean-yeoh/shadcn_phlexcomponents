# frozen_string_literal: true

module ShadcnPhlexcomponents
  class AlertDialogCancel < Base
    def initialize(variant: :outline, **attributes)
      @variant = variant
      super(**attributes)
    end

    def default_attributes
      {
        data: {
          action: "click->shadcn-phlexcomponents--alert-dialog#close",
        },
      }
    end

    def view_template(&)
      Button(variant: @variant, **@attributes, &)
    end
  end
end
