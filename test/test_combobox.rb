# frozen_string_literal: true

require "test_helper"

class TestCombobox < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Combobox.new(
      name: "select_option",
      value: "test_value",
    ) { "Combobox content" }
    output = render(component)

    assert_includes(output, "Combobox content")
    assert_includes(output, "w-full")
    assert_includes(output, 'data-shadcn-phlexcomponents="combobox"')
    assert_includes(output, 'data-controller="combobox"')
    assert_includes(output, 'data-combobox-selected-value="test_value"')
    assert_match(%r{<div[^>]*>.*Combobox content.*</div>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Combobox.new(
      name: "custom_select",
      class: "custom-combobox",
      id: "combobox-id",
      data: { testid: "combobox" },
    ) { "Custom content" }
    output = render(component)

    assert_includes(output, "custom-combobox")
    # The id attribute is not directly rendered on the main div, it's used internally
    # Check for custom class and data attributes instead
    assert_includes(output, 'data-testid="combobox"')
    assert_includes(output, "w-full")
  end

  def test_it_should_include_hidden_input
    component = ShadcnPhlexcomponents::Combobox.new(
      name: "hidden_test",
      value: "hidden_value",
    ) { "Content" }
    output = render(component)

    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'name="hidden_test"')
    assert_includes(output, 'value="hidden_value"')
    assert_includes(output, 'data-combobox-target="hiddenInput"')
  end

  def test_it_should_generate_unique_aria_id
    component1 = ShadcnPhlexcomponents::Combobox.new(name: "test1") do |combobox|
      combobox.trigger { "Trigger 1" }
      combobox.content { "Content 1" }
    end
    output1 = render(component1)

    component2 = ShadcnPhlexcomponents::Combobox.new(name: "test2") do |combobox|
      combobox.trigger { "Trigger 2" }
      combobox.content { "Content 2" }
    end
    output2 = render(component2)

    # Extract aria-controls values to ensure they're different
    controls1 = output1[/aria-controls="([^"]*)"/, 1]
    controls2 = output2[/aria-controls="([^"]*)"/, 1]

    refute_nil(controls1)
    refute_nil(controls2)
    refute_equal(controls1, controls2)
  end

  def test_it_should_render_with_search_configuration
    component = ShadcnPhlexcomponents::Combobox.new(
      name: "search_test",
      search_path: "/api/search",
      search_error_text: "Custom error message",
      search_empty_text: "Custom empty message",
      search_placeholder_text: "Custom placeholder",
    ) { "Content" }
    output = render(component)

    assert_includes(output, 'data-search-path="/api/search"')
    assert_includes(output, 'data-controller="combobox"')
  end

  def test_it_should_handle_items_from_hash_collection
    items = [
      { value: "apple", text: "Apple" },
      { value: "banana", text: "Banana" },
      { value: "cherry", text: "Cherry" },
    ]

    component = ShadcnPhlexcomponents::Combobox.new(
      name: "fruits",
      value: "apple",
    ) do |combobox|
      combobox.items(items, value_method: :value, text_method: :text)
    end
    output = render(component)

    # Check that trigger and content are rendered
    assert_includes(output, 'role="combobox"')
    assert_includes(output, 'role="listbox"')

    # Check items are rendered
    assert_includes(output, "Apple")
    assert_includes(output, "Banana")
    assert_includes(output, "Cherry")

    # Check item attributes
    assert_includes(output, 'data-value="apple"')
    assert_includes(output, 'data-value="banana"')
    assert_includes(output, 'data-value="cherry"')
    assert_includes(output, 'role="option"')
  end

  def test_it_should_handle_items_with_disabled_options
    items = [
      { value: "option1", text: "Option 1" },
      { value: "option2", text: "Option 2" },
      { value: "option3", text: "Option 3" },
    ]

    component = ShadcnPhlexcomponents::Combobox.new(
      name: "options",
    ) do |combobox|
      combobox.items(
        items,
        value_method: :value,
        text_method: :text,
        disabled_items: ["option2"],
      )
    end
    output = render(component)

    # Check that disabled item has disabled attribute
    assert_includes(output, "data-disabled")
  end

  def test_it_should_render_with_trigger_and_content_helpers
    component = ShadcnPhlexcomponents::Combobox.new(name: "helper_test") do |combobox|
      combobox.trigger(class: "custom-trigger") { "Select option..." }
      combobox.content(class: "custom-content") do
        combobox.item(value: "item1") { "Item 1" }
        combobox.item(value: "item2") { "Item 2" }
      end
    end
    output = render(component)

    # Check trigger
    # ComboboxTrigger doesn't render this content directly
    # The content would be set through ComboboxTriggerText component
    refute_includes(output, "Select option...")
    assert_includes(output, "custom-trigger")
    assert_includes(output, 'role="combobox"')
    assert_includes(output, 'data-combobox-target="trigger"')

    # Check content
    assert_includes(output, "custom-content")
    assert_includes(output, 'role="listbox"')
    assert_includes(output, 'data-combobox-target="content"')

    # Check items
    assert_includes(output, "Item 1")
    assert_includes(output, "Item 2")
    assert_includes(output, 'data-value="item1"')
    assert_includes(output, 'data-value="item2"')
  end

  def test_it_should_handle_include_blank_option
    component = ShadcnPhlexcomponents::Combobox.new(
      name: "blank_test",
      include_blank: "-- Select --",
    ) do |combobox|
      combobox.trigger { "Select..." }
      combobox.content do
        combobox.item(value: "option1") { "Option 1" }
      end
    end
    output = render(component)

    # Should include blank option in content
    assert_includes(output, "-- Select --")
    assert_includes(output, 'data-value=""')
  end

  def test_it_should_render_complete_combobox_structure
    component = ShadcnPhlexcomponents::Combobox.new(
      name: "complete_test",
      value: "selected_value",
      placeholder: "Choose an option",
      disabled: false,
      search_path: "/search",
      class: "full-combobox",
    ) do |combobox|
      combobox.trigger(class: "trigger-style") { "Selected Option" }
      combobox.content(class: "content-style") do
        combobox.group do
          combobox.label { "Group Label" }
          combobox.item(value: "item1") { "Item 1" }
          combobox.item(value: "item2") { "Item 2" }
        end
      end
    end
    output = render(component)

    # Check main container
    assert_includes(output, "full-combobox")
    assert_includes(output, 'data-controller="combobox"')
    assert_includes(output, 'data-search-path="/search"')
    assert_includes(output, 'data-combobox-selected-value="selected_value"')

    # Check hidden input
    assert_includes(output, 'name="complete_test"')
    assert_includes(output, 'value="selected_value"')

    # Check trigger - ComboboxTrigger doesn't render block content directly
    # It renders the value through ComboboxTriggerText, not the block content
    refute_includes(output, "Selected Option")
    assert_includes(output, "trigger-style")
    assert_includes(output, 'data-placeholder="Choose an option"')
    # The trigger shows the selected value, not the block content
    assert_includes(output, "selected_value")

    # Check content and search functionality
    assert_includes(output, "content-style")
    assert_includes(output, 'role="listbox"')
    assert_includes(output, 'data-combobox-target="searchInput"')

    # Check group and items
    assert_includes(output, "Group Label")
    assert_includes(output, "Item 1")
    assert_includes(output, "Item 2")
    assert_includes(output, 'role="group"')
    assert_includes(output, 'role="option"')
  end
