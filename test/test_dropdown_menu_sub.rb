# frozen_string_literal: true

require "test_helper"

class TestDropdownMenuSub < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DropdownMenuSub.new(
      aria_id: "test-sub",
    ) { "Sub menu content" }
    output = render(component)

    assert_includes(output, "Sub menu content")
    assert_includes(output, 'data-shadcn-phlexcomponents="dropdown-menu-sub"')
    assert_includes(output, 'data-controller="dropdown-menu-sub"')
    assert_includes(output, 'data-action="keydown.left->dropdown-menu-sub#closeOnLeftKeydown:prevent"')
    assert_match(%r{<div[^>]*>.*Sub menu content.*</div>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::DropdownMenuSub.new(
      aria_id: "custom-sub",
      class: "custom-dropdown-menu-sub",
      id: "sub-id",
      data: { testid: "dropdown-menu-sub" },
    ) { "Custom content" }
    output = render(component)

    assert_includes(output, "custom-dropdown-menu-sub")
    assert_includes(output, 'id="sub-id"')
    assert_includes(output, 'data-testid="dropdown-menu-sub"')
  end

  def test_it_should_render_with_helper_methods
    component = ShadcnPhlexcomponents::DropdownMenuSub.new(
      aria_id: "helper-test",
    ) do |sub|
      sub.trigger(class: "custom-trigger") { "Sub Menu" }
      sub.content(class: "custom-content") do
        "Sub menu items"
      end
    end
    output = render(component)

    # Check trigger
    assert_includes(output, "Sub Menu")
    assert_includes(output, "custom-trigger")
    assert_includes(output, 'role="menuitem"')
    assert_includes(output, 'data-dropdown-menu-sub-target="trigger"')

    # Check content
    assert_includes(output, "Sub menu items")
    assert_includes(output, "custom-content")
    assert_includes(output, 'role="menu"')
    assert_includes(output, 'data-dropdown-menu-sub-target="content"')
  end

  def test_it_should_generate_unique_aria_id
    sub1 = ShadcnPhlexcomponents::DropdownMenuSub.new(aria_id: "test1") do |sub|
      sub.trigger { "Trigger 1" }
      sub.content { "Content 1" }
    end
    output1 = render(sub1)

    sub2 = ShadcnPhlexcomponents::DropdownMenuSub.new(aria_id: "test2") do |sub|
      sub.trigger { "Trigger 2" }
      sub.content { "Content 2" }
    end
    output2 = render(sub2)

    # Extract aria-controls values to ensure they're different
    controls1 = output1[/aria-controls="([^"]*)"/, 1]
    controls2 = output2[/aria-controls="([^"]*)"/, 1]

    refute_nil(controls1)
    refute_nil(controls2)
    refute_equal(controls1, controls2)
  end

  def test_it_should_handle_keyboard_navigation
    component = ShadcnPhlexcomponents::DropdownMenuSub.new(aria_id: "keyboard-test") do |sub|
      sub.trigger { "Keyboard Menu" }
      sub.content { "Content" }
    end
    output = render(component)

    # Check keyboard navigation actions
    assert_includes(output, 'data-action="keydown.left->dropdown-menu-sub#closeOnLeftKeydown:prevent"')
    assert_includes(output, "keydown.right->dropdown-menu-sub#open:prevent")
    assert_includes(output, "keydown.space->dropdown-menu-sub#open:prevent")
    assert_includes(output, "keydown.enter->dropdown-menu-sub#open:prevent")
    assert_includes(output, "keydown.left->dropdown-menu-sub#closeParentSubMenu")
  end

  def test_it_should_render_complete_sub_menu_structure
    component = ShadcnPhlexcomponents::DropdownMenuSub.new(
      aria_id: "complete-sub",
      class: "full-sub-menu",
    ) do |sub|
      sub.trigger(class: "sub-trigger") { "More Options" }
      sub.content(class: "sub-content", side: :right, align: :start) do
        "Sub Item 1 - Sub Item 2"
      end
    end
    output = render(component)

    # Check main container
    assert_includes(output, "full-sub-menu")
    assert_includes(output, 'data-controller="dropdown-menu-sub"')

    # Check trigger with chevron icon
    assert_includes(output, "More Options")
    assert_includes(output, "sub-trigger")
    assert_includes(output, 'aria-haspopup="menu"')
    assert_includes(output, 'data-state="closed"')

    # Check for chevron icon
    assert_match(%r{<svg[^>]*>.*</svg>}m, output)
    assert_includes(output, "ml-auto size-4")

    # Check content with positioning
    assert_includes(output, "sub-content")
    assert_includes(output, 'data-side="right"')
    assert_includes(output, 'data-align="start"')
    assert_includes(output, 'data-state="closed"')

    # Check sub items
    assert_includes(output, "Sub Item 1 - Sub Item 2")
  end
