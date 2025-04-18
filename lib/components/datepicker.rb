# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Datepicker < Base
    STYLES = <<~HEREDOC
      flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1
      text-base shadow-sm transition-colors file:border-0 file:bg-transparent
      file:text-sm file:font-medium file:text-foreground placeholder:text-muted-foreground
      focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring
      disabled:cursor-not-allowed disabled:opacity-50 md:text-sm
      file:pt-0.5
    HEREDOC

    def initialize(name: nil, id: nil, value: nil, format: nil, settings: {}, **attributes)
      @name = name
      @id = id || @name
      @value = value
      @settings = settings
      @format = format
      super(**attributes)
    end

    def default_attributes
      {
        data: {
          value: @value&.utc.to_s,
          format: @format,
          controller: "shadcn-phlexcomponents--datepicker",
          settings: @settings.to_json
        }
      }
    end

    def view_template
      input(type: :text, readonly: true, **@attributes)
    end
  end
end