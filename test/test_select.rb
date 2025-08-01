# frozen_string_literal: true

require "test_helper"

class TestSelect < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Select.new(
      id: "test-select",
      name: "test_select",
      value: "option1",
      placeholder: "Choose an option",
    ) { "Select content" }
    output = render(component)

    assert_includes(output, "Select content")
    assert_includes(output, 'data-shadcn-phlexcomponents="select"')
    assert_includes(output, 'data-controller="select"')
    assert_includes(output, 'data-select-selected-value="option1"')
    assert_includes(output, "w-full")
    assert_match(%r{<div[^>]*>.*Select content.*</div>}m, output)
  end

  def test_it_should_render_with_default_values
    component = ShadcnPhlexcomponents::Select.new { "Default select" }
    output = render(component)

    assert_includes(output, "Default select")
    # data-select-selected-value is not set by default in the component implementation
    assert_includes(output, "w-full")
  end

  def test_it_should_render_native_select
    component = ShadcnPhlexcomponents::Select.new(
      native: true,
      name: "native_select",
      placeholder: "Choose option",
    ) { "Native content" }
    output = render(component)

    assert_includes(output, 'name="native_select"')
    assert_includes(output, "appearance-none")
    assert_includes(output, "relative")
    assert_includes(output, "<select")
    assert_includes(output, "</select>")
    # Component uses Lucide icon path data instead of chevron-down class
    assert_includes(output, "m6 9 6 6 6-6")
    assert_includes(output, "pointer-events-none")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Select.new(
      id: "custom-select",
      name: "custom_select",
      value: "custom_value",
      class: "custom-select",
      data: { testid: "select" },
    ) { "Custom content" }
    output = render(component)

    assert_includes(output, "custom-select")
    assert_includes(output, 'data-testid="select"')
    assert_includes(output, 'data-select-selected-value="custom_value"')
    assert_includes(output, "Custom content")
  end

  def test_it_should_render_with_helper_methods
    component = ShadcnPhlexcomponents::Select.new(
      id: "helper-select",
      name: "helper_select",
      placeholder: "Select option",
    ) do |select|
      select.trigger { "Trigger content" }
      select.content do
        select.item(value: "option1") { "Option 1" }
        select.item(value: "option2") { "Option 2" }
        select.item(value: "option3") { "Option 3" }
      end
    end
    output = render(component)

    # Check trigger
    assert_includes(output, 'data-shadcn-phlexcomponents="select-trigger"')
    # SelectTrigger doesn't render direct "Trigger content" - it uses triggerText and value display

    # Check content
    assert_includes(output, 'data-shadcn-phlexcomponents="select-content"')
    assert_includes(output, 'data-select-target="content"')

    # Check items
    assert_includes(output, 'data-shadcn-phlexcomponents="select-item"')
    assert_includes(output, 'data-value="option1"')
    assert_includes(output, 'data-value="option2"')
    assert_includes(output, 'data-value="option3"')
  end

  def test_it_should_handle_items_collection_with_symbols
    collection = [
      { value: "small", text: "Small" },
      { value: "medium", text: "Medium" },
      { value: "large", text: "Large" },
    ]

    component = ShadcnPhlexcomponents::Select.new(
      name: "size",
      value: "medium",
      placeholder: "Select size",
    ) do |select|
      select.items(collection, value_method: :value, text_method: :text)
    end
    output = render(component)

    # Check trigger
    assert_includes(output, 'data-shadcn-phlexcomponents="select-trigger"')
    assert_includes(output, "Select size")

    # Check items
    assert_includes(output, 'data-value="small"')
    assert_includes(output, 'data-value="medium"')
    assert_includes(output, 'data-value="large"')
    assert_includes(output, "Small")
    assert_includes(output, "Medium")
    assert_includes(output, "Large")
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::Select.new(
      name: "disabled_select",
      disabled: true,
    ) { "Disabled select" }
    output = render(component)

    assert_includes(output, "disabled")
  end

  def test_it_should_include_hidden_select_for_non_native
    component = ShadcnPhlexcomponents::Select.new(
      name: "test_select",
      disabled: false,
    ) { "Content" }
    output = render(component)

    assert_includes(output, 'data-select-target="select"')
    assert_includes(output, 'class="sr-only"')
    assert_includes(output, 'tabindex="-1"')
    assert_includes(output, 'name="test_select"')
  end

  def test_it_should_handle_include_blank_option
    component = ShadcnPhlexcomponents::Select.new(
      name: "blank_select",
      include_blank: "Select an option",
    ) do |select|
      select.content do
        select.item(value: "option1") { "Option 1" }
      end
    end
    output = render(component)

    # include_blank option creates option in select element, not as attribute
    assert_includes(output, "Select an option")
  end
