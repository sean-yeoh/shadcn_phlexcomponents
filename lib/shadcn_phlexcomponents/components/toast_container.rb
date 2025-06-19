# frozen_string_literal: true

module ShadcnPhlexcomponents
  class ToastContainer < Base
    class_variants(
      base: "fixed z-[100] hidden has-[li]:flex flex-col gap-2",
      variants: {
        side: {
          top_center: "top-6 left-1/2 -translate-x-1/2",
          top_left: "top-6 left-6",
          top_right: "top-6 right-6",
          bottom_center: "bottom-6 left-1/2 -translate-x-1/2",
          bottom_left: "bottom-6 left-6",
          bottom_right: "right-6 bottom-6",
        },
      },
      defaults: {
        side: :top_center,
      },
    )

    def initialize(side: :top_center, **attributes)
      @class_variants = { side: side }
      super(**attributes)
    end

    def default_attributes
      {
        tabindex: -1,
        data: {
          controller: "toast-container",
        },
      }
    end

    def view_template(&)
      div(
        role: "region",
        tabindex: -1,
        aria: {
          label: "Notifications",
        },
      ) do
        ol(**@attributes) do
          template(data: { variant: "default" }) { toast(:default) }
          template(data: { variant: "destructive" }) { toast(:destructive) }
          yield
        end
      end
    end

    def toast(variant)
      Toast(variant: variant) do |t|
        t.content do
          t.title { "" }
          t.description { "" }
        end

        t.action { "" }
      end
    end
  end
end
