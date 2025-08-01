# frozen_string_literal: true

require "test_helper"

class TestDropdownMenu < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DropdownMenu.new(open: false) { "Dropdown menu content" }
    output = render(component)

    assert_includes(output, "Dropdown menu content")
    assert_includes(output, "inline-flex max-w-fit")
    assert_includes(output, 'data-shadcn-phlexcomponents="dropdown-menu"')
    assert_includes(output, 'data-controller="dropdown-menu"')
    assert_includes(output, 'data-dropdown-menu-is-open-value="false"')
    assert_match(%r{<div[^>]*>.*Dropdown menu content.*</div>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::DropdownMenu.new(
      class: "custom-dropdown-menu",
      id: "dropdown-id",
      data: { testid: "dropdown-menu" },
    ) { "Custom content" }
    output = render(component)

    assert_includes(output, "custom-dropdown-menu")
    assert_includes(output, 'id="dropdown-id"')
    assert_includes(output, 'data-testid="dropdown-menu"')
    assert_includes(output, "inline-flex max-w-fit")
  end

  def test_it_should_handle_open_state
    component = ShadcnPhlexcomponents::DropdownMenu.new(open: true) { "Content" }
    output = render(component)

    assert_includes(output, 'data-dropdown-menu-is-open-value="true"')
  end

  def test_it_should_generate_unique_aria_id
    menu1 = ShadcnPhlexcomponents::DropdownMenu.new do |menu|
      menu.trigger { "Trigger 1" }
      menu.content { "Content 1" }
    end
    output1 = render(menu1)

    menu2 = ShadcnPhlexcomponents::DropdownMenu.new do |menu|
      menu.trigger { "Trigger 2" }
      menu.content { "Content 2" }
    end
    output2 = render(menu2)

    # Extract aria-controls values to ensure they're different
    controls1 = output1[/aria-controls="([^"]*)"/, 1]
    controls2 = output2[/aria-controls="([^"]*)"/, 1]

    refute_nil(controls1)
    refute_nil(controls2)
    refute_equal(controls1, controls2)
  end

  def test_it_should_render_with_helper_methods
    component = ShadcnPhlexcomponents::DropdownMenu.new do |menu|
      menu.trigger(class: "custom-trigger") { "Menu Trigger" }
      menu.content(class: "custom-content") do
        menu.label { "Menu Section" }
        menu.item { "Item 1" }
        menu.item { "Item 2" }
        menu.separator
        menu.item { "Item 3" }
      end
    end
    output = render(component)

    # Check trigger
    assert_includes(output, "Menu Trigger")
    assert_includes(output, "custom-trigger")
    assert_includes(output, 'role="button"')
    assert_includes(output, 'data-dropdown-menu-target="trigger"')

    # Check content
    assert_includes(output, "custom-content")
    assert_includes(output, 'role="menu"')
    assert_includes(output, 'data-dropdown-menu-target="content"')

    # Check label
    assert_includes(output, "Menu Section")
    assert_includes(output, "px-2 py-1.5 text-sm font-medium")

    # Check items
    assert_includes(output, "Item 1")
    assert_includes(output, "Item 2")
    assert_includes(output, "Item 3")
    assert_includes(output, 'role="menuitem"')

    # Check separator
    assert_includes(output, 'role="separator"')
    assert_includes(output, "bg-border -mx-1 my-1 h-px")
  end

  def test_it_should_handle_sub_menus
    component = ShadcnPhlexcomponents::DropdownMenu.new do |menu|
      menu.trigger { "Main Menu" }
      menu.content do
        menu.item { "Regular Item" }
        menu.sub do |sub|
          sub.trigger { "Sub Menu" }
          sub.content do
            "Sub Item 1"
          end
        end
      end
    end
    output = render(component)

    # Check main menu
    assert_includes(output, "Main Menu")
    assert_includes(output, "Regular Item")

    # Check sub menu
    assert_includes(output, "Sub Menu")
    assert_includes(output, "Sub Item 1")
    assert_includes(output, 'data-controller="dropdown-menu-sub"')
    assert_includes(output, 'data-dropdown-menu-sub-target="trigger"')
    assert_includes(output, 'data-dropdown-menu-sub-target="content"')
  end

  def test_it_should_handle_groups
    component = ShadcnPhlexcomponents::DropdownMenu.new do |menu|
      menu.trigger { "Grouped Menu" }
      menu.content do
        menu.group do
          menu.label { "Group 1" }
          menu.item { "Group Item 1" }
          menu.item { "Group Item 2" }
        end
        menu.separator
        menu.group do
          menu.label { "Group 2" }
          menu.item { "Group Item 3" }
        end
      end
    end
    output = render(component)

    # Check groups
    assert_includes(output, 'role="group"')
    assert_includes(output, "Group 1")
    assert_includes(output, "Group 2")
    assert_includes(output, "Group Item 1")
    assert_includes(output, "Group Item 2")
    assert_includes(output, "Group Item 3")
  end

  def test_it_should_render_complete_dropdown_menu_structure
    component = ShadcnPhlexcomponents::DropdownMenu.new(
      open: false,
      class: "full-dropdown-menu",
    ) do |menu|
      menu.trigger(class: "trigger-style") { "Complete Menu" }
      menu.content(class: "content-style", side: :bottom, align: :start) do
        menu.label(class: "section-label") { "Actions" }
        menu.item(class: "action-item") { "Edit" }
        menu.item(class: "action-item", variant: :destructive) { "Delete" }

        menu.separator(class: "custom-separator")

        menu.group(class: "options-group") do
          menu.label { "Options" }
          menu.item(disabled: true) { "Disabled Item" }
          menu.item { "Settings" }
        end

        menu.separator

        menu.sub do |sub|
          sub.trigger { "More Actions" }
          sub.content do
            "Export - Import"
          end
        end
      end
    end
    output = render(component)

    # Check main container
    assert_includes(output, "full-dropdown-menu")
    assert_includes(output, 'data-controller="dropdown-menu"')
    assert_includes(output, 'data-dropdown-menu-is-open-value="false"')

    # Check trigger
    assert_includes(output, "Complete Menu")
    assert_includes(output, "trigger-style")
    assert_includes(output, 'aria-haspopup="menu"')

    # Check content positioning
    assert_includes(output, "content-style")
    assert_includes(output, 'data-side="bottom"')
    assert_includes(output, 'data-align="start"')

    # Check labels and items
    assert_includes(output, "Actions")
    assert_includes(output, "section-label")
    assert_includes(output, "Edit")
    assert_includes(output, "Delete")
    assert_includes(output, "action-item")

    # Check destructive variant
    assert_includes(output, 'data-variant="destructive"')

    # Check separators
    assert_includes(output, "custom-separator")

    # Check groups
    assert_includes(output, "Options")
    assert_includes(output, "options-group")
    assert_includes(output, "Disabled Item")
    assert_includes(output, "data-disabled")
    assert_includes(output, "Settings")

    # Check sub menu
    assert_includes(output, "More Actions")
    assert_includes(output, "Export - Import")
  end