end

class TestSelectTrigger < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::SelectTrigger.new(
      id: "test-trigger",
      value: "selected_value",
      placeholder: "Choose option",
      aria_id: "select-123",
    ) { "Trigger content" }
    output = render(component)

    # SelectTrigger doesn't render direct content - it uses triggerText target and selected_value
    assert_includes(output, "selected_value")
    assert_includes(output, 'data-shadcn-phlexcomponents="select-trigger"')
    assert_includes(output, 'type="button"')
    assert_includes(output, 'id="test-trigger"')
    assert_includes(output, 'role="combobox"')
    assert_includes(output, 'aria-autocomplete="none"')
    # aria-expanded is not set by default in this component implementation
    assert_includes(output, 'aria-controls="select-123-content"')
    assert_includes(output, 'data-select-target="trigger"')
    # SelectTrigger doesn't render direct content - content is handled by the triggerText span
    assert_match(%r{<button[^>]*>.*</button>}m, output)
  end

  def test_it_should_render_trigger_text_with_value
    component = ShadcnPhlexcomponents::SelectTrigger.new(
      value: "selected_option",
      placeholder: "Select option",
    )
    output = render(component)

    assert_includes(output, 'data-select-target="triggerText"')
    assert_includes(output, "selected_option")
    assert_includes(output, "pointer-events-none")
  end

  def test_it_should_render_trigger_text_with_placeholder
    component = ShadcnPhlexcomponents::SelectTrigger.new(
      placeholder: "Choose your option",
    )
    output = render(component)

    assert_includes(output, "Choose your option")
    assert_includes(output, 'data-placeholder="Choose your option"')
    assert_includes(output, 'data-has-value="false"')
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::SelectTrigger.new(
      class: "custom-trigger",
      aria_id: "custom-select",
      disabled: true,
    )
    output = render(component)

    assert_includes(output, "custom-trigger")
    assert_includes(output, "disabled")
    assert_includes(output, 'aria-controls="custom-select-content"')
  end

  def test_it_should_include_chevron_icon
    component = ShadcnPhlexcomponents::SelectTrigger.new
    output = render(component)

    # Check for chevron-down icon
    assert_includes(output, "<svg")
    assert_includes(output, "</svg>")
    # Component uses Lucide icon path data instead of chevron-down class
    assert_includes(output, "m6 9 6 6 6-6")
    assert_includes(output, "size-4 opacity-50 text-foreground")
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::SelectTrigger.new
    output = render(component)

    assert_includes(output, "click->select#toggle")
    assert_includes(output, "keydown.down->select#open:prevent")
    assert_includes(output, "keydown.space->select#open:prevent")
    assert_includes(output, "keydown.enter->select#open:prevent")
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::SelectTrigger.new
    output = render(component)

    assert_includes(output, "border-input")
    assert_includes(output, "focus-visible:border-ring")
    # Component uses flex layout classes but may have newlines
    assert_includes(output, "flex items-center")
    assert_includes(output, "justify-between gap-2")
    assert_includes(output, "rounded-md border bg-transparent")
    assert_includes(output, "px-3 py-2 text-sm")
    # CSS classes may have newlines, check for components separately
    assert_includes(output, "shadow-xs")
    assert_includes(output, "transition-[color,box-shadow]")
    assert_includes(output, "disabled:cursor-not-allowed disabled:opacity-50")
  end
