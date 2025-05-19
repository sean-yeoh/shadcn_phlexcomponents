# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SidebarMenuButton < Base
    STYLES = <<~HEREDOC
      peer/menu-button flex w-full items-center gap-2 overflow-hidden rounded-md p-2 text-left
      text-sm outline-hidden ring-sidebar-ring transition-[width,height,padding] hover:bg-sidebar-accent hover:text-sidebar-accent-foreground
      focus-visible:ring-2 active:bg-sidebar-accent active:text-sidebar-accent-foreground
      disabled:pointer-events-none disabled:opacity-50 group-has-data-[sidebar=menu-action]/menu-item:pr-8
      aria-disabled:pointer-events-none aria-disabled:opacity-50 data-[active=true]:bg-sidebar-accent
      data-[active=true]:font-medium data-[active=true]:text-sidebar-accent-foreground data-[state=open]:hover:bg-sidebar-accent
      data-[state=open]:hover:text-sidebar-accent-foreground group-data-[collapsible=icon]:size-8! group-data-[collapsible=icon]:p-2!
      [&>span:last-child]:truncate [&>svg]:size-4 [&>svg]:shrink-0 cursor-pointer
    HEREDOC

    SIZES = {
      default: "h-8 text-sm",
      sm: "h-7 text-xs",
      lg: "h-12 text-sm group-data-[collapsible=icon]:p-0!",
    }

    def initialize(size: :default, type: :button, active: false, as_child: false, **attributes)
      @type = type
      @size = size
      @active = active
      @as_child = as_child
      super(**attributes)
    end

    def default_attributes
      {
        data: {
          active: @active.to_s,
        },
      }
    end

    def default_styles
      "#{STYLES} #{SIZES[@size]}"
    end

    def view_template(&)
      if @as_child
        content = capture(&)
        element = find_as_child(content.to_s)

        vanish(&)
        element_attributes = nokogiri_attributes_to_hash(element)
        styles = TAILWIND_MERGER.merge("#{@attributes[:class]} #{element_attributes[:class]}")
        merged_attributes = mix(@attributes, element_attributes)
        merged_attributes[:class] = styles

        send(element.name, **merged_attributes) do
          sanitize_as_child(element.children.to_s)
        end
      else
        button(**@attributes, &)
      end
    end
  end
end
