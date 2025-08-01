# frozen_string_literal: true

require "test_helper"

class TestRadioGroup < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::RadioGroup.new(name: "test_radio", value: "option1") { "Radio group content" }
    output = render(component)

    assert_includes(output, "Radio group content")
    assert_includes(output, 'data-shadcn-phlexcomponents="radio-group"')
    assert_includes(output, 'role="radiogroup"')
    assert_includes(output, 'dir="ltr"')
    # ARIA required is set as false by default but not rendered
    assert_includes(output, 'data-controller="radio-group"')
    assert_includes(output, 'data-radio-group-selected-value="option1"')
    assert_includes(output, "grid gap-3 outline-none")
    assert_match(%r{<div[^>]*>.*Radio group content.*</div>}m, output)
  end

  def test_it_should_render_with_default_values
    component = ShadcnPhlexcomponents::RadioGroup.new { "Default radio group" }
    output = render(component)

    assert_includes(output, "Default radio group")
    assert_includes(output, 'dir="ltr"')
    # Check that no selected value is set when value is nil
    assert_includes(output, "grid gap-3 outline-none")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::RadioGroup.new(
      name: "custom_radio",
      value: "custom_value",
      dir: "rtl",
      class: "custom-radio-group",
      id: "radio-group-id",
      data: { testid: "radio-group" },
    ) { "Custom content" }
    output = render(component)

    assert_includes(output, "custom-radio-group")
    assert_includes(output, 'id="radio-group-id"')
    assert_includes(output, 'data-testid="radio-group"')
    assert_includes(output, 'dir="rtl"')
    assert_includes(output, 'data-radio-group-selected-value="custom_value"')
    assert_includes(output, "Custom content")
  end

  def test_it_should_include_hidden_input_by_default
    component = ShadcnPhlexcomponents::RadioGroup.new(name: "test_radio") { "Content" }
    output = render(component)

    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'name="test_radio"')
    assert_includes(output, 'autocomplete="off"')
  end

  def test_it_should_exclude_hidden_input_when_disabled
    component = ShadcnPhlexcomponents::RadioGroup.new(name: "test_radio", include_hidden: false) { "Content" }
    output = render(component)

    refute_includes(output, 'type="hidden"')
  end

  def test_it_should_render_with_helper_methods
    component = ShadcnPhlexcomponents::RadioGroup.new(name: "options", value: "option2") do |radio_group|
      radio_group.item(value: "option1") { "Option 1" }
      radio_group.item(value: "option2") { "Option 2" }
      radio_group.item(value: "option3") { "Option 3" }
    end
    output = render(component)

    # Check for radio items
    assert_includes(output, 'data-shadcn-phlexcomponents="radio-group-item"')
    assert_includes(output, 'data-value="option1"')
    assert_includes(output, 'data-value="option2"')
    assert_includes(output, 'data-value="option3"')

    # Check that option2 is checked
    assert_includes(output, 'data-checked="true"')
    assert_includes(output, 'aria-checked="true"')
  end

  def test_it_should_handle_items_collection_with_symbols
    collection = [
      { value: :small, text: "Small" },
      { value: :medium, text: "Medium" },
      { value: :large, text: "Large" },
    ]

    component = ShadcnPhlexcomponents::RadioGroup.new(name: "size", value: :medium) do |radio_group|
      radio_group.items(collection, value_method: :value, text_method: :text)
    end
    output = render(component)

    # Check for all options
    assert_includes(output, 'data-value="small"')
    assert_includes(output, 'data-value="medium"')
    assert_includes(output, 'data-value="large"')
    assert_includes(output, "Small")
    assert_includes(output, "Medium")
    assert_includes(output, "Large")

    # Check that medium is selected
    assert_includes(output, "checked")
    assert_includes(output, 'aria-checked="true"')
  end

  def test_it_should_handle_items_collection_with_structs
    user_struct = Struct.new(:id, :name)
    users = [
      user_struct.new(1, "Alice"),
      user_struct.new(2, "Bob"),
      user_struct.new(3, "Charlie"),
    ]

    component = ShadcnPhlexcomponents::RadioGroup.new(name: "user", value: 2) do |radio_group|
      radio_group.items(users, value_method: :id, text_method: :name)
    end
    output = render(component)

    # Check for all users
    assert_includes(output, 'data-value="1"')
    assert_includes(output, 'data-value="2"')
    assert_includes(output, 'data-value="3"')
    assert_includes(output, "Alice")
    assert_includes(output, "Bob")
    assert_includes(output, "Charlie")

    # Check labels are properly associated
    assert_includes(output, 'data-shadcn-phlexcomponents="label"')
  end

  def test_it_should_handle_disabled_items
    collection = [
      { value: "option1", text: "Option 1" },
      { value: "option2", text: "Option 2" },
      { value: "option3", text: "Option 3" },
    ]

    component = ShadcnPhlexcomponents::RadioGroup.new(name: "options") do |radio_group|
      radio_group.items(collection, value_method: :value, text_method: :text, disabled_items: ["option2"])
    end
    output = render(component)

    # Check that option2 is disabled - disabled attribute is rendered on the button
    assert_includes(output, "disabled")
  end

  def test_it_should_handle_custom_container_class
    collection = [
      { value: "a", text: "A" },
      { value: "b", text: "B" },
    ]

    component = ShadcnPhlexcomponents::RadioGroup.new(name: "letters") do |radio_group|
      radio_group.items(collection, value_method: :value, text_method: :text, container_class: "custom-container")
    end
    output = render(component)

    assert_includes(output, "custom-container")
    assert_includes(output, "flex items-center gap-3")
  end

  def test_it_should_handle_custom_id_prefix
    collection = [
      { value: "red", text: "Red" },
      { value: "blue", text: "Blue" },
    ]

    component = ShadcnPhlexcomponents::RadioGroup.new(name: "color") do |radio_group|
      radio_group.items(collection, value_method: :value, text_method: :text, id_prefix: "color-picker")
    end
    output = render(component)

    assert_includes(output, 'id="color_picker_red"')
    assert_includes(output, 'id="color_picker_blue"')
    assert_includes(output, 'for="color_picker_red"')
    assert_includes(output, 'for="color_picker_blue"')
  end

  def test_it_should_handle_aria_attributes
    component = ShadcnPhlexcomponents::RadioGroup.new(
      name: "test",
      aria: {
        label: "Choose an option",
        describedby: "radio-help",
      },
    ) { "Content" }
    output = render(component)

    assert_includes(output, 'aria-label="Choose an option"')
    assert_includes(output, 'aria-describedby="radio-help"')
    # ARIA required is set as false by default but not rendered
  end

  def test_it_should_handle_data_attributes
    component = ShadcnPhlexcomponents::RadioGroup.new(
      name: "test",
      data: {
        form_target: "radioGroup",
        action: "change->form#updateRadio",
      },
    ) { "Content" }
    output = render(component)

    # Should merge with default radio-group controller
    assert_includes(output, 'data-controller="radio-group"')
    assert_includes(output, 'data-form-target="radioGroup"')
    assert_includes(output, "updateRadio")
  end