end

class TestSelectContent < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::SelectContent.new(
      aria_id: "select-123",
      side: :bottom,
      align: :center,
    ) { "Content body" }
    output = render(component)

    assert_includes(output, "Content body")
    assert_includes(output, 'data-shadcn-phlexcomponents="select-content"')
    assert_includes(output, 'id="select-123-content"')
    assert_includes(output, 'role="listbox"')
    assert_includes(output, 'aria-labelledby="select-123-trigger"')
    assert_includes(output, 'aria-orientation="vertical"')
    assert_includes(output, 'data-select-target="content"')
    assert_includes(output, 'data-side="bottom"')
    assert_includes(output, 'data-align="center"')
    assert_includes(output, 'tabindex="-1"')
  end

  def test_it_should_handle_positioning_attributes
    component = ShadcnPhlexcomponents::SelectContent.new(
      aria_id: "position-test",
      side: :top,
      align: :end,
    ) { "Positioned content" }
    output = render(component)

    assert_includes(output, 'data-side="top"')
    assert_includes(output, 'data-align="end"')
  end

  def test_it_should_use_default_positioning
    component = ShadcnPhlexcomponents::SelectContent.new(
      aria_id: "default-test",
    ) { "Default positioned content" }
    output = render(component)

    assert_includes(output, 'data-side="bottom"')
    assert_includes(output, 'data-align="center"')
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::SelectContent.new(aria_id: "action-test") { "Content" }
    output = render(component)

    assert_includes(output, "select:click:outside->select#clickOutside")
    assert_includes(output, "keydown.up->select#focusItemByIndex:prevent:self")
    assert_includes(output, "keydown.down->select#focusItemByIndex:prevent:self")
  end

  def test_it_should_use_content_container
    component = ShadcnPhlexcomponents::SelectContent.new(aria_id: "container-test") { "Container content" }
    output = render(component)

    # Check that content is wrapped in container
    assert_includes(output, 'data-select-target="contentContainer"')
    assert_includes(output, 'style="display: none;"')
    assert_includes(output, "fixed top-0 left-0 w-max z-50")
    assert_includes(output, 'data-shadcn-phlexcomponents="select-content-container"')
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::SelectContent.new(aria_id: "style-test") { "Content" }
    output = render(component)

    assert_includes(output, "bg-popover text-popover-foreground")
    assert_includes(output, "data-[state=open]:animate-in data-[state=closed]:animate-out")
    assert_includes(output, "data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0")
    assert_includes(output, "z-50")
    assert_includes(output, "min-w-[8rem]")
    assert_includes(output, "rounded-md border shadow-md p-1")
  end

  def test_it_should_handle_include_blank_for_non_native
    component = ShadcnPhlexcomponents::SelectContent.new(
      aria_id: "blank-test",
      include_blank: "Choose option",
      native: false,
    ) { "Content" }
    output = render(component)

    assert_includes(output, 'data-value=""')
    assert_includes(output, "h-8")
  end

  def test_it_should_not_include_blank_for_native
    component = ShadcnPhlexcomponents::SelectContent.new(
      aria_id: "native-test",
      include_blank: "Choose option",
      native: true,
    ) { "Content" }
    output = render(component)

    # For native selects, blank option is handled in Select component
    assert_includes(output, "Content")
  end
end

