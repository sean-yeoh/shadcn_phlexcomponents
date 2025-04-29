# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Combobox < Base
    def initialize(id: nil,
      name: nil,
      value: nil,
      placeholder: nil,
      disabled: false,
      include_blank: false,
      **attributes)
      @id = id || name
      @name = name
      @value = value
      @placeholder = placeholder
      @include_blank = include_blank
      @disabled = disabled
      super(**attributes)
    end

    def item(**attributes, &)
      ComboboxItem(**attributes, &)
    end

    def items(collection)
      collection.each do |option|
        ComboboxItem(value: option[:value], disabled: option[:disabled]) { option[:name] }
      end
    end

    def view_template(&)
      div(**@attributes) do
        select(
          id: @id,
          name: @name,
          disabled: @disabled,
          data: { "shadcn-phlexcomponents--combobox-target": "select" },
        ) do
          option(value: "")

          yield
        end
      end
    end

    def default_attributes
      {
        data: {
          controller: "shadcn-phlexcomponents--combobox",
          placeholder: @placeholder,
          include_blank: @include_blank.to_s,
          value: @value,
        },
      }
    end
  end
end
