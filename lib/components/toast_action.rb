# frozen_string_literal: true

module ShadcnPhlexcomponents
  class ToastAction < Base
    STYLES = <<~HEREDOC
      inline-flex h-8 shrink-0 items-center justify-center rounded-md border
      bg-transparent px-3 text-sm font-medium transition-colors hover:bg-secondary
      focus:outline-none focus:ring-1 focus:ring-ring disabled:pointer-events-none
      disabled:opacity-50 group-[.destructive]:border-muted/40 group-[.destructive]:hover:border-destructive/30
      group-[.destructive]:hover:bg-destructive group-[.destructive]:hover:text-destructive-foreground
      group-[.destructive]:focus:ring-destructive cursor-pointer
    HEREDOC

    def initialize(as_child: false, **attributes)
      @as_child = as_child
      super(**attributes)
    end
    
    def view_template(&)
      if @as_child
        content = capture(&)
        element = find_as_child(content.to_s)

        vanish(&)

        element_attributes = nokogiri_attributes_to_hash(element)
        merged_attributes = mix(@attributes, element_attributes)
        merged_attributes[:class] = TAILWIND_MERGER.merge("#{STYLES} #{element_attributes[:class]}")

        send(element.name, **merged_attributes) do        
          sanitize_as_child(element.children.to_s)
        end
      else
        button(**@attributes, &)
      end
    end
  end
end