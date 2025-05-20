# frozen_string_literal: true

module ShadcnPhlexcomponents
  class ToastContainer < Base
    STYLES = <<~HEREDOC
      fixed top-0 z-[100] flex max-h-screen w-full flex-col-reverse p-4
      sm:bottom-0 sm:right-0 sm:top-auto sm:flex-col md:max-w-[420px]
    HEREDOC

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
      end
    end
  end
end