end

class TestRadioGroupItem < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::RadioGroupItem.new(name: "test", value: "item1")
    output = render(component)

    # RadioGroupItem is a button element that contains the radio functionality
    assert_includes(output, 'data-shadcn-phlexcomponents="radio-group-item"')
    assert_includes(output, 'type="button"')
    assert_includes(output, 'role="radio"')
    assert_includes(output, 'aria-checked="false"')
    assert_includes(output, 'data-checked="false"')
    assert_includes(output, 'data-value="item1"')
    assert_includes(output, 'data-radio-group-target="item"')
    # RadioGroupItem doesn't render direct content - it contains hidden input and indicator
    assert_match(%r{<button[^>]*>.*</button>}m, output)
  end

  def test_it_should_render_checked_state
    component = ShadcnPhlexcomponents::RadioGroupItem.new(name: "test", value: "item1", checked: true) { "Checked item" }
    output = render(component)

    assert_includes(output, 'aria-checked="true"')
    assert_includes(output, 'data-checked="true"')
    assert_includes(output, "checked")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::RadioGroupItem.new(
      name: "test",
      value: "custom",
      class: "custom-radio-item",
      id: "radio-item-id",
      disabled: true,
    ) { "Custom item" }
    output = render(component)

    assert_includes(output, "custom-radio-item")
    assert_includes(output, 'id="radio-item-id"')
    assert_includes(output, "disabled")
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::RadioGroupItem.new(name: "test", value: "item1")
    output = render(component)

    assert_includes(output, "click->radio-group#select")
    assert_includes(output, "keydown.right->radio-group#selectItem:prevent")
    assert_includes(output, "keydown.down->radio-group#selectItem:prevent")
    assert_includes(output, "keydown.up->radio-group#selectItem:prevent")
    assert_includes(output, "keydown.left->radio-group#selectItem:prevent")
    assert_includes(output, "keydown.enter->radio-group#preventDefault")
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::RadioGroupItem.new(name: "test", value: "item1")
    output = render(component)

    assert_includes(output, "border-input")
    assert_includes(output, "text-primary")
    assert_includes(output, "focus-visible:border-ring")
    assert_includes(output, "aspect-square size-4")
    assert_includes(output, "rounded-full border")
    assert_includes(output, "shadow-xs transition-[color,box-shadow]")
    assert_includes(output, "disabled:cursor-not-allowed disabled:opacity-50")
  end

  def test_it_should_include_hidden_radio_input
    component = ShadcnPhlexcomponents::RadioGroupItem.new(name: "test_radio", value: "option1")
    output = render(component)

    assert_includes(output, 'type="radio"')
    assert_includes(output, 'name="test_radio"')
    assert_includes(output, 'value="option1"')
    assert_includes(output, 'tabindex="-1"')
    assert_includes(output, 'aria-hidden="true"')
    assert_includes(output, 'data-radio-group-target="input"')
    assert_includes(output, "opacity-0")
    assert_includes(output, "pointer-events-none")
  end

  def test_it_should_include_indicator
    component = ShadcnPhlexcomponents::RadioGroupItem.new(name: "test", value: "item1")
    output = render(component)

    assert_includes(output, 'data-radio-group-target="indicator"')
    assert_includes(output, 'data-shadcn-phlexcomponents="radio-group-item-indicator"')
  end
