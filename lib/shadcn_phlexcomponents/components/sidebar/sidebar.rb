# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Sidebar < Base
    STYLES = <<~HEREDOC
      bg-sidebar group-data-[variant=floating]:border-sidebar-border flex h-full w-full flex-col
      group-data-[variant=floating]:rounded-lg group-data-[variant=floating]:border
      group-data-[variant=floating]:shadow
    HEREDOC

    PANEL_STYLES = {
      sidebar: "group-data-[side=left]:border-r group-data-[side=right]:border-l",
      floating: "p-2",
      inset: "p-2",
    }

    def initialize(id:, variant: :sidebar, side: :left, width: "16rem", expanded: true, **attributes)
      @id = id
      @variant = variant
      @side = side
      @width = width
      @expanded = expanded
      super(**attributes)
    end

    def header(**attributes, &)
      SidebarHeader(**attributes, &)
    end

    def content(**attributes, &)
      SidebarContent(**attributes, &)
    end

    def group(**attributes, &)
      SidebarGroup(**attributes, &)
    end

    def group_content(**attributes, &)
      SidebarGroupContent(**attributes, &)
    end

    def group_label(**attributes, &)
      SidebarGroupLabel(**attributes, &)
    end

    def menu(**attributes, &)
      SidebarMenu(**attributes, &)
    end

    def menu_item(**attributes, &)
      SidebarMenuItem(**attributes, &)
    end

    def menu_button(**attributes, &)
      SidebarMenuButton(**attributes, &)
    end

    def menu_sub(**attributes, &)
      SidebarMenuSub(**attributes, &)
    end

    def menu_sub_item(**attributes, &)
      SidebarMenuSubItem(**attributes, &)
    end

    def menu_sub_button(**attributes, &)
      SidebarMenuSubButton(**attributes, &)
    end

    def footer(**attributes, &)
      SidebarFooter(**attributes, &)
    end

    def view_template(&)
      div(
        id: @id,
        class: "group peer hidden md:block",
        style: { "--sidebar-width": @width },
        data: {
          side: @side,
          variant: @variant,
          collapsible: @expanded ? "" : "offcanvas",
          sidebar_id: @sidebar_id,
          state: @expanded ? "expanded" : "collapsed",
          controller: "sidebar",
        },
      ) do
        div(
          class: "relative h-svh w-[var(--sidebar-width)] bg-transparent transition-[width] duration-200
                    ease-linear group-data-[collapsible=offcanvas]:w-0 group-data-[side=right]:rotate-180
                    group-data-[collapsible=icon]:w-[--sidebar-width-icon]",
          data: { "sidebar-target": "panelOffset" },
        )

        div(
          class: "fixed inset-y-0 z-10 hidden h-svh w-[var(--sidebar-width)] transition-[left,right,width] duration-200
                    ease-linear md:flex left-0 group-data-[collapsible=offcanvas]:left-[calc(var(--sidebar-width)*-1)]
                    group-data-[collapsible=icon]:w-[--sidebar-width-icon] #{PANEL_STYLES[@variant]}",
          data: {
            "sidebar-target": "panel",
          },
        ) do
          div(**@attributes, &)
        end
      end
    end
  end
end
