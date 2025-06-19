# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Label < Base
    class_variants(
      base: <<~HEREDOC,
        flex items-center gap-2 text-sm leading-none font-medium select-none group-data-[disabled=true]:pointer-events-none
        group-data-[disabled=true]:opacity-50 peer-disabled:cursor-not-allowed peer-disabled:opacity-50
      HEREDOC
    )

    def view_template(&)
      label(**@attributes, &)
    end
  end
end