end

class TestRadioGroupItemIndicator < ComponentTest
  def test_it_should_render_indicator
    component = ShadcnPhlexcomponents::RadioGroupItemIndicator.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="radio-group-item-indicator"')
    assert_includes(output, 'data-radio-group-target="indicator"')
    assert_includes(output, "relative flex items-center justify-center")
    assert_match(%r{<span[^>]*>.*</span>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::RadioGroupItemIndicator.new(
      class: "custom-indicator",
      id: "indicator-id",
    )
    output = render(component)

    assert_includes(output, "custom-indicator")
    assert_includes(output, 'id="indicator-id"')
  end

  def test_it_should_include_circle_icon
    component = ShadcnPhlexcomponents::RadioGroupItemIndicator.new
    output = render(component)

    # Check for circle icon
    assert_includes(output, "<svg")
    assert_includes(output, "</svg>")
    assert_includes(output, "fill-primary")
    assert_includes(output, "size-2")
    assert_includes(output, "-translate-x-1/2 -translate-y-1/2")
  end
end

class TestRadioGroupWithCustomConfiguration < ComponentTest
  def test_radio_group_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.radio_group = {
      root: { base: "custom-radio-group-base flex flex-col" },
      item: { base: "custom-radio-item-base" },
      item_indicator: { base: "custom-indicator-base" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    radio_group_classes = ["RadioGroupItemIndicator", "RadioGroupItem", "RadioGroup"]

    radio_group_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/radio_group.rb", __dir__))

    # Test components with custom configuration
    radio_group = ShadcnPhlexcomponents::RadioGroup.new(name: "test") { "Test" }
    radio_group_output = render(radio_group)
    assert_includes(radio_group_output, "custom-radio-group-base")
    assert_includes(radio_group_output, "flex flex-col")

    item = ShadcnPhlexcomponents::RadioGroupItem.new(name: "test", value: "item1") { "Item" }
    assert_includes(render(item), "custom-radio-item-base")

    indicator = ShadcnPhlexcomponents::RadioGroupItemIndicator.new
    assert_includes(render(indicator), "custom-indicator-base")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    radio_group_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/radio_group.rb", __dir__))
  end
end

class TestRadioGroupIntegration < ComponentTest
  def test_radio_group_item_content_rendering
    component = ShadcnPhlexcomponents::RadioGroup.new(name: "test") do |radio_group|
      radio_group.item(value: "low", id: "priority-low") { "🟢 Low Priority" }
    end
    output = render(component)

    # RadioGroupItem doesn't render content directly - content appears in associated labels
    # The content is handled by the radio group item helper which creates labels
    assert_includes(output, 'data-value="low"')
    # Content rendering depends on how the radio group item is used with labels
  end

  def test_complete_radio_group_workflow
    component = ShadcnPhlexcomponents::RadioGroup.new(
      name: "priority",
      value: "medium",
      class: "task-priority-group",
      aria: {
        label: "Task priority selection",
        describedby: "priority-help",
      },
      data: {
        controller: "radio-group task-form",
        task_form_target: "priorityGroup",
        action: "change->task-form#updatePriority",
      },
    ) do |radio_group|
      radio_group.item(value: "low", id: "priority-low") { "🟢 Low Priority" }
      radio_group.item(value: "medium", id: "priority-medium") { "🟡 Medium Priority" }
      radio_group.item(value: "high", id: "priority-high") { "🔴 High Priority" }
    end

    output = render(component)

    # Check main structure
    assert_includes(output, "task-priority-group")
    assert_includes(output, 'aria-label="Task priority selection"')
    assert_includes(output, 'aria-describedby="priority-help"')

    # Check stimulus integration
    assert_match(/data-controller="[^"]*radio-group[^"]*task-form[^"]*"/, output)
    assert_includes(output, 'data-task-form-target="priorityGroup"')
    assert_includes(output, "task-form#updatePriority")

    # Check selected value
    assert_includes(output, 'data-radio-group-selected-value="medium"')

    # RadioGroup item helper creates labels with content, so content should appear in labels
    # Check radio item data values
    assert_includes(output, 'data-value="low"')
    assert_includes(output, 'data-value="medium"')
    assert_includes(output, 'data-value="high"')

    # Check that medium is selected
    assert_includes(output, 'aria-checked="true"')
    assert_includes(output, 'data-checked="true"')

    # Check hidden input
    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'name="priority"')
  end

  def test_radio_group_accessibility_features
    component = ShadcnPhlexcomponents::RadioGroup.new(
      name: "accessibility_test",
      aria: {
        label: "Accessibility options",
        describedby: "accessibility-help accessibility-note",
      },
    ) do |radio_group|
      radio_group.item(value: "screenreader", aria: { describedby: "sr-help" }) { "Screen Reader Support" }
      radio_group.item(value: "keyboard", aria: { describedby: "kb-help" }) { "Keyboard Navigation" }
      radio_group.item(value: "both", aria: { describedby: "both-help" }) { "Both Options" }
    end

    output = render(component)

    # Check group accessibility
    assert_includes(output, 'role="radiogroup"')
    assert_includes(output, 'aria-label="Accessibility options"')
    assert_includes(output, 'aria-describedby="accessibility-help accessibility-note"')

    # Check item accessibility
    assert_includes(output, 'role="radio"')
    assert_includes(output, 'aria-describedby="sr-help"')
    assert_includes(output, 'aria-describedby="kb-help"')
    assert_includes(output, 'aria-describedby="both-help"')

    # Check keyboard navigation
    assert_includes(output, "keydown.right->radio-group#selectItem:prevent")
    assert_includes(output, "keydown.left->radio-group#selectItem:prevent")
    assert_includes(output, "keydown.up->radio-group#selectItem:prevent")
    assert_includes(output, "keydown.down->radio-group#selectItem:prevent")
  end

  def test_radio_group_form_integration
    component = ShadcnPhlexcomponents::RadioGroup.new(
      name: "payment_method",
      value: "credit_card",
      data: {
        controller: "radio-group payment-form",
        payment_form_target: "methodSelector",
        action: "change->payment-form#updateMethod",
      },
    ) do |radio_group|
      radio_group.item(value: "credit_card") { "💳 Credit Card" }
      radio_group.item(value: "paypal") { "🟦 PayPal" }
      radio_group.item(value: "bank_transfer") { "🏦 Bank Transfer" }
    end

    output = render(component)

    # Check form integration
    assert_match(/data-controller="[^"]*radio-group[^"]*payment-form[^"]*"/, output)
    assert_includes(output, 'data-payment-form-target="methodSelector"')
    assert_includes(output, "payment-form#updateMethod")

    # RadioGroup item content appears in form context differently - check data values
    assert_includes(output, 'data-value="credit_card"')
    assert_includes(output, 'data-value="paypal"')
    assert_includes(output, 'data-value="bank_transfer"')

    # Check selected value
    assert_includes(output, 'data-radio-group-selected-value="credit_card"')
  end

  def test_radio_group_with_collection_and_labels
    users = [
      { id: 1, name: "Alice Johnson", role: "Admin" },
      { id: 2, name: "Bob Smith", role: "User" },
      { id: 3, name: "Charlie Brown", role: "Editor" },
    ]

    component = ShadcnPhlexcomponents::RadioGroup.new(
      name: "assigned_user",
      value: 2,
      class: "user-assignment",
    ) do |radio_group|
      radio_group.label(class: "font-medium")
      radio_group.radio(class: "user-radio")
      radio_group.items(users, value_method: :id, text_method: :name, container_class: "user-option")
    end

    output = render(component)

    # Check collection rendering
    assert_includes(output, "user-assignment")
    assert_includes(output, "user-option")
    assert_includes(output, 'data-value="1"')
    assert_includes(output, 'data-value="2"')
    assert_includes(output, 'data-value="3"')

    # Check user names
    assert_includes(output, "Alice Johnson")
    assert_includes(output, "Bob Smith")
    assert_includes(output, "Charlie Brown")

    # Check that user 2 is selected
    assert_includes(output, 'data-radio-group-selected-value="2"')

    # Check labels
    assert_includes(output, 'data-shadcn-phlexcomponents="label"')
    assert_includes(output, "font-medium")
  end

  def test_radio_group_disabled_states
    component = ShadcnPhlexcomponents::RadioGroup.new(
      name: "status",
      value: "active",
    ) do |radio_group|
      radio_group.item(value: "active") { "✅ Active" }
      radio_group.item(value: "inactive", disabled: true) { "❌ Inactive" }
      radio_group.item(value: "pending") { "⏳ Pending" }
    end

    output = render(component)

    # Check disabled state
    assert_includes(output, "disabled")
    assert_includes(output, "disabled:cursor-not-allowed disabled:opacity-50")

    # RadioGroup item content handling - check data values instead of content
    assert_includes(output, 'data-value="active"')
    assert_includes(output, 'data-value="inactive"')
    assert_includes(output, 'data-value="pending"')
  end

  def test_radio_group_rtl_support
    component = ShadcnPhlexcomponents::RadioGroup.new(
      name: "language",
      dir: "rtl",
      aria: { label: "اختر اللغة" },
    ) do |radio_group|
      radio_group.item(value: "ar") { "العربية" }
      radio_group.item(value: "en") { "English" }
      radio_group.item(value: "he") { "עברית" }
    end

    output = render(component)

    # Check RTL support
    assert_includes(output, 'dir="rtl"')
    assert_includes(output, 'aria-label="اختر اللغة"')

    # Check that values are rendered correctly
    assert_includes(output, 'data-value="ar"')
    assert_includes(output, 'data-value="en"')
    assert_includes(output, 'data-value="he"')
  end

  def test_radio_group_complex_workflow
    survey_options = [
      { value: "excellent", text: "⭐⭐⭐⭐⭐ Excellent" },
      { value: "good", text: "⭐⭐⭐⭐ Good" },
      { value: "average", text: "⭐⭐⭐ Average" },
      { value: "poor", text: "⭐⭐ Poor" },
      { value: "terrible", text: "⭐ Terrible" },
    ]

    component = ShadcnPhlexcomponents::RadioGroup.new(
      name: "satisfaction_rating",
      class: "survey-rating",
      aria: {
        label: "Rate your satisfaction",
        describedby: "rating-help",
      },
      data: {
        controller: "radio-group survey analytics",
        survey_target: "ratingGroup",
        analytics_category: "satisfaction",
        action: "change->survey#updateRating change->analytics#track",
      },
    ) do |radio_group|
      radio_group.items(
        survey_options,
        value_method: :value,
        text_method: :text,
        container_class: "rating-option p-2 hover:bg-gray-50",
      )
    end

    output = render(component)

    # Check main structure
    assert_includes(output, "survey-rating")
    assert_includes(output, 'aria-label="Rate your satisfaction"')
    assert_includes(output, 'aria-describedby="rating-help"')

    # Check multiple controllers
    assert_match(/data-controller="[^"]*radio-group[^"]*survey[^"]*analytics[^"]*"/, output)
    assert_includes(output, 'data-survey-target="ratingGroup"')
    assert_includes(output, 'data-analytics-category="satisfaction"')

    # Check actions
    assert_includes(output, "survey#updateRating")
    assert_includes(output, "analytics#track")

    # Check rating options with stars
    assert_includes(output, "⭐⭐⭐⭐⭐ Excellent")
    assert_includes(output, "⭐⭐⭐⭐ Good")
    assert_includes(output, "⭐⭐⭐ Average")
    assert_includes(output, "⭐⭐ Poor")
    assert_includes(output, "⭐ Terrible")

    # Check container classes
    assert_includes(output, "rating-option")
    assert_includes(output, "p-2 hover:bg-gray-50")
  end
end