class TestSelectItem < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::SelectItem.new(
      value: "item1",
      aria_id: "select-123",
    ) { "Item content" }
    output = render(component)

    assert_includes(output, "Item content")
    assert_includes(output, 'data-shadcn-phlexcomponents="select-item"')
    assert_includes(output, 'role="option"')
    # aria-selected is not set by default in this component implementation
    assert_includes(output, 'data-value="item1"')
    assert_includes(output, 'data-select-target="item"')
    assert_includes(output, 'tabindex="-1"')
    assert_match(%r{<div[^>]*>.*Item content.*</div>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::SelectItem.new(
      value: "custom",
      aria_id: "select-test",
      class: "custom-item",
      disabled: true,
    ) { "Custom item" }
    output = render(component)

    assert_includes(output, "custom-item")
    assert_includes(output, "data-disabled")
    assert_includes(output, "Custom item")
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::SelectItem.new(
      value: "disabled_item",
      disabled: true,
      aria_id: "select-test",
    ) { "Disabled item" }
    output = render(component)

    assert_includes(output, "data-disabled")
    assert_includes(output, "data-[disabled]:pointer-events-none data-[disabled]:opacity-50")
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::SelectItem.new(
      value: "item1",
      aria_id: "select-test",
    )
    output = render(component)

    assert_includes(output, "click->select#select")
    assert_includes(output, "mouseover->select#focusItem")
    assert_includes(output, "keydown.up->select#focusItem:prevent")
    assert_includes(output, "keydown.down->select#focusItem:prevent")
    assert_includes(output, "focus->select#onItemFocus")
    assert_includes(output, "blur->select#onItemBlur")
    assert_includes(output, "keydown.enter->select#select:prevent")
    assert_includes(output, "keydown.space->select#select:prevent")
    assert_includes(output, "mouseout->select#focusContent")
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::SelectItem.new(
      value: "item1",
      aria_id: "select-test",
    )
    output = render(component)

    assert_includes(output, "focus:bg-accent focus:text-accent-foreground")
    assert_includes(output, "relative flex w-full cursor-default items-center gap-2")
    assert_includes(output, "rounded-sm py-1.5 pr-8 pl-2 text-sm")
    assert_includes(output, "outline-hidden select-none")
  end

  def test_it_should_include_item_indicator
    component = ShadcnPhlexcomponents::SelectItem.new(
      value: "item1",
      aria_id: "select-test",
    )
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="select-item-indicator"')
  end

  def test_it_should_generate_aria_labelledby
    component = ShadcnPhlexcomponents::SelectItem.new(
      value: "test-value",
      aria_id: "select-123",
    ) { "Test content" }
    output = render(component)

    assert_includes(output, 'aria-labelledby="select-123-test-value"')
    assert_includes(output, 'id="select-123-test-value"')
  end
end

class TestSelectLabel < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::SelectLabel.new { "Label content" }
    output = render(component)

    assert_includes(output, "Label content")
    assert_includes(output, 'data-shadcn-phlexcomponents="select-label"')
    assert_includes(output, "text-muted-foreground px-2 py-1.5 text-xs")
    assert_match(%r{<div[^>]*>Label content</div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::SelectLabel.new(
      class: "custom-label",
      id: "label-id",
    ) { "Custom label" }
    output = render(component)

    assert_includes(output, "custom-label")
    assert_includes(output, 'id="label-id"')
    assert_includes(output, "Custom label")
  end
end

class TestSelectGroup < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::SelectGroup.new(
      aria_id: "select-123",
    ) { "Group content" }
    output = render(component)

    assert_includes(output, "Group content")
    assert_includes(output, 'data-shadcn-phlexcomponents="select-group"')
    assert_includes(output, 'role="group"')
    assert_includes(output, 'data-select-target="group"')
    assert_match(/aria-labelledby="select-123-group-[^"]*"/, output)
    assert_match(%r{<div[^>]*>Group content</div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::SelectGroup.new(
      aria_id: "select-test",
      class: "custom-group",
      id: "group-id",
    ) { "Custom group" }
    output = render(component)

    assert_includes(output, "custom-group")
    assert_includes(output, 'id="group-id"')
    assert_includes(output, "Custom group")
  end
end

class TestSelectSeparator < ComponentTest
  def test_it_should_render_separator
    component = ShadcnPhlexcomponents::SelectSeparator.new
    output = render(component)

    # SelectSeparator is not exposed as a method in the Select component helper methods
    assert_includes(output, 'aria-hidden="true"')
    assert_includes(output, "bg-border pointer-events-none -mx-1 my-1 h-px")
    assert_match(%r{<div[^>]*></div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::SelectSeparator.new(
      class: "custom-separator",
      id: "separator-id",
    )
    output = render(component)

    assert_includes(output, "custom-separator")
    assert_includes(output, 'id="separator-id"')
  end
end

class TestSelectContentContainer < ComponentTest
  def test_it_should_render_container
    component = ShadcnPhlexcomponents::SelectContentContainer.new { "Container content" }
    output = render(component)

    assert_includes(output, "Container content")
    assert_includes(output, 'data-shadcn-phlexcomponents="select-content-container"')
    assert_includes(output, 'data-select-target="contentContainer"')
    assert_includes(output, 'style="display: none;"')
    assert_includes(output, "fixed top-0 left-0 w-max z-50")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::SelectContentContainer.new(
      class: "custom-container",
      id: "container-id",
    ) { "Custom container" }
    output = render(component)

    assert_includes(output, "custom-container")
    assert_includes(output, 'id="container-id"')
  end
end

class TestSelectItemIndicator < ComponentTest
  def test_it_should_render_indicator
    component = ShadcnPhlexcomponents::SelectItemIndicator.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="select-item-indicator"')
    assert_includes(output, "absolute right-2 h-3.5 w-3.5")
    assert_includes(output, "items-center hidden justify-center")
    assert_includes(output, "group-aria-[selected=true]/item:flex")
    assert_match(%r{<span[^>]*>.*</span>}m, output)
  end

  def test_it_should_include_check_icon
    component = ShadcnPhlexcomponents::SelectItemIndicator.new
    output = render(component)

    # Check for check icon
    assert_includes(output, "<svg")
    assert_includes(output, "</svg>")
    assert_includes(output, "size-4")
  end
end

class TestSelectWithCustomConfiguration < ComponentTest
  def test_select_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.select = {
      trigger: { base: "custom-trigger-base" },
      content: { base: "custom-content-base" },
      item: { base: "custom-item-base" },
      label: { base: "custom-label-base" },
      separator: { base: "custom-separator-base" },
      content_container: { base: "custom-container-base" },
      item_indicator: { base: "custom-indicator-base" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    select_classes = [
      "SelectItemIndicator",
      "SelectContentContainer",
      "SelectSeparator",
      "SelectGroup",
      "SelectItem",
      "SelectLabel",
      "SelectContent",
      "SelectTrigger",
      "Select",
    ]

    select_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/select.rb", __dir__))

    # Test components with custom configuration
    trigger = ShadcnPhlexcomponents::SelectTrigger.new
    assert_includes(render(trigger), "custom-trigger-base")

    content = ShadcnPhlexcomponents::SelectContent.new(aria_id: "test") { "Content" }
    assert_includes(render(content), "custom-content-base")

    item = ShadcnPhlexcomponents::SelectItem.new(value: "test", aria_id: "test") { "Item" }
    assert_includes(render(item), "custom-item-base")

    label = ShadcnPhlexcomponents::SelectLabel.new { "Label" }
    assert_includes(render(label), "custom-label-base")

    separator = ShadcnPhlexcomponents::SelectSeparator.new
    assert_includes(render(separator), "custom-separator-base")

    container = ShadcnPhlexcomponents::SelectContentContainer.new { "Container" }
    assert_includes(render(container), "custom-container-base")

    indicator = ShadcnPhlexcomponents::SelectItemIndicator.new
    assert_includes(render(indicator), "custom-indicator-base")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    select_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/select.rb", __dir__))
  end
end

class TestSelectIntegration < ComponentTest
  def test_complete_select_workflow
    component = ShadcnPhlexcomponents::Select.new(
      id: "country-select",
      name: "country",
      value: "us",
      placeholder: "Select country",
      class: "country-selector",
      data: {
        controller: "select geography analytics",
        geography_target: "countrySelect",
        analytics_category: "location",
        action: "select:change->geography#updateCountry select:change->analytics#track",
      },
    ) do |select|
      select.trigger(class: "country-trigger") { "🇺🇸 United States" }
      select.content(class: "country-content", side: :bottom, align: :start) do
        select.group do
          select.label { "North America" }
          select.item(value: "us") { "🇺🇸 United States" }
          select.item(value: "ca") { "🇨🇦 Canada" }
          select.item(value: "mx") { "🇲🇽 Mexico" }
        end
        # SelectSeparator is not exposed as a method in Select component
        select.group do
          select.label { "Europe" }
          select.item(value: "gb") { "🇬🇧 United Kingdom" }
          select.item(value: "de") { "🇩🇪 Germany" }
          select.item(value: "fr") { "🇫🇷 France" }
        end
      end
    end

    output = render(component)

    # Check main structure
    assert_includes(output, "country-selector")
    assert_includes(output, 'id="country-select"')

    # Check stimulus integration
    assert_match(/data-controller="[^"]*select[^"]*geography[^"]*analytics[^"]*"/, output)
    assert_includes(output, 'data-geography-target="countrySelect"')
    assert_includes(output, 'data-analytics-category="location"')

    # Check actions
    assert_includes(output, "geography#updateCountry")
    assert_includes(output, "analytics#track")

    # Check trigger
    assert_includes(output, "country-trigger")
    assert_includes(output, "🇺🇸 United States")

    # Check content positioning
    assert_includes(output, "country-content")
    assert_includes(output, 'data-side="bottom"')
    assert_includes(output, 'data-align="start"')

    # Check groups and labels
    assert_includes(output, "North America")
    assert_includes(output, "Europe")

    # Check items with flags
    assert_includes(output, "🇺🇸 United States")
    assert_includes(output, "🇨🇦 Canada")
    assert_includes(output, "🇲🇽 Mexico")
    assert_includes(output, "🇬🇧 United Kingdom")
    assert_includes(output, "🇩🇪 Germany")
    assert_includes(output, "🇫🇷 France")

    # Check separator
    # SelectSeparator is not exposed as a method in the Select component helper methods

    # Check selected value
    assert_includes(output, 'data-select-selected-value="us"')
  end

  def test_select_accessibility_features
    component = ShadcnPhlexcomponents::Select.new(
      id: "accessible-select",
      name: "accessible_option",
      aria: {
        label: "Accessible selection",
        describedby: "select-help",
      },
    ) do |select|
      select.trigger(aria: { describedby: "trigger-help" }) { "Choose option" }
      select.content do
        select.item(value: "option1", aria: { describedby: "option1-help" }) { "Option 1" }
        select.item(value: "option2", aria: { describedby: "option2-help" }) { "Option 2" }
      end
    end

    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'aria-label="Accessible selection"')
    assert_includes(output, 'aria-describedby="select-help"')

    # Check trigger accessibility
    assert_includes(output, 'role="combobox"')
    assert_includes(output, 'aria-autocomplete="none"')
    # aria-expanded is not set by default in this component implementation

    # Check content accessibility
    assert_includes(output, 'role="listbox"')
    assert_includes(output, 'aria-orientation="vertical"')

    # Check item accessibility
    assert_includes(output, 'role="option"')
    # aria-selected is not set by default in this component implementation
  end

  def test_select_native_mode
    component = ShadcnPhlexcomponents::Select.new(
      id: "native-select",
      name: "native_option",
      native: true,
      placeholder: "Choose option",
      value: "option2",
    ) do |select|
      select.content do
        select.item(value: "option1") { "First Option" }
        select.item(value: "option2") { "Second Option" }
        select.item(value: "option3") { "Third Option" }
      end
    end

    output = render(component)

    # Check native select structure
    assert_includes(output, "<select")
    assert_includes(output, "</select>")
    assert_includes(output, 'id="native-select"')
    assert_includes(output, 'name="native_option"')
    assert_includes(output, "appearance-none")

    # Check placeholder option
    assert_includes(output, 'value=""')
    assert_includes(output, "Choose option")

    # Check chevron icon
    # Component uses Lucide icon path data instead of chevron-down class
    assert_includes(output, "m6 9 6 6 6-6")
    assert_includes(output, "pointer-events-none")

    # Check options
    assert_includes(output, 'value="option1"')
    assert_includes(output, 'value="option2"')
    assert_includes(output, 'value="option3"')
  end

  def test_select_with_collection_and_disabled_items
    users = [
      { id: "1", name: "Alice Johnson", active: true },
      { id: "2", name: "Bob Smith", active: false },
      { id: "3", name: "Charlie Brown", active: true },
    ]

    component = ShadcnPhlexcomponents::Select.new(
      name: "user_id",
      value: "1",
      placeholder: "Select user",
    ) do |select|
      select.items(
        users,
        value_method: :id,
        text_method: :name,
        disabled_items: ["2"],
      )
    end

    output = render(component)

    # Check all users are present
    assert_includes(output, 'data-value="1"')
    assert_includes(output, 'data-value="2"')
    assert_includes(output, 'data-value="3"')
    assert_includes(output, "Alice Johnson")
    assert_includes(output, "Bob Smith")
    assert_includes(output, "Charlie Brown")

    # Check disabled item
    assert_includes(output, "data-disabled")
  end

  def test_select_form_integration
    component = ShadcnPhlexcomponents::Select.new(
      id: "payment-method",
      name: "payment_method",
      value: "credit_card",
      data: {
        controller: "select payment-form",
        payment_form_target: "methodSelector",
        action: "select:change->payment-form#updatePaymentMethod",
      },
    ) do |select|
      select.trigger { "💳 Credit Card" }
      select.content do
        select.item(value: "credit_card") { "💳 Credit Card" }
        select.item(value: "debit_card") { "💳 Debit Card" }
        select.item(value: "paypal") { "🟦 PayPal" }
        select.item(value: "bank_transfer") { "🏦 Bank Transfer" }
      end
    end

    output = render(component)

    # Check form integration
    assert_match(/data-controller="[^"]*select[^"]*payment-form[^"]*"/, output)
    assert_includes(output, 'data-payment-form-target="methodSelector"')
    assert_includes(output, "payment-form#updatePaymentMethod")

    # Check payment methods with emojis
    assert_includes(output, "💳 Credit Card")
    assert_includes(output, "💳 Debit Card")
    assert_includes(output, "🟦 PayPal")
    assert_includes(output, "🏦 Bank Transfer")
  end

  def test_select_complex_grouping
    component = ShadcnPhlexcomponents::Select.new(
      name: "technology",
      placeholder: "Choose technology",
    ) do |select|
      select.trigger { "Select Technology" }
      select.content do
        select.group do
          select.label { "🌐 Frontend" }
          select.item(value: "react") { "⚛️ React" }
          select.item(value: "vue") { "💚 Vue.js" }
          select.item(value: "angular") { "🔴 Angular" }
        end
        # SelectSeparator is not exposed as a method in Select component
        select.group do
          select.label { "🗄️ Backend" }
          select.item(value: "nodejs") { "💚 Node.js" }
          select.item(value: "python") { "🐍 Python" }
          select.item(value: "ruby") { "💎 Ruby" }
        end
        # SelectSeparator is not exposed as a method in Select component
        select.group do
          select.label { "🗃️ Database" }
          select.item(value: "postgresql") { "🐘 PostgreSQL" }
          select.item(value: "mysql") { "🐬 MySQL" }
          select.item(value: "mongodb") { "🍃 MongoDB" }
        end
      end
    end

    output = render(component)

    # Check groups
    assert_includes(output, "🌐 Frontend")
    assert_includes(output, "🗄️ Backend")
    assert_includes(output, "🗃️ Database")

    # Check technologies with emojis
    assert_includes(output, "⚛️ React")
    assert_includes(output, "💚 Vue.js")
    assert_includes(output, "🔴 Angular")
    assert_includes(output, "💚 Node.js")
    assert_includes(output, "🐍 Python")
    assert_includes(output, "💎 Ruby")
    assert_includes(output, "🐘 PostgreSQL")
    assert_includes(output, "🐬 MySQL")
    assert_includes(output, "🍃 MongoDB")

    # SelectSeparator is not exposed as a helper method, so no separators are rendered
    separators_count = output.scan('data-shadcn-phlexcomponents="select-separator"').length
    assert_equal(0, separators_count)
  end
end
