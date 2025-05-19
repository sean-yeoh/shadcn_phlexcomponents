# frozen_string_literal: true

module ShadcnPhlexcomponents
  class AlertDialogContent < Base
    STYLES = <<~HEREDOC
      fixed left-[50%] top-[50%] z-50 grid w-full max-w-lg translate-x-[-50%] pointer-events-auto
      translate-y-[-50%] gap-4 border bg-background p-6 shadow-lg duration-200
      data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0
      data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95
      data-[state=closed]:slide-out-to-left-1/2 data-[state=closed]:slide-out-to-top-[48%]
      data-[state=open]:slide-in-from-left-1/2 data-[state=open]:slide-in-from-top-[48%] sm:rounded-lg
    HEREDOC

    def initialize(aria_id: nil, **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def default_attributes
      {
        id: "#{@aria_id}-content",
        tabindex: -1,
        role: "alertdialog",
        aria: {
          describedby: "#{@aria_id}-description",
          labelledby: "#{@aria_id}-title",
        },
        data: {
          state: "closed",
          "alert-dialog-target": "content",
        },
      }
    end

    def view_template(&)
      @class = @attributes.delete(:class)
      div(class: "#{@class} hidden", **@attributes, &)
    end
  end
end
