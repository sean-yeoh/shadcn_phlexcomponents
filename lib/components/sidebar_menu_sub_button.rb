# frozen_string_literal: true

module ShadcnPhlexcomponents
  class SidebarMenuSubButton < Base
    STYLES = <<~HEREDOC
      text-sidebar-foreground ring-sidebar-ring hover:bg-sidebar-accent hover:text-sidebar-accent-foreground
      active:bg-sidebar-accent active:text-sidebar-accent-foreground [&>svg]:text-sidebar-accent-foreground
      flex h-7 min-w-0 -translate-x-px items-center gap-2 overflow-hidden rounded-md px-2 outline-none
      focus-visible:ring-2 disabled:pointer-events-none disabled:opacity-50 aria-disabled:pointer-events-none
      aria-disabled:opacity-50 [&>span:last-child]:truncate [&>svg]:size-4 [&>svg]:shrink-0 
      data-[active=true]:bg-sidebar-accent data-[active=true]:text-sidebar-accent-foreground 
      text-sm group-data-[collapsible=icon]:hidden cursor-pointer
    HEREDOC

    def initialize(type: :button, active: false, as_child: false, **attributes)
      @active = active
      @as_child = as_child
      super(**attributes)
    end

    def default_attributes
      {
        data: {
          active: @active.to_s
        }
      }  
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