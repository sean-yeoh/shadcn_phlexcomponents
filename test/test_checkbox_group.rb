# frozen_string_literal: true

require "test_helper"

class TestCheckboxGroup < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::CheckboxGroup.new(name: "preferences") { "Checkbox group content" }
    output = render(component)

    assert_includes(output, "space-y-1.5")
    assert_includes(output, "Checkbox group content")
    assert_includes(output, 'role="group"')
    assert_includes(output, 'data-shadcn-phlexcomponents="checkbox-group"')
    assert_match(%r{<div[^>]*>.*Checkbox group content.*</div>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::CheckboxGroup.new(
      name: "options",
      class: "group-class",
      id: "group-id",
      data: { testid: "checkbox-group" },
    ) { "Test content" }
    output = render(component)

    assert_includes(output, "group-class")
    assert_includes(output, 'id="group-id"')
    assert_includes(output, 'data-testid="checkbox-group"')
    assert_includes(output, "space-y-1.5")
    assert_includes(output, 'role="group"')
  end

  def test_it_should_render_with_selected_values
    component = ShadcnPhlexcomponents::CheckboxGroup.new(
      name: "colors",
      value: ["red", "blue"],
    ) { "Color selection" }
    output = render(component)

    assert_includes(output, "Color selection")
    assert_includes(output, 'role="group"')
  end

  def test_it_should_include_hidden_field_by_default
    component = ShadcnPhlexcomponents::CheckboxGroup.new(name: "tags") { "Content" }
    output = render(component)

    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'name="tags[]"')
    assert_includes(output, 'autocomplete="off"')
  end

  def test_it_should_exclude_hidden_field_when_disabled
    component = ShadcnPhlexcomponents::CheckboxGroup.new(
      name: "tags",
      include_hidden: false,
    ) { "Content" }
    output = render(component)

    refute_includes(output, 'type="hidden"')
    refute_includes(output, 'name="tags[]"')
  end

  def test_it_should_render_items_from_hash_collection
    items = [
      { value: "apple", text: "Apple" },
      { value: "banana", text: "Banana" },
      { value: "cherry", text: "Cherry" },
    ]

    component = ShadcnPhlexcomponents::CheckboxGroup.new(
      name: "fruits",
      value: ["apple"],
    ) do |group|
      group.items(items, value_method: :value, text_method: :text)
    end
    output = render(component)

    # Check that all items are rendered
    assert_includes(output, "Apple")
    assert_includes(output, "Banana")
    assert_includes(output, "Cherry")

    # Check checkbox inputs
    assert_includes(output, 'name="fruits[]"')
    assert_includes(output, 'value="apple"')
    assert_includes(output, 'value="banana"')
    assert_includes(output, 'value="cherry"')

    # Check IDs are generated correctly
    assert_includes(output, 'id="fruits_apple"')
    assert_includes(output, 'id="fruits_banana"')
    assert_includes(output, 'id="fruits_cherry"')

    # Check labels are associated correctly
    assert_includes(output, 'for="fruits_apple"')
    assert_includes(output, 'for="fruits_banana"')
    assert_includes(output, 'for="fruits_cherry"')

    # Check selected value has checked state
    assert_includes(output, 'data-checked="true"')
  end

  def test_it_should_render_items_from_struct_collection
    fruit_struct = Struct.new(:value, :text)
    items = [
      fruit_struct.new("apple", "Apple"),
      fruit_struct.new("banana", "Banana"),
      fruit_struct.new("cherry", "Cherry"),
    ]

    component = ShadcnPhlexcomponents::CheckboxGroup.new(
      name: "fruits",
      value: ["banana", "cherry"],
    ) do |group|
      group.items(items, value_method: :value, text_method: :text)
    end
    output = render(component)

    assert_includes(output, "Apple")
    assert_includes(output, "Banana")
    assert_includes(output, "Cherry")
    assert_includes(output, 'name="fruits[]"')

    # Check multiple selected values
    # Should have two instances of checked state
    checked_count = output.scan('data-checked="true"').length
    assert_equal(2, checked_count)
  end

  def test_it_should_handle_disabled_items_with_array
    items = [
      { value: "read", text: "Read" },
      { value: "write", text: "Write" },
      { value: "delete", text: "Delete" },
    ]

    component = ShadcnPhlexcomponents::CheckboxGroup.new(
      name: "permissions",
      value: ["read"],
    ) do |group|
      group.items(
        items,
        value_method: :value,
        text_method: :text,
        disabled_items: ["write", "delete"],
      )
    end
    output = render(component)

    assert_includes(output, "Read")
    assert_includes(output, "Write")
    assert_includes(output, "Delete")

    # Should have disabled attributes for write and delete
    disabled_count = output.scan(/\sdisabled(\s|>)/).length
    assert_equal(2, disabled_count)
  end

  def test_it_should_handle_disabled_items_with_string
    items = [
      { value: "admin", text: "Administrator" },
      { value: "user", text: "User" },
    ]

    component = ShadcnPhlexcomponents::CheckboxGroup.new(
      name: "roles",
    ) do |group|
      group.items(
        items,
        value_method: :value,
        text_method: :text,
        disabled_items: "admin",
      )
    end
    output = render(component)

    assert_includes(output, "Administrator")
    assert_includes(output, "User")

    # Should have one disabled attribute for admin
    disabled_count = output.scan(/\sdisabled(\s|>)/).length
    assert_equal(1, disabled_count)
  end

  def test_it_should_handle_disabled_items_with_boolean
    items = [
      { value: "option1", text: "Option 1" },
      { value: "option2", text: "Option 2" },
    ]

    component = ShadcnPhlexcomponents::CheckboxGroup.new(
      name: "options",
    ) do |group|
      group.items(
        items,
        value_method: :value,
        text_method: :text,
        disabled_items: true,
      )
    end
    output = render(component)

    # All items should be disabled
    disabled_count = output.scan(/\sdisabled(\s|>)/).length
    assert_equal(2, disabled_count)
  end

  def test_it_should_use_custom_id_prefix
    items = [
      { value: "small", text: "Small" },
      { value: "large", text: "Large" },
    ]

    component = ShadcnPhlexcomponents::CheckboxGroup.new(
      name: "sizes",
    ) do |group|
      group.items(
        items,
        value_method: :value,
        text_method: :text,
        id_prefix: "product-size",
      )
    end
    output = render(component)

    assert_includes(output, 'id="product_size_small"')
    assert_includes(output, 'id="product_size_large"')
    assert_includes(output, 'for="product_size_small"')
    assert_includes(output, 'for="product_size_large"')
  end

  def test_it_should_apply_container_class
    items = [
      { value: "item1", text: "Item 1" },
    ]

    component = ShadcnPhlexcomponents::CheckboxGroup.new(
      name: "items",
    ) do |group|
      group.items(
        items,
        value_method: :value,
        text_method: :text,
        container_class: "custom-container",
      )
    end
    output = render(component)

    assert_includes(output, "custom-container")
    assert_includes(output, "flex flex-row items-center gap-2") # base class
  end

  def test_it_should_set_label_and_checkbox_attributes
    items = [
      { value: "test", text: "Test Item" },
    ]

    component = ShadcnPhlexcomponents::CheckboxGroup.new(
      name: "test",
    ) do |group|
      group.label(class: "label-class", style: "font-weight: bold")
      group.checkbox(class: "checkbox-class", data: { custom: "value" })
      group.items(items, value_method: :value, text_method: :text)
    end
    output = render(component)

    assert_includes(output, "label-class")
    assert_includes(output, "font-weight: bold")
    assert_includes(output, "checkbox-class")
    assert_includes(output, 'data-custom="value"')
  end

  def test_it_should_render_complete_checkbox_group_structure
    items = [
      { value: "email", text: "Email notifications" },
      { value: "sms", text: "SMS notifications" },
      { value: "push", text: "Push notifications" },
    ]

    component = ShadcnPhlexcomponents::CheckboxGroup.new(
      name: "notifications",
      value: ["email", "push"],
      class: "notification-settings",
      aria: { label: "Notification preferences" },
    ) do |group|
      group.label(class: "text-sm font-medium")
      group.checkbox(class: "notification-checkbox")
      group.items(
        items,
        value_method: :value,
        text_method: :text,
        disabled_items: ["sms"],
      )
    end
    output = render(component)

    # Check main container
    assert_includes(output, "notification-settings")
    assert_includes(output, "space-y-1.5")
    assert_includes(output, 'role="group"')
    assert_includes(output, 'aria-label="Notification preferences"')

    # Check all items are rendered
    assert_includes(output, "Email notifications")
    assert_includes(output, "SMS notifications")
    assert_includes(output, "Push notifications")

    # Check selected items
    checked_count = output.scan('data-checked="true"').length
    assert_equal(2, checked_count)

    # Check disabled item
    disabled_count = output.scan(/\sdisabled(\s|>)/).length
    assert_equal(1, disabled_count)

    # Check custom classes applied
    assert_includes(output, "text-sm font-medium")
    assert_includes(output, "notification-checkbox")

    # Check hidden field
    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'name="notifications[]"')
  end