end

class TestDropdownMenuTrigger < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DropdownMenuTrigger.new(
      aria_id: "test-dropdown",
    ) { "Trigger content" }
    output = render(component)

    assert_includes(output, "Trigger content")
    assert_includes(output, 'data-shadcn-phlexcomponents="dropdown-menu-trigger"')
    assert_includes(output, 'id="test-dropdown-trigger"')
    assert_includes(output, 'role="button"')
    assert_includes(output, 'aria-controls="test-dropdown-content"')
    assert_includes(output, 'data-dropdown-menu-target="trigger"')
    assert_match(%r{<div[^>]*>.*Trigger content.*</div>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::DropdownMenuTrigger.new(
      aria_id: "custom-test",
      class: "custom-trigger",
      id: "trigger-id",
    ) { "Custom trigger" }
    output = render(component)

    assert_includes(output, "custom-trigger")
    assert_includes(output, "trigger-id") # Check that custom id is present
    assert_includes(output, 'aria-controls="custom-test-content"')
  end

  def test_it_should_handle_as_child_mode
    component = ShadcnPhlexcomponents::DropdownMenuTrigger.new(
      as_child: true,
      aria_id: "test",
    ) { "<button class=\"my-button\">Child Button</button>".html_safe }
    output = render(component)

    assert_includes(output, 'data-as-child="true"')
    assert_includes(output, "my-button")
    assert_includes(output, "Child Button")
    assert_includes(output, "click->dropdown-menu#toggle")
  end

  def test_it_should_include_aria_attributes
    component = ShadcnPhlexcomponents::DropdownMenuTrigger.new(aria_id: "a11y-test")
    output = render(component)

    assert_includes(output, 'aria-haspopup="menu"')
    assert_includes(output, 'aria-controls="a11y-test-content"')
    assert_includes(output, 'data-state="closed"')
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::DropdownMenuTrigger.new(aria_id: "action-test")
    output = render(component)

    assert_includes(output, "click->dropdown-menu#toggle")
    assert_includes(output, "keydown.down->dropdown-menu#open:prevent")
    assert_includes(output, "keydown.space->dropdown-menu#open:prevent")
    assert_includes(output, "keydown.enter->dropdown-menu#open:prevent")
  end
end

class TestDropdownMenuContent < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DropdownMenuContent.new(
      aria_id: "test-content",
    ) { "Content body" }
    output = render(component)

    assert_includes(output, "Content body")
    assert_includes(output, 'data-shadcn-phlexcomponents="dropdown-menu-content"')
    assert_includes(output, 'id="test-content-content"')
    assert_includes(output, 'role="menu"')
    assert_includes(output, 'data-dropdown-menu-target="content"')
    assert_includes(output, 'data-state="closed"')
  end

  def test_it_should_handle_positioning_attributes
    component = ShadcnPhlexcomponents::DropdownMenuContent.new(
      aria_id: "position-test",
      side: :top,
      align: :end,
    ) { "Positioned content" }
    output = render(component)

    assert_includes(output, 'data-side="top"')
    assert_includes(output, 'data-align="end"')
  end

  def test_it_should_use_default_positioning
    component = ShadcnPhlexcomponents::DropdownMenuContent.new(
      aria_id: "default-test",
    ) { "Default positioned content" }
    output = render(component)

    assert_includes(output, 'data-side="bottom"')
    assert_includes(output, 'data-align="center"')
  end

  def test_it_should_include_accessibility_attributes
    component = ShadcnPhlexcomponents::DropdownMenuContent.new(aria_id: "a11y-test")
    output = render(component)

    assert_includes(output, 'aria-labelledby="a11y-test-trigger"')
    assert_includes(output, 'aria-orientation="vertical"')
    assert_includes(output, 'tabindex="-1"')
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::DropdownMenuContent.new(aria_id: "action-test")
    output = render(component)

    assert_includes(output, "dropdown-menu:click:outside->dropdown-menu#clickOutside")
    assert_includes(output, "keydown.up->dropdown-menu#focusItemByIndex:prevent:self")
    assert_includes(output, "keydown.down->dropdown-menu#focusItemByIndex:prevent:self")
  end

  def test_it_should_use_content_container
    component = ShadcnPhlexcomponents::DropdownMenuContent.new(aria_id: "container-test")
    output = render(component)

    # Check that content is wrapped in container
    assert_includes(output, 'data-dropdown-menu-target="contentContainer"')
    assert_includes(output, 'style="display: none;"')
    assert_includes(output, "fixed top-0 left-0 w-max z-50")
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::DropdownMenuContent.new(aria_id: "style-test")
    output = render(component)

    assert_includes(output, "bg-popover text-popover-foreground")
    assert_includes(output, "data-[state=open]:animate-in data-[state=closed]:animate-out")
    assert_includes(output, "data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0")
    assert_includes(output, "z-50")
    assert_includes(output, "min-w-[8rem]")
    assert_includes(output, "overflow-x-hidden overflow-y-auto rounded-md border p-1 shadow-md")
  end
end

class TestDropdownMenuLabel < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DropdownMenuLabel.new { "Label text" }
    output = render(component)

    assert_includes(output, "Label text")
    assert_includes(output, 'data-shadcn-phlexcomponents="dropdown-menu-label"')
    assert_includes(output, "px-2 py-1.5 text-sm font-medium")
    assert_match(%r{<div[^>]*>Label text</div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::DropdownMenuLabel.new(
      class: "custom-label",
      id: "label-id",
    ) { "Custom label" }
    output = render(component)

    assert_includes(output, "custom-label")
    assert_includes(output, 'id="label-id"')
  end

  def test_it_should_handle_inset_data_attribute
    component = ShadcnPhlexcomponents::DropdownMenuLabel.new(
      data: { inset: true },
    ) { "Inset label" }
    output = render(component)

    assert_includes(output, "data-inset")
    assert_includes(output, "data-[inset]:pl-8")
  end
end

class TestDropdownMenuItem < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DropdownMenuItem.new { "Item text" }
    output = render(component)

    assert_includes(output, "Item text")
    assert_includes(output, 'data-shadcn-phlexcomponents="dropdown-menu-item"')
    assert_includes(output, 'role="menuitem"')
    assert_includes(output, 'data-dropdown-menu-target="item"')
    assert_includes(output, 'data-variant="default"')
    assert_includes(output, 'tabindex="-1"')
    assert_match(/>Item text</, output)
  end

  def test_it_should_handle_variant_attribute
    component = ShadcnPhlexcomponents::DropdownMenuItem.new(variant: :destructive) { "Destructive item" }
    output = render(component)

    assert_includes(output, 'data-variant="destructive"')
    assert_includes(output, "data-[variant=destructive]:text-destructive")
    assert_includes(output, "data-[variant=destructive]:focus:bg-destructive/10")
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::DropdownMenuItem.new(disabled: true) { "Disabled item" }
    output = render(component)

    assert_includes(output, "data-disabled")
    assert_includes(output, "data-[disabled]:pointer-events-none")
    assert_includes(output, "data-[disabled]:opacity-50")
  end

  def test_it_should_handle_as_child_mode
    component = ShadcnPhlexcomponents::DropdownMenuItem.new(as_child: true) do
      "<a href=\"/link\" class=\"menu-link\">Link Item</a>".html_safe
    end
    output = render(component)

    assert_includes(output, "menu-link")
    assert_includes(output, "Link Item")
    assert_includes(output, 'href="/link"')
    assert_includes(output, "click->dropdown-menu#select")
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::DropdownMenuItem.new { "Action item" }
    output = render(component)

    assert_includes(output, "click->dropdown-menu#select")
    assert_includes(output, "mouseover->dropdown-menu#focusItem")
    assert_includes(output, "keydown.up->dropdown-menu#focusItem:prevent")
    assert_includes(output, "keydown.down->dropdown-menu#focusItem:prevent")
    assert_includes(output, "focus->dropdown-menu#onItemFocus")
    assert_includes(output, "blur->dropdown-menu#onItemBlur")
    assert_includes(output, "keydown.enter->dropdown-menu#select:prevent")
    assert_includes(output, "keydown.space->dropdown-menu#select:prevent")
    assert_includes(output, "mouseout->dropdown-menu#focusContent")
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::DropdownMenuItem.new { "Styled item" }
    output = render(component)

    assert_includes(output, "focus:bg-accent focus:text-accent-foreground")
    assert_includes(output, "[&_svg:not([class*='text-'])]:text-muted-foreground")
    assert_includes(output, "relative flex cursor-default items-center gap-2")
    assert_includes(output, "rounded-sm px-2 py-1.5 text-sm outline-hidden select-none")
    assert_includes(output, "[&_svg]:pointer-events-none [&_svg]:shrink-0")
  end
end

class TestDropdownMenuItemTo < ComponentTest
  def test_it_should_render_button_to
    component = ShadcnPhlexcomponents::DropdownMenuItemTo.new("/test/path", { method: :post }) { "Button To Item" }
    output = render(component)

    assert_includes(output, "Button To Item")
    assert_includes(output, 'action="/test/path"')
    assert_includes(output, 'method="post"')
    assert_includes(output, "w-full")
    assert_includes(output, 'role="menuitem"')
  end

  def test_it_should_handle_variant_and_disabled
    component = ShadcnPhlexcomponents::DropdownMenuItemTo.new(
      "/delete",
      { method: :delete },
      { variant: :destructive, disabled: true },
    ) { "Delete Item" }
    output = render(component)

    # Check for destructive styling classes instead of data attribute
    assert_includes(output, "data-[variant=destructive]:text-destructive")
    assert_includes(output, "disabled")
  end

  def test_it_should_handle_simple_form
    component = ShadcnPhlexcomponents::DropdownMenuItemTo.new("Save", "/save")
    output = render(component)

    assert_includes(output, "Save")
    assert_includes(output, 'action="/save"')
  end
end

class TestDropdownMenuSeparator < ComponentTest
  def test_it_should_render_separator
    component = ShadcnPhlexcomponents::DropdownMenuSeparator.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="dropdown-menu-separator"')
    assert_includes(output, 'role="separator"')
    assert_includes(output, 'aria-orientation="horizontal"')
    assert_includes(output, "bg-border -mx-1 my-1 h-px")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::DropdownMenuSeparator.new(
      class: "custom-separator",
      id: "separator-id",
    )
    output = render(component)

    assert_includes(output, "custom-separator")
    assert_includes(output, 'id="separator-id"')
  end
end

class TestDropdownMenuGroup < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DropdownMenuGroup.new { "Group content" }
    output = render(component)

    assert_includes(output, "Group content")
    assert_includes(output, 'data-shadcn-phlexcomponents="dropdown-menu-group"')
    assert_includes(output, 'role="group"')
    assert_match(%r{<div[^>]*>Group content</div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::DropdownMenuGroup.new(
      class: "custom-group",
      id: "group-id",
    ) { "Custom group" }
    output = render(component)

    assert_includes(output, "custom-group")
    assert_includes(output, 'id="group-id"')
  end
end

class TestDropdownMenuContentContainer < ComponentTest
  def test_it_should_render_container
    component = ShadcnPhlexcomponents::DropdownMenuContentContainer.new { "Container content" }
    output = render(component)

    assert_includes(output, "Container content")
    assert_includes(output, 'data-shadcn-phlexcomponents="dropdown-menu-content-container"')
    assert_includes(output, 'data-dropdown-menu-target="contentContainer"')
    assert_includes(output, 'style="display: none;"')
    assert_includes(output, "fixed top-0 left-0 w-max z-50")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::DropdownMenuContentContainer.new(
      class: "custom-container",
      id: "container-id",
    ) { "Custom container" }
    output = render(component)

    assert_includes(output, "custom-container")
    assert_includes(output, 'id="container-id"')
  end
end

class TestDropdownMenuWithCustomConfiguration < ComponentTest
  def test_dropdown_menu_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.dropdown_menu = {
      root: { base: "custom-dropdown-menu-base" },
      content: { base: "custom-content-base" },
      label: { base: "custom-label-base" },
      item: { base: "custom-item-base" },
      separator: { base: "custom-separator-base" },
      content_container: { base: "custom-content-container-base" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    dropdown_classes = [
      "DropdownMenuContentContainer",
      "DropdownMenuGroup",
      "DropdownMenuSeparator",
      "DropdownMenuItemTo",
      "DropdownMenuItem",
      "DropdownMenuLabel",
      "DropdownMenuContent",
      "DropdownMenuTrigger",
      "DropdownMenu",
    ]

    dropdown_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/dropdown_menu.rb", __dir__))

    # Test components with custom configuration
    dropdown = ShadcnPhlexcomponents::DropdownMenu.new { "Test" }
    assert_includes(render(dropdown), "custom-dropdown-menu-base")

    content = ShadcnPhlexcomponents::DropdownMenuContent.new(aria_id: "test") { "Content" }
    assert_includes(render(content), "custom-content-base")

    label = ShadcnPhlexcomponents::DropdownMenuLabel.new { "Label" }
    assert_includes(render(label), "custom-label-base")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    dropdown_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/dropdown_menu.rb", __dir__))
  end
end

class TestDropdownMenuIntegration < ComponentTest
  def test_complete_dropdown_menu_workflow
    component = ShadcnPhlexcomponents::DropdownMenu.new(
      open: false,
      class: "user-actions-menu",
      data: { controller: "dropdown-menu analytics", analytics_category: "user-actions" },
    ) do |menu|
      menu.trigger(class: "action-trigger") { "👤 User Actions" }
      menu.content(class: "action-content", side: :bottom, align: :end) do
        menu.label { "👤 Account" }
        menu.item(class: "profile-item") { "🔧 Profile Settings" }
        menu.item(class: "preferences-item") { "⚙️ Preferences" }

        menu.separator

        menu.group do
          menu.label { "📊 Data" }
          menu.item { "📥 Import Data" }
          menu.item { "📤 Export Data" }
        end

        menu.separator

        menu.sub do |sub|
          sub.trigger { "🔧 Advanced" }
          sub.content do
            menu.item { "🔍 Diagnostics" }
            menu.item { "🧹 Clear Cache" }
          end
        end

        menu.separator

        menu.item(variant: :destructive, class: "danger-item") { "🗑️ Delete Account" }
      end
    end

    output = render(component)

    # Check main structure
    assert_includes(output, "user-actions-menu")
    # Controller merging may include spaces
    assert_match(/data-controller="[^"]*dropdown-menu[^"]*analytics[^"]*"/, output)
    assert_includes(output, 'data-analytics-category="user-actions"')

    # Check trigger with emoji
    assert_includes(output, "👤 User Actions")
    assert_includes(output, "action-trigger")
    assert_includes(output, 'aria-haspopup="menu"')

    # Check content positioning
    assert_includes(output, "action-content")
    assert_includes(output, 'data-side="bottom"')
    assert_includes(output, 'data-align="end"')

    # Check labels and items with emojis
    assert_includes(output, "👤 Account")
    assert_includes(output, "🔧 Profile Settings")
    assert_includes(output, "⚙️ Preferences")
    assert_includes(output, "profile-item")
    assert_includes(output, "preferences-item")

    # Check groups
    assert_includes(output, "📊 Data")
    assert_includes(output, "📥 Import Data")
    assert_includes(output, "📤 Export Data")
    assert_includes(output, 'role="group"')

    # Check sub menu
    assert_includes(output, "🔧 Advanced")
    assert_includes(output, "🔍 Diagnostics")
    assert_includes(output, "🧹 Clear Cache")
    assert_includes(output, 'data-controller="dropdown-menu-sub"')

    # Check destructive item
    assert_includes(output, "🗑️ Delete Account")
    assert_includes(output, 'data-variant="destructive"')
    assert_includes(output, "danger-item")

    # Check separators
    assert_includes(output, 'role="separator"')
    assert_includes(output, "bg-border -mx-1 my-1 h-px")
  end

  def test_dropdown_menu_accessibility_features
    component = ShadcnPhlexcomponents::DropdownMenu.new(
      aria: { label: "User menu", describedby: "menu-help" },
    ) do |menu|
      menu.trigger(aria: { labelledby: "menu-label" }) { "Accessible trigger" }
      menu.content do
        menu.label { "Accessible Menu" }
        menu.item(aria: { describedby: "item-help" }) { "Accessible Item 1" }
        menu.item(disabled: true) { "Disabled Item" }
      end
    end

    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'aria-label="User menu"')
    assert_includes(output, 'aria-describedby="menu-help"')
    assert_includes(output, 'aria-labelledby="menu-label"')

    # Check ARIA roles and relationships
    assert_includes(output, 'role="button"') # trigger
    assert_includes(output, 'role="menu"') # content
    assert_includes(output, 'role="menuitem"') # items
    assert_includes(output, 'aria-haspopup="menu"')
    assert_match(/aria-controls="[^"]*-content"/, output)
    assert_match(/aria-labelledby="[^"]*-trigger"/, output)
    assert_includes(output, 'aria-orientation="vertical"')

    # Check disabled item accessibility
    assert_includes(output, "data-disabled")
    assert_includes(output, "data-[disabled]:pointer-events-none")
    assert_includes(output, "data-[disabled]:opacity-50")
  end

  def test_dropdown_menu_stimulus_integration
    component = ShadcnPhlexcomponents::DropdownMenu.new(
      data: {
        controller: "dropdown-menu custom-menu",
        custom_menu_delay_value: "200",
      },
    ) do |menu|
      menu.trigger(
        data: { action: "click->custom-menu#beforeOpen" },
      ) { "Stimulus trigger" }

      menu.content do
        menu.item(
          data: { action: "click->custom-menu#itemSelected" },
        ) { "Custom Item" }
      end
    end

    output = render(component)

    # Check multiple controllers
    assert_match(/data-controller="[^"]*dropdown-menu[^"]*custom-menu[^"]*"/, output)
    assert_includes(output, 'data-custom-menu-delay-value="200"')

    # Check custom actions
    assert_match(/click->custom-menu#beforeOpen/, output)
    assert_match(/click->custom-menu#itemSelected/, output)

    # Check default dropdown-menu actions still work
    assert_match(/click->dropdown-menu#toggle/, output)
    assert_match(/click->dropdown-menu#select/, output)
  end

  def test_dropdown_menu_with_item_to_integration
    component = ShadcnPhlexcomponents::DropdownMenu.new do |menu|
      menu.trigger { "Form Actions" }
      menu.content do
        menu.label { "Actions" }
        menu.item_to("💾 Save", "/save", { method: :post })
        menu.item_to("🗑️ Delete", "/delete", { method: :delete })
      end
    end

    output = render(component)

    # Check form actions
    assert_includes(output, "Form Actions")
    assert_includes(output, "Actions")

    # Check button_to items
    assert_includes(output, "💾 Save")
    assert_includes(output, 'action="/save"')
    assert_includes(output, 'method="post"')

    assert_includes(output, "🗑️ Delete")
    assert_includes(output, 'action="/delete"')
    assert_includes(output, 'value="delete"')

    # Check styling
    assert_includes(output, "w-full")
    assert_includes(output, 'role="menuitem"')
  end
end