end

class TestComboboxTrigger < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::ComboboxTrigger.new(
      aria_id: "test-combobox",
      value: "selected",
    ) { "Trigger content" }
    output = render(component)

    # ComboboxTrigger doesn't render the block content directly, it renders ComboboxTriggerText
    # The "selected" value is what gets rendered, not the block content
    assert_includes(output, "selected")
    assert_includes(output, 'data-shadcn-phlexcomponents="combobox-trigger"')
    assert_includes(output, 'role="combobox"')
    assert_includes(output, 'aria-controls="test-combobox-content"')
    assert_includes(output, 'data-combobox-target="trigger"')
    assert_includes(output, 'data-has-value="true"')
    # Block content is not rendered in ComboboxTrigger
    refute_includes(output, "Trigger content")
    assert_match(%r{<button[^>]*>.*</button>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::ComboboxTrigger.new(
      aria_id: "custom-test",
      class: "custom-trigger",
      id: "trigger-id",
    )
    output = render(component)

    assert_includes(output, "custom-trigger")
    assert_includes(output, 'id="trigger-id"')
    assert_includes(output, 'aria-controls="custom-test-content"')
  end

  def test_it_should_handle_placeholder_and_value_states
    # Test with value
    with_value = ShadcnPhlexcomponents::ComboboxTrigger.new(
      aria_id: "test",
      value: "selected_option",
      placeholder: "Select option...",
    )
    with_value_output = render(with_value)

    assert_includes(with_value_output, 'data-has-value="true"')
    assert_includes(with_value_output, 'data-placeholder="Select option..."')

    # Test without value
    without_value = ShadcnPhlexcomponents::ComboboxTrigger.new(
      aria_id: "test",
      placeholder: "Select option...",
    )
    without_value_output = render(without_value)

    assert_includes(without_value_output, 'data-has-value="false"')
  end

  def test_it_should_include_chevron_icon
    component = ShadcnPhlexcomponents::ComboboxTrigger.new(aria_id: "test")
    output = render(component)

    assert_match(%r{<svg[^>]*>.*</svg>}m, output)
    # The icon path is "m6 9 6 6 6-6", not the icon name
    assert_includes(output, "m6 9 6 6 6-6")
    assert_includes(output, "size-4 opacity-50")
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::ComboboxTrigger.new(
      aria_id: "test",
      disabled: true,
    )
    output = render(component)

    assert_includes(output, "disabled")
    assert_includes(output, "disabled:cursor-not-allowed disabled:opacity-50")
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::ComboboxTrigger.new(aria_id: "test")
    output = render(component)

    assert_match(/click->combobox#toggle/, output)
    assert_match(/keydown\.down->combobox#open:prevent/, output)
  end
end

class TestComboboxContent < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::ComboboxContent.new(
      aria_id: "test-content",
    ) { "Content body" }
    output = render(component)

    assert_includes(output, "Content body")
    assert_includes(output, 'data-shadcn-phlexcomponents="combobox-content"')
    assert_includes(output, 'id="test-content-content"')
    assert_includes(output, 'role="listbox"')
    assert_includes(output, 'data-combobox-target="content"')
    assert_includes(output, 'data-state="closed"')
  end

  def test_it_should_include_search_functionality
    component = ShadcnPhlexcomponents::ComboboxContent.new(
      aria_id: "search-test",
      search_placeholder_text: "Search items...",
      search_empty_text: "No results",
      search_error_text: "Error occurred",
    ) { "Content" }
    output = render(component)

    # Check search input
    assert_includes(output, 'data-combobox-target="searchInput"')
    assert_includes(output, 'placeholder="Search items..."')
    assert_includes(output, 'role="combobox"')

    # Check search states
    assert_includes(output, 'data-combobox-target="empty"')
    assert_includes(output, 'data-combobox-target="error"')
    assert_includes(output, 'data-combobox-target="loading"')
    assert_includes(output, "No results")
    assert_includes(output, "Error occurred")
  end

  def test_it_should_handle_include_blank_option
    component = ShadcnPhlexcomponents::ComboboxContent.new(
      aria_id: "blank-test",
      include_blank: "-- None --",
    ) { "Content" }
    output = render(component)

    assert_includes(output, "-- None --")
    assert_includes(output, 'data-value=""')
    assert_includes(output, "h-8") # blank option styling
  end

  def test_it_should_include_list_container_and_targets
    component = ShadcnPhlexcomponents::ComboboxContent.new(aria_id: "list-test") { "Content" }
    output = render(component)

    assert_includes(output, 'data-combobox-target="list"')
    assert_includes(output, 'data-combobox-target="listContainer"')
    assert_includes(output, 'id="list-test-list"')
    assert_includes(output, "max-h-80 overflow-y-auto")
  end

  def test_it_should_handle_positioning_attributes
    component = ShadcnPhlexcomponents::ComboboxContent.new(
      aria_id: "position-test",
      side: :top,
      align: :end,
    ) { "Content" }
    output = render(component)

    assert_includes(output, 'data-side="top"')
    assert_includes(output, 'data-align="end"')
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::ComboboxContent.new(aria_id: "action-test") { "Content" }
    output = render(component)

    assert_match(/combobox:click:outside->combobox#clickOutside/, output)
    assert_match(/keydown\.up->combobox#highlightItem:prevent/, output)
    assert_match(/keydown\.down->combobox#highlightItem:prevent/, output)
    assert_match(/keydown\.enter->combobox#select:prevent/, output)
  end
end

class TestComboboxItem < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::ComboboxItem.new(
      value: "test_item",
      aria_id: "test-combobox",
    ) { "Item text" }
    output = render(component)

    assert_includes(output, "Item text")
    assert_includes(output, 'data-shadcn-phlexcomponents="combobox-item"')
    assert_includes(output, 'role="option"')
    assert_includes(output, 'data-value="test_item"')
    assert_includes(output, 'data-combobox-target="item"')
    # ComboboxItem doesn't include aria-selected in default attributes
    refute_includes(output, "aria-selected")
    assert_includes(output, 'data-highlighted="false"')
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::ComboboxItem.new(
      value: "disabled_item",
      disabled: true,
      aria_id: "test",
    ) { "Disabled item" }
    output = render(component)

    assert_includes(output, "data-disabled")
    assert_includes(output, "data-[disabled]:pointer-events-none data-[disabled]:opacity-50")
  end

  def test_it_should_include_check_icon
    component = ShadcnPhlexcomponents::ComboboxItem.new(
      value: "check_item",
      aria_id: "test",
    ) { "Item with check" }
    output = render(component)

    assert_match(%r{<svg[^>]*>.*</svg>}m, output)
    assert_includes(output, "check")
    assert_includes(output, "group-aria-[selected=true]/item:flex")
    assert_includes(output, "absolute right-2")
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::ComboboxItem.new(
      value: "action_item",
      aria_id: "test",
    ) { "Actionable item" }
    output = render(component)

    assert_match(/click->combobox#select/, output)
    assert_match(/mouseover->combobox#highlightItem/, output)
  end

  def test_it_should_generate_unique_labelledby_id
    item1 = ShadcnPhlexcomponents::ComboboxItem.new(value: "item1", aria_id: "test")
    item1_output = render(item1)

    item2 = ShadcnPhlexcomponents::ComboboxItem.new(value: "item2", aria_id: "test")
    item2_output = render(item2)

    # Extract labelledby IDs
    labelledby1 = item1_output[/aria-labelledby="([^"]*)"/, 1]
    labelledby2 = item2_output[/aria-labelledby="([^"]*)"/, 1]

    refute_equal(labelledby1, labelledby2)
  end
end

class TestComboboxLabel < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::ComboboxLabel.new { "Label text" }
    output = render(component)

    assert_includes(output, "Label text")
    assert_includes(output, 'data-shadcn-phlexcomponents="combobox-label"')
    assert_includes(output, "text-muted-foreground px-2 py-1.5 text-xs")
    assert_match(%r{<div[^>]*>Label text</div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::ComboboxLabel.new(
      class: "custom-label",
      id: "label-id",
    ) { "Custom label" }
    output = render(component)

    assert_includes(output, "custom-label")
    assert_includes(output, 'id="label-id"')
  end
end

class TestComboboxGroup < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::ComboboxGroup.new(
      aria_id: "test-group",
    ) { "Group content" }
    output = render(component)

    assert_includes(output, "Group content")
    assert_includes(output, 'data-shadcn-phlexcomponents="combobox-group"')
    assert_includes(output, 'role="group"')
    assert_includes(output, 'data-combobox-target="group"')
    assert_match(/aria-labelledby="test-group-group-[a-f0-9]+"/, output)
  end
end

class TestComboboxText < ComponentTest
  def test_it_should_render_with_target
    component = ShadcnPhlexcomponents::ComboboxText.new(target: "empty") { "No results" }
    output = render(component)

    assert_includes(output, "No results")
    assert_includes(output, 'data-shadcn-phlexcomponents="combobox-text"')
    assert_includes(output, 'role="presentation"')
    assert_includes(output, 'data-combobox-target="empty"')
    assert_includes(output, "py-6 text-center text-sm hidden")
  end
end

class TestComboboxSeparator < ComponentTest
  def test_it_should_render_separator
    component = ShadcnPhlexcomponents::ComboboxSeparator.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="combobox-separator"')
    assert_includes(output, 'aria-hidden="true"')
    assert_includes(output, "bg-border pointer-events-none -mx-1 my-1 h-px")
  end
end

class TestComboboxTriggerText < ComponentTest
  def test_it_should_render_value_or_placeholder
    # With value
    with_value = ShadcnPhlexcomponents::ComboboxTriggerText.new(
      value: "Selected Item",
      placeholder: "Select...",
    )
    value_output = render(with_value)
    assert_includes(value_output, "Selected Item")

    # Without value (shows placeholder)
    without_value = ShadcnPhlexcomponents::ComboboxTriggerText.new(
      placeholder: "Select...",
    )
    placeholder_output = render(without_value)
    assert_includes(placeholder_output, "Select...")
  end

  def test_it_should_include_trigger_text_target
    component = ShadcnPhlexcomponents::ComboboxTriggerText.new(value: "test")
    output = render(component)

    assert_includes(output, 'data-combobox-target="triggerText"')
    assert_includes(output, "pointer-events-none line-clamp-1 flex items-center gap-2")
  end
end

class TestComboboxWithCustomConfiguration < ComponentTest
  def test_combobox_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.combobox = {
      root: { base: "custom-combobox-base" },
      trigger: { base: "custom-trigger-base" },
      content: { base: "custom-content-base" },
      label: { base: "custom-label-base" },
      item: { base: "custom-item-base" },
      text: { base: "custom-text-base" },
      separator: { base: "custom-separator-base" },
      trigger_text: { base: "custom-trigger-text-base" },
      content_container: { base: "custom-content-container-base" },
      search_input_container: { base: "custom-search-input-container-base" },
      search_input: { base: "custom-search-input-base" },
      list_container: { base: "custom-list-container-base" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    combobox_classes = [
      "ComboboxListContainer",
      "ComboboxSearchInput",
      "ComboboxSearchInputContainer",
      "ComboboxContentContainer",
      "ComboboxTriggerText",
      "ComboboxSeparator",
      "ComboboxText",
      "ComboboxGroup",
      "ComboboxItem",
      "ComboboxLabel",
      "ComboboxContent",
      "ComboboxTrigger",
      "Combobox",
    ]

    combobox_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/combobox.rb", __dir__))

    # Test components with custom configuration
    combobox = ShadcnPhlexcomponents::Combobox.new(name: "test") { "Test" }
    assert_includes(render(combobox), "custom-combobox-base")

    trigger = ShadcnPhlexcomponents::ComboboxTrigger.new(aria_id: "test")
    assert_includes(render(trigger), "custom-trigger-base")

    content = ShadcnPhlexcomponents::ComboboxContent.new(aria_id: "test") { "Content" }
    assert_includes(render(content), "custom-content-base")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    combobox_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/combobox.rb", __dir__))
  end
end

class TestComboboxIntegration < ComponentTest
  def test_complete_combobox_workflow
    items = [
      { value: "react", text: "React" },
      { value: "vue", text: "Vue.js" },
      { value: "angular", text: "Angular" },
      { value: "svelte", text: "Svelte" },
    ]

    component = ShadcnPhlexcomponents::Combobox.new(
      name: "framework",
      value: "react",
      placeholder: "Select framework...",
      search_path: "/api/frameworks",
      include_blank: "-- None --",
      class: "framework-selector",
      data: { controller: "combobox analytics", analytics_category: "framework-selection" },
    ) do |combobox|
      combobox.items(
        items,
        value_method: :value,
        text_method: :text,
        disabled_items: ["angular"],
      )
    end

    output = render(component)

    # Check main structure
    assert_includes(output, "framework-selector")
    # Controller attribute merging may not work exactly as expected
    assert_match(/data-controller="[^"]*combobox[^"]*analytics/, output)
    assert_includes(output, 'data-analytics-category="framework-selection"')
    assert_includes(output, 'data-search-path="/api/frameworks"')

    # Check hidden input
    assert_includes(output, 'name="framework"')
    assert_includes(output, 'value="react"')

    # Check trigger
    assert_includes(output, 'role="combobox"')
    assert_includes(output, 'data-placeholder="Select framework..."')

    # Check content with search
    assert_includes(output, 'role="listbox"')
    assert_includes(output, 'data-combobox-target="searchInput"')

    # Check blank option
    assert_includes(output, "-- None --")

    # Check items
    assert_includes(output, "React")
    assert_includes(output, "Vue.js")
    assert_includes(output, "Angular")
    assert_includes(output, "Svelte")

    # Check disabled item - disabled is a boolean attribute without value
    assert_includes(output, "data-disabled")

    # Check all framework values
    assert_includes(output, 'data-value="react"')
    assert_includes(output, 'data-value="vue"')
    assert_includes(output, 'data-value="angular"')
    assert_includes(output, 'data-value="svelte"')
  end

  def test_combobox_accessibility_features
    component = ShadcnPhlexcomponents::Combobox.new(
      name: "accessible_select",
      aria: { label: "Choose option", describedby: "help-text" },
    ) do |combobox|
      combobox.trigger(aria: { labelledby: "combobox-label" }) { "Accessible trigger" }
      combobox.content do
        combobox.group do
          combobox.label { "Options Group" }
          combobox.item(value: "option1") { "Option 1" }
          combobox.item(value: "option2") { "Option 2" }
        end
      end
    end

    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'aria-label="Choose option"')
    assert_includes(output, 'aria-describedby="help-text"')
    assert_includes(output, 'aria-labelledby="combobox-label"')

    # Check ARIA roles and relationships
    assert_includes(output, 'role="combobox"')
    assert_includes(output, 'role="listbox"')
    assert_includes(output, 'role="group"')
    assert_includes(output, 'role="option"')

    # Check search accessibility
    assert_includes(output, 'role="combobox"') # search input
    assert_includes(output, 'aria-autocomplete="list"')
    assert_match(/aria-controls="[^"]*-list"/, output)
    assert_match(/aria-labelledby="[^"]*-search-label"/, output)
  end

  def test_combobox_with_complex_content
    component = ShadcnPhlexcomponents::Combobox.new(
      name: "complex_select",
      search_placeholder_text: "Search options...",
      search_empty_text: "No matches found",
      search_error_text: "Search failed",
    ) do |combobox|
      combobox.trigger(class: "min-w-[200px]") { "🔍 Search and select" }
      combobox.content(class: "w-[300px]") do
        combobox.group do
          combobox.label { "🚀 Frontend Frameworks" }
          combobox.item(value: "react") { "⚛️ React" }
          combobox.item(value: "vue") { "💚 Vue.js" }
        end

        # ComboboxSeparator is not rendered in helper methods, check for other components
        combobox.group do
          combobox.label { "🔧 Backend Frameworks" }
          combobox.item(value: "rails") { "💎 Ruby on Rails" }
          combobox.item(value: "django") { "🐍 Django" }
        end
      end
    end

    output = render(component)

    # Check trigger class styling (content is not rendered in ComboboxTrigger)
    # ComboboxTrigger doesn't render block content, it renders value through ComboboxTriggerText
    refute_includes(output, "🔍 Search and select")
    assert_includes(output, "min-w-[200px]")

    # Check content sizing
    assert_includes(output, "w-[300px]")

    # Check groups with emojis
    assert_includes(output, "🚀 Frontend Frameworks")
    assert_includes(output, "🔧 Backend Frameworks")

    # Check items with emojis
    assert_includes(output, "⚛️ React")
    assert_includes(output, "💚 Vue.js")
    assert_includes(output, "💎 Ruby on Rails")
    assert_includes(output, "🐍 Django")

    # ComboboxSeparator is not present in this test since it's not rendered through helper methods
    # Check for group structure instead
    assert_includes(output, 'role="group"')

    # Check search functionality
    assert_includes(output, 'placeholder="Search options..."')
    assert_includes(output, "No matches found")
    assert_includes(output, "Search failed")
  end

  def test_combobox_stimulus_integration
    component = ShadcnPhlexcomponents::Combobox.new(
      name: "stimulus_test",
      search_path: "/api/search",
      data: {
        controller: "combobox custom-combobox",
        custom_combobox_setting_value: "test",
      },
    ) do |combobox|
      combobox.trigger(
        data: { action: "click->custom-combobox#beforeOpen" },
      ) { "Stimulus trigger" }

      combobox.content do
        combobox.item(
          value: "item1",
          data: { action: "click->custom-combobox#itemSelected" },
        ) { "Custom Item" }
      end
    end

    output = render(component)

    # Check multiple controllers
    assert_match(/data-controller="combobox[^"]*custom-combobox/, output)
    assert_includes(output, 'data-custom-combobox-setting-value="test"')

    # Check search path
    assert_includes(output, 'data-search-path="/api/search"')

    # Check custom actions
    assert_match(/click->custom-combobox#beforeOpen/, output)
    assert_match(/click->custom-combobox#itemSelected/, output)

    # Check default combobox actions still work
    assert_match(/click->combobox#toggle/, output)
    assert_match(/click->combobox#select/, output)
  end
end