end

class TestCheckboxGroupItemContainer < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::CheckboxGroupItemContainer.new { "Container content" }
    output = render(component)

    assert_includes(output, "Container content")
    assert_includes(output, "flex flex-row items-center gap-2")
    assert_includes(output, 'data-shadcn-phlexcomponents="checkbox-group-item-container"')
    assert_match(%r{<div[^>]*>Container content</div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::CheckboxGroupItemContainer.new(
      class: "container-class",
      id: "container-id",
    )
    output = render(component)

    assert_includes(output, "container-class")
    assert_includes(output, 'id="container-id"')
    assert_includes(output, "flex flex-row items-center gap-2")
  end
end

class TestCheckboxGroupWithCustomConfiguration < ComponentTest
  def test_checkbox_group_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.checkbox_group = {
      root: {
        base: "custom-checkbox-group-base",
      },
      item_container: {
        base: "custom-item-container-base",
      },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload the CheckboxGroup classes to pick up the new configuration
    [
      "CheckboxGroupItemContainer", "CheckboxGroup",
    ].each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/checkbox_group.rb", __dir__))

    # Test CheckboxGroup with custom configuration
    group_component = ShadcnPhlexcomponents::CheckboxGroup.new(name: "test") { "Test" }
    group_output = render(group_component)
    assert_includes(group_output, "custom-checkbox-group-base")

    # Test CheckboxGroupItemContainer with custom configuration
    container_component = ShadcnPhlexcomponents::CheckboxGroupItemContainer.new { "Container" }
    container_output = render(container_component)
    assert_includes(container_output, "custom-item-container-base")
  ensure
    # Restore and reload classes
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    [
      "CheckboxGroupItemContainer", "CheckboxGroup",
    ].each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/checkbox_group.rb", __dir__))
  end
end

class TestCheckboxGroupIntegration < ComponentTest
  def test_checkbox_group_with_form_integration
    component = ShadcnPhlexcomponents::CheckboxGroup.new(
      name: "user[interests]",
      value: ["coding", "music"],
      class: "interests-group",
    ) do |group|
      group.label(class: "interest-label")
      group.checkbox(class: "interest-checkbox")
      group.items(
        [
          { value: "coding", text: "Programming" },
          { value: "music", text: "Music" },
          { value: "sports", text: "Sports" },
          { value: "reading", text: "Reading" },
        ],
        value_method: :value,
        text_method: :text,
        disabled_items: ["sports"],
      )
    end

    output = render(component)

    # Check form integration
    assert_includes(output, 'name="user[interests][]"')
    assert_includes(output, 'type="hidden"')

    # Check all options rendered
    assert_includes(output, "Programming")
    assert_includes(output, "Music")
    assert_includes(output, "Sports")
    assert_includes(output, "Reading")

    # Check selected values
    checked_count = output.scan('data-checked="true"').length
    assert_equal(2, checked_count)

    # Check disabled item
    disabled_count = output.scan(/\sdisabled(\s|>)/).length
    assert_equal(1, disabled_count)

    # Check proper IDs generated
    assert_includes(output, 'id="user_interests_coding"')
    assert_includes(output, 'id="user_interests_music"')
    assert_includes(output, 'id="user_interests_sports"')
    assert_includes(output, 'id="user_interests_reading"')
  end

  def test_checkbox_group_accessibility_features
    component = ShadcnPhlexcomponents::CheckboxGroup.new(
      name: "accessibility_test",
      aria: {
        label: "Choose your preferences",
        describedby: "preferences-help",
      },
    ) do |group|
      group.items(
        [
          { value: "option1", text: "Option 1" },
          { value: "option2", text: "Option 2" },
        ],
        value_method: :value,
        text_method: :text,
      )
    end

    output = render(component)

    # Check accessibility attributes (role may be inherited from group element)
    assert_match(/role="group"/, output)
    assert_includes(output, 'aria-label="Choose your preferences"')
    assert_includes(output, 'aria-describedby="preferences-help"')

    # Check proper labeling
    assert_includes(output, 'for="accessibility_test_option1"')
    assert_includes(output, 'for="accessibility_test_option2"')

    # Check checkbox roles and states
    assert_includes(output, 'role="checkbox"')
    assert_includes(output, 'aria-checked="false"')
  end

  def test_checkbox_group_with_complex_data
    # Simulate real-world usage with complex data
    items = [
      {
        value: "feature_a",
        text: "🚀 Advanced Features",
      },
      {
        value: "feature_b",
        text: "🔒 Security Options",
      },
      {
        value: "feature_c",
        text: "📊 Analytics Dashboard",
      },
    ]

    component = ShadcnPhlexcomponents::CheckboxGroup.new(
      name: "subscription_features",
      value: ["feature_a"],
      class: "feature-selection max-w-md",
      data: { controller: "feature-selector" },
    ) do |group|
      group.label(class: "text-sm text-gray-600")
      group.checkbox(
        class: "feature-checkbox",
        data: { action: "change->feature-selector#updatePrice" },
      )
      group.items(
        items,
        value_method: :value,
        text_method: :text,
        container_class: "feature-item p-2 border rounded",
        id_prefix: "subscription-feature",
      )
    end

    output = render(component)

    # Check main container
    assert_includes(output, "feature-selection max-w-md")
    assert_includes(output, 'data-controller="feature-selector"')

    # Check emoji content is preserved
    assert_includes(output, "🚀 Advanced Features")
    assert_includes(output, "🔒 Security Options")
    assert_includes(output, "📊 Analytics Dashboard")

    # Check custom prefixes
    assert_includes(output, 'id="subscription_feature_feature_a"')
    assert_includes(output, 'for="subscription_feature_feature_a"')

    # Check container styling
    assert_includes(output, "feature-item p-2 border rounded")

    # Check Stimulus integration
    assert_match(/change->feature-selector#updatePrice/, output)

    # Check selection state
    assert_includes(output, 'data-checked="true"')
  end

  def test_checkbox_group_empty_collection
    component = ShadcnPhlexcomponents::CheckboxGroup.new(
      name: "empty_test",
    ) do |group|
      group.items([], value_method: :value, text_method: :text)
    end

    output = render(component)

    # Should still render the container and hidden field
    assert_includes(output, 'role="group"')
    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'name="empty_test[]"')
  end
end