end

class TestDropdownMenuSubTrigger < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DropdownMenuSubTrigger.new(
      aria_id: "test-sub-trigger",
    ) { "Sub trigger content" }
    output = render(component)

    assert_includes(output, "Sub trigger content")
    assert_includes(output, 'data-shadcn-phlexcomponents="dropdown-menu-sub-trigger"')
    assert_includes(output, 'id="test-sub-trigger-trigger"')
    assert_includes(output, 'role="menuitem"')
    assert_includes(output, 'aria-controls="test-sub-trigger-content"')
    assert_includes(output, 'data-dropdown-menu-sub-target="trigger"')
    assert_includes(output, 'data-dropdown-menu-target="item"')
    assert_match(%r{<div[^>]*>.*Sub trigger content.*</div>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::DropdownMenuSubTrigger.new(
      aria_id: "custom-test",
      class: "custom-sub-trigger",
      id: "sub-trigger-id",
    ) { "Custom sub trigger" }
    output = render(component)

    assert_includes(output, "custom-sub-trigger")
    assert_includes(output, "sub-trigger-id") # Check that custom id is present
    assert_includes(output, 'aria-controls="custom-test-content"')
  end

  def test_it_should_include_chevron_icon
    component = ShadcnPhlexcomponents::DropdownMenuSubTrigger.new(aria_id: "chevron-test") { "Trigger with icon" }
    output = render(component)

    # Check for chevron icon
    assert_match(%r{<svg[^>]*>.*</svg>}m, output)
    assert_includes(output, "ml-auto size-4")
    # Check for chevron-right icon path
    assert_includes(output, "m9 18 6-6-6-6")
  end

  def test_it_should_include_accessibility_attributes
    component = ShadcnPhlexcomponents::DropdownMenuSubTrigger.new(aria_id: "a11y-test") { "Accessible trigger" }
    output = render(component)

    assert_includes(output, 'aria-haspopup="menu"')
    assert_includes(output, 'aria-controls="a11y-test-content"')
    assert_includes(output, 'tabindex="-1"')
    assert_includes(output, 'data-state="closed"')
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::DropdownMenuSubTrigger.new(aria_id: "action-test") { "Action trigger" }
    output = render(component)

    # Check all stimulus actions
    assert_includes(output, "focus->dropdown-menu#onItemFocus")
    assert_includes(output, "blur->dropdown-menu#onItemBlur")
    assert_includes(output, "keydown.up->dropdown-menu#focusItem:prevent")
    assert_includes(output, "keydown.down->dropdown-menu#focusItem:prevent")
    assert_includes(output, "mouseover->dropdown-menu#focusItem")
    assert_includes(output, "mouseover->dropdown-menu-sub#open")
    assert_includes(output, "click->dropdown-menu-sub#open")
    assert_includes(output, "keydown.right->dropdown-menu-sub#open:prevent")
    assert_includes(output, "keydown.space->dropdown-menu-sub#open:prevent")
    assert_includes(output, "keydown.enter->dropdown-menu-sub#open:prevent")
    assert_includes(output, "keydown.left->dropdown-menu-sub#closeParentSubMenu")
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::DropdownMenuSubTrigger.new(aria_id: "style-test") { "Styled trigger" }
    output = render(component)

    assert_includes(output, "focus:bg-accent focus:text-accent-foreground")
    assert_includes(output, "data-[state=open]:bg-accent data-[state=open]:text-accent-foreground")
    assert_includes(output, "flex cursor-default items-center rounded-sm")
    assert_includes(output, "px-2 py-1.5 text-sm outline-hidden select-none")
  end
end

class TestDropdownMenuSubContent < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DropdownMenuSubContent.new(
      aria_id: "test-sub-content",
    ) { "Sub content body" }
    output = render(component)

    assert_includes(output, "Sub content body")
    assert_includes(output, 'data-shadcn-phlexcomponents="dropdown-menu-sub-content"')
    assert_includes(output, 'id="test-sub-content-content"')
    assert_includes(output, 'role="menu"')
    assert_includes(output, 'data-dropdown-menu-sub-target="content"')
    assert_includes(output, 'data-state="closed"')
  end

  def test_it_should_handle_positioning_attributes
    component = ShadcnPhlexcomponents::DropdownMenuSubContent.new(
      aria_id: "position-test",
      side: :left,
      align: :end,
    ) { "Positioned content" }
    output = render(component)

    assert_includes(output, 'data-side="left"')
    assert_includes(output, 'data-align="end"')
  end

  def test_it_should_use_default_positioning
    component = ShadcnPhlexcomponents::DropdownMenuSubContent.new(
      aria_id: "default-test",
    ) { "Default positioned content" }
    output = render(component)

    assert_includes(output, 'data-side="right"')
    assert_includes(output, 'data-align="start"')
  end

  def test_it_should_include_accessibility_attributes
    component = ShadcnPhlexcomponents::DropdownMenuSubContent.new(aria_id: "a11y-test")
    output = render(component)

    assert_includes(output, 'aria-labelledby="a11y-test-trigger"')
    assert_includes(output, 'aria-orientation="vertical"')
    assert_includes(output, 'tabindex="-1"')
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::DropdownMenuSubContent.new(aria_id: "action-test")
    output = render(component)

    assert_includes(output, "mouseover->dropdown-menu-sub#open")
    assert_includes(output, "keydown.up->dropdown-menu-sub#focusItemByIndex:prevent:self")
    assert_includes(output, "keydown.down->dropdown-menu-sub#focusItemByIndex:prevent:self")
  end

  def test_it_should_use_content_container
    component = ShadcnPhlexcomponents::DropdownMenuSubContent.new(aria_id: "container-test")
    output = render(component)

    # Check that content is wrapped in container
    assert_includes(output, 'data-dropdown-menu-sub-target="contentContainer"')
    assert_includes(output, 'style="display: none;"')
    assert_includes(output, "fixed top-0 left-0 w-max z-50")
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::DropdownMenuSubContent.new(aria_id: "style-test")
    output = render(component)

    assert_includes(output, "bg-popover text-popover-foreground")
    assert_includes(output, "data-[state=open]:animate-in data-[state=closed]:animate-out")
    assert_includes(output, "data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0")
    assert_includes(output, "z-50 min-w-[8rem]")
    assert_includes(output, "overflow-hidden rounded-md border p-1 shadow-lg outline-none")
  end
end

class TestDropdownMenuSubContentContainer < ComponentTest
  def test_it_should_render_container
    component = ShadcnPhlexcomponents::DropdownMenuSubContentContainer.new { "Container content" }
    output = render(component)

    assert_includes(output, "Container content")
    assert_includes(output, 'data-shadcn-phlexcomponents="dropdown-menu-sub-content-container"')
    assert_includes(output, 'data-dropdown-menu-sub-target="contentContainer"')
    assert_includes(output, 'style="display: none;"')
    assert_includes(output, "fixed top-0 left-0 w-max z-50")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::DropdownMenuSubContentContainer.new(
      class: "custom-container",
      id: "container-id",
    ) { "Custom container" }
    output = render(component)

    assert_includes(output, "custom-container")
    assert_includes(output, 'id="container-id"')
  end
end

class TestDropdownMenuSubWithCustomConfiguration < ComponentTest
  def test_dropdown_menu_sub_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.dropdown_menu_sub = {
      trigger: { base: "custom-sub-trigger-base" },
      content: { base: "custom-sub-content-base" },
      content_container: { base: "custom-sub-content-container-base" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    sub_classes = [
      "DropdownMenuSubContentContainer",
      "DropdownMenuSubContent",
      "DropdownMenuSubTrigger",
      "DropdownMenuSub",
    ]

    sub_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/dropdown_menu_sub.rb", __dir__))

    # Test components with custom configuration
    trigger = ShadcnPhlexcomponents::DropdownMenuSubTrigger.new(aria_id: "test") { "Test" }
    assert_includes(render(trigger), "custom-sub-trigger-base")

    content = ShadcnPhlexcomponents::DropdownMenuSubContent.new(aria_id: "test") { "Content" }
    assert_includes(render(content), "custom-sub-content-base")

    container = ShadcnPhlexcomponents::DropdownMenuSubContentContainer.new { "Container" }
    assert_includes(render(container), "custom-sub-content-container-base")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    sub_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/dropdown_menu_sub.rb", __dir__))
  end
end

class TestDropdownMenuSubIntegration < ComponentTest
  def test_complete_dropdown_menu_sub_workflow
    component = ShadcnPhlexcomponents::DropdownMenuSub.new(
      aria_id: "admin-sub",
      class: "admin-submenu",
      data: { controller: "dropdown-menu-sub analytics", analytics_category: "admin-actions" },
    ) do |sub|
      sub.trigger(class: "admin-trigger") { "⚙️ Admin Tools" }
      sub.content(class: "admin-content", side: :right, align: :start) do
        "👥 User Management - 📊 Analytics - 🔧 System Settings"
      end
    end

    output = render(component)

    # Check main structure
    assert_includes(output, "admin-submenu")
    # Controller merging may include spaces
    assert_match(/data-controller="[^"]*dropdown-menu-sub[^"]*analytics[^"]*"/, output)
    assert_includes(output, 'data-analytics-category="admin-actions"')

    # Check trigger with emoji
    assert_includes(output, "⚙️ Admin Tools")
    assert_includes(output, "admin-trigger")
    assert_includes(output, 'aria-haspopup="menu"')

    # Check content positioning
    assert_includes(output, "admin-content")
    assert_includes(output, 'data-side="right"')
    assert_includes(output, 'data-align="start"')

    # Check admin items with emojis
    assert_includes(output, "👥 User Management - 📊 Analytics - 🔧 System Settings")

    # Check keyboard navigation
    assert_includes(output, "keydown.left->dropdown-menu-sub#closeOnLeftKeydown:prevent")
    assert_includes(output, "keydown.right->dropdown-menu-sub#open:prevent")

    # Check chevron icon
    assert_match(%r{<svg[^>]*>.*</svg>}m, output)
    assert_includes(output, "ml-auto size-4")
  end

  def test_dropdown_menu_sub_accessibility_features
    component = ShadcnPhlexcomponents::DropdownMenuSub.new(
      aria_id: "accessible-sub",
      aria: { label: "Submenu options", describedby: "submenu-help" },
    ) do |sub|
      sub.trigger(aria: { labelledby: "submenu-label" }) { "Accessible Sub Trigger" }
      sub.content do
        "Accessible Item 1 - Accessible Item 2"
      end
    end

    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'aria-label="Submenu options"')
    assert_includes(output, 'aria-describedby="submenu-help"')
    assert_includes(output, 'aria-labelledby="submenu-label"')

    # Check ARIA roles and relationships
    assert_includes(output, 'role="menuitem"') # trigger
    assert_includes(output, 'role="menu"') # content
    assert_includes(output, 'aria-haspopup="menu"')
    assert_match(/aria-controls="[^"]*-content"/, output)
    assert_match(/aria-labelledby="[^"]*-trigger"/, output)
    assert_includes(output, 'aria-orientation="vertical"')
  end

  def test_dropdown_menu_sub_stimulus_integration
    component = ShadcnPhlexcomponents::DropdownMenuSub.new(
      aria_id: "stimulus-sub",
      data: {
        controller: "dropdown-menu-sub custom-submenu",
        custom_submenu_delay_value: "300",
      },
    ) do |sub|
      sub.trigger(
        data: { action: "hover->custom-submenu#delayedOpen" },
      ) { "Stimulus Sub Trigger" }

      sub.content do
        "Custom Sub Item"
      end
    end

    output = render(component)

    # Check multiple controllers
    assert_match(/data-controller="[^"]*dropdown-menu-sub[^"]*custom-submenu[^"]*"/, output)
    assert_includes(output, 'data-custom-submenu-delay-value="300"')

    # Check custom actions
    assert_match(/hover->custom-submenu#delayedOpen/, output)

    # Check default dropdown-menu-sub actions still work
    assert_match(/mouseover->dropdown-menu-sub#open/, output)
    assert_match(/keydown.left->dropdown-menu-sub#closeOnLeftKeydown:prevent/, output)
    assert_match(/keydown.right->dropdown-menu-sub#open:prevent/, output)
  end

  def test_nested_dropdown_menu_sub_structure
    component = ShadcnPhlexcomponents::DropdownMenuSub.new(
      aria_id: "nested-sub",
    ) do |sub|
      sub.trigger { "📁 File Operations" }
      sub.content do
        "📄 New File - 📁 New Folder - 🔗 Import ▶"
      end
    end

    output = render(component)

    # Check main trigger
    assert_includes(output, "📁 File Operations")

    # Check content items
    assert_includes(output, "📄 New File - 📁 New Folder - 🔗 Import ▶")

    # Check positioning and navigation
    assert_includes(output, 'data-side="right"')
    assert_includes(output, 'data-align="start"')
    assert_includes(output, "keydown.up->dropdown-menu-sub#focusItemByIndex:prevent:self")
    assert_includes(output, "keydown.down->dropdown-menu-sub#focusItemByIndex:prevent:self")
  end
end
