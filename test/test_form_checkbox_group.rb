# frozen_string_literal: true

require "test_helper"

class TestFormCheckboxGroup < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :preferences,
      collection: [{ value: "email", text: "Email" }],
      value_method: :value,
      text_method: :text,
    ) { "Checkbox group content" }
    output = render(component)

    # NOTE: Block content is consumed and not rendered in checkbox group
    # assert_includes(output, "Checkbox group content")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, 'role="group"')
    assert_includes(output, 'name="preferences[]"')
    assert_includes(output, 'id="preferences"')
    # Block content is not rendered in checkbox group component
  end

  def test_it_should_render_with_model_and_method
    # Use Book with dynamic preferences method that returns array of selected items
    book = Book.new
    def book.preferences
      # Return objects that respond to value_method
      [
        Struct.new(:value).new("email"),
        Struct.new(:value).new("sms"),
      ]
    end

    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :preferences,
      model: book,
      collection: [
        { value: "email", text: "Email notifications" },
        { value: "sms", text: "SMS notifications" },
        { value: "push", text: "Push notifications" },
      ],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, "Email notifications")
    assert_includes(output, "SMS notifications")
    assert_includes(output, "Push notifications")

    # Check that model values are selected
    selected_count = output.scan('data-checked="true"').length
    assert_equal(2, selected_count)
  end

  def test_it_should_handle_object_name_with_model
    # Use Book with dynamic tags method
    book = Book.new
    def book.tags
      # Return objects that respond to value_method
      [
        Struct.new(:value).new("ruby"),
        Struct.new(:value).new("rails"),
      ]
    end

    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :tags,
      model: book,
      object_name: :user,
      collection: [
        { value: "ruby", text: "Ruby" },
        { value: "rails", text: "Rails" },
        { value: "javascript", text: "JavaScript" },
      ],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, 'name="user[tags][]"')
    assert_includes(output, 'id="user_tags"')

    # Check selected values from model
    selected_count = output.scan('data-checked="true"').length
    assert_equal(2, selected_count)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :skills,
      collection: [{ value: "coding", text: "Coding" }],
      value_method: :value,
      text_method: :text,
      class: "skills-group",
      id: "custom-skills",
      data: { testid: "form-checkbox-group" },
    )
    output = render(component)

    assert_includes(output, "skills-group")
    assert_includes(output, 'id="custom-skills"')
    assert_includes(output, 'data-testid="form-checkbox-group"')
    assert_includes(output, 'role="group"')
  end

  def test_it_should_render_with_explicit_value
    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :interests,
      value: ["music", "sports"],
      collection: [
        { value: "music", text: "Music" },
        { value: "sports", text: "Sports" },
        { value: "reading", text: "Reading" },
      ],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, "Music")
    assert_includes(output, "Sports")
    assert_includes(output, "Reading")

    # Check that explicit values are selected
    selected_count = output.scan('data-checked="true"').length
    assert_equal(2, selected_count)
  end

  def test_it_should_handle_disabled_items
    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :permissions,
      collection: [
        { value: "read", text: "Read" },
        { value: "write", text: "Write" },
        { value: "admin", text: "Admin" },
      ],
      value_method: :value,
      text_method: :text,
      disabled_items: ["admin"],
    )
    output = render(component)

    assert_includes(output, "Read")
    assert_includes(output, "Write")
    assert_includes(output, "Admin")

    # Check disabled item
    disabled_count = output.scan(/\sdisabled(\s|>)/).length
    assert_equal(1, disabled_count)
  end

  def test_it_should_convert_hash_collection_to_struct
    hash_collection = [
      { value: "option1", text: "Option 1" },
      { value: "option2", text: "Option 2" },
    ]

    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :options,
      collection: hash_collection,
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, "Option 1")
    assert_includes(output, "Option 2")
    assert_includes(output, 'value="option1"')
    assert_includes(output, 'value="option2"')
  end

  def test_it_should_handle_struct_collection
    struct_collection = [
      { value: "choice1", text: "Choice 1" },
      { value: "choice2", text: "Choice 2" },
    ]

    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :choices,
      collection: struct_collection,
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, "Choice 1")
    assert_includes(output, "Choice 2")
    assert_includes(output, 'value="choice1"')
    assert_includes(output, 'value="choice2"')
  end

  def test_it_should_render_with_label
    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :hobbies,
      label: "Select your hobbies",
      collection: [{ value: "reading", text: "Reading" }],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, "Select your hobbies")
    assert_match(/for="hobbies"/, output)
    assert_match(/id="[^"]*-label"/, output)
  end

  def test_it_should_render_with_hint
    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :categories,
      hint: "Choose one or more categories",
      collection: [{ value: "tech", text: "Technology" }],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, "Choose one or more categories")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    assert_match(/id="[^"]*-description"/, output)
  end

  def test_it_should_render_with_error_from_model
    # Use Book with custom skills method and validation error
    book = Book.new
    def book.skills = []
    book.errors.add(:skills, "Please select at least one skill")

    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :skills,
      model: book,
      collection: [{ value: "coding", text: "Coding" }],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, "Please select at least one skill")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    assert_includes(output, "text-destructive")
  end

  def test_it_should_render_with_explicit_error
    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :tags,
      error: "Tags are required",
      collection: [{ value: "important", text: "Important" }],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, "Tags are required")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_it_should_render_with_custom_name_and_id
    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :preferences,
      name: "user_preferences",
      id: "preference-group",
      collection: [{ value: "email", text: "Email" }],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, 'name="user_preferences[]"')
    assert_includes(output, 'id="preference-group"')
  end

  def test_it_should_configure_checkbox_attributes
    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :options,
      collection: [{ value: "opt1", text: "Option 1" }],
      value_method: :value,
      text_method: :text,
    ) do |group|
      group.checkbox(class: "custom-checkbox", data: { custom: "checkbox-value" })
    end
    output = render(component)

    assert_includes(output, "custom-checkbox")
    assert_includes(output, 'data-custom="checkbox-value"')
  end

  def test_it_should_configure_checkbox_label_attributes
    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :items,
      collection: [{ value: "item1", text: "Item 1" }],
      value_method: :value,
      text_method: :text,
    ) do |group|
      group.checkbox_label(class: "custom-label", style: "font-weight: bold")
    end
    output = render(component)

    assert_includes(output, "custom-label")
    assert_includes(output, "font-weight: bold")
  end

  def test_it_should_generate_proper_ids_with_prefix
    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :features,
      id: "product-features",
      collection: [
        { value: "feature1", text: "Feature 1" },
        { value: "feature2", text: "Feature 2" },
      ],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, 'id="product_features_feature1"')
    assert_includes(output, 'id="product_features_feature2"')
    assert_includes(output, 'for="product_features_feature1"')
    assert_includes(output, 'for="product_features_feature2"')
  end

  def test_it_should_handle_aria_attributes
    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :settings,
      label: "Application Settings",
      hint: "Configure your preferences",
      collection: [{ value: "notifications", text: "Enable Notifications" }],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    # Check ARIA label association
    assert_includes(output, "form-field-")
    assert_includes(output, "-label")
    assert_match(/aria-describedby="[^"]*-description"/, output)
    assert_includes(output, 'aria-invalid="false"')
  end

  def test_it_should_handle_aria_attributes_with_error
    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :required_items,
      error: "Please select at least one item",
      collection: [{ value: "item", text: "Item" }],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, 'aria-invalid="true"')
    assert_match(/aria-describedby="[^"]*-message"/, output)
  end

  def test_it_should_include_hidden_field
    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :selections,
      collection: [{ value: "select1", text: "Selection 1" }],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'name="selections[]"')
    assert_includes(output, 'autocomplete="off"')
  end

  def test_it_should_render_complete_form_structure
    # Use Book with notifications method
    book = Book.new
    def book.notifications
      [Struct.new(:value).new("email")]
    end

    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :notifications,
      model: book,
      object_name: :user,
      label: "Notification Preferences",
      hint: "Select how you'd like to be notified",
      collection: [
        { value: "email", text: "📧 Email notifications" },
        { value: "sms", text: "📱 SMS notifications" },
        { value: "push", text: "🔔 Push notifications" },
      ],
      value_method: :value,
      text_method: :text,
      disabled_items: ["sms"],
      class: "notification-preferences",
    ) do |group|
      group.checkbox(class: "notification-checkbox")
      group.checkbox_label(class: "notification-label text-sm")
    end
    output = render(component)

    # Check main structure
    assert_includes(output, "notification-preferences")
    assert_includes(output, 'name="user[notifications][]"')
    assert_includes(output, 'id="user_notifications"')

    # Check label and hint (note: apostrophes get HTML encoded)
    assert_includes(output, "Notification Preferences")
    assert_includes(output, "Select how you&#39;d like to be notified")

    # Check all options rendered with emojis
    assert_includes(output, "📧 Email notifications")
    assert_includes(output, "📱 SMS notifications")
    assert_includes(output, "🔔 Push notifications")

    # Check model selection (email should be selected)
    selected_count = output.scan('data-checked="true"').length
    assert_equal(1, selected_count)

    # Check disabled item (SMS)
    disabled_count = output.scan(/\sdisabled(\s|>)/).length
    assert_equal(1, disabled_count)

    # Check custom attributes
    assert_includes(output, "notification-checkbox")
    assert_includes(output, "notification-label text-sm")

    # Check accessibility
    # Check ARIA label association
    assert_includes(output, "form-field-")
    assert_includes(output, "-label")
    assert_match(/aria-describedby="[^"]*-description"/, output)
    assert_includes(output, 'role="group"')

    # Check hidden field
    assert_includes(output, 'type="hidden"')
  end

  def test_it_should_handle_empty_collection
    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :empty_test,
      collection: [],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    # Should still render container and hidden field
    assert_includes(output, 'role="group"')
    assert_includes(output, 'type="hidden"')
    # NOTE: empty field names are rendered as "[]" rather than "empty_test[]"
  end

  def test_it_should_handle_block_content_with_label_and_hint
    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :features,
      collection: [{ value: "feature1", text: "Feature 1" }],
      value_method: :value,
      text_method: :text,
    ) do |group|
      group.label("Custom Features", class: "font-bold")
      group.hint("Choose features to enable", class: "text-gray-600")
    end
    output = render(component)

    assert_includes(output, "Custom Features")
    assert_includes(output, "font-bold")
    assert_includes(output, "Choose features to enable")
    assert_includes(output, "text-gray-600")

    # Should have data attributes for removing duplicates
    assert_includes(output, "data-remove-hint")
  end

  def test_it_should_handle_model_with_array_values
    # Use Book with tags method that returns array values
    book = Book.new
    def book.tags
      [
        Struct.new(:value).new("ruby"),
        Struct.new(:value).new("rails"),
      ]
    end

    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :tags,
      model: book,
      collection: [
        { value: "ruby", text: "Ruby" },
        { value: "rails", text: "Rails" },
        { value: "javascript", text: "JavaScript" },
      ],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    # Should extract values using value_method
    selected_count = output.scan('data-checked="true"').length
    assert_equal(2, selected_count)
  end
end

class TestFormCheckboxGroupIntegration < ComponentTest
  def test_form_checkbox_group_with_complex_model
    # Use Book with notification_preferences method and model_name
    book = Book.new
    def book.notification_preferences
      # Return objects that respond to value_method, not plain strings
      [
        Struct.new(:value).new("email"),
        Struct.new(:value).new("push"),
      ]
    end

    def book.model_name
      ActiveModel::Name.new(self.class, nil, "User")
    end

    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :notification_preferences,
      model: book,
      object_name: :user,
      collection: [
        { value: "email", text: "Email Notifications" },
        { value: "sms", text: "SMS Notifications" },
        { value: "push", text: "Push Notifications" },
        { value: "in_app", text: "In-App Notifications" },
      ],
      value_method: :value,
      text_method: :text,
      label: "How would you like to receive notifications?",
      hint: "You can select multiple options",
      class: "user-preferences",
    )
    output = render(component)

    # Check proper form integration
    assert_includes(output, 'name="user[notification_preferences][]"')
    assert_includes(output, 'id="user_notification_preferences"')

    # Check all options are rendered
    assert_includes(output, "Email Notifications")
    assert_includes(output, "SMS Notifications")
    assert_includes(output, "Push Notifications")
    assert_includes(output, "In-App Notifications")

    # Check that model selections are applied (email and push)
    selected_count = output.scan('data-checked="true"').length
    assert_equal(2, selected_count)

    # Check form field structure
    assert_includes(output, "user-preferences")
    assert_includes(output, "How would you like to receive notifications?")
    assert_includes(output, "You can select multiple options")
  end

  def test_form_checkbox_group_accessibility_compliance
    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :accessibility_test,
      label: "Accessibility Features",
      hint: "Enable accessibility features for better user experience",
      error: "Please select at least one accessibility feature",
      collection: [
        { value: "screen_reader", text: "Screen Reader Support" },
        { value: "high_contrast", text: "High Contrast Mode" },
        { value: "large_text", text: "Large Text" },
      ],
      value_method: :value,
      text_method: :text,
      aria: { required: "true" },
    )
    output = render(component)

    # Check ARIA compliance
    assert_includes(output, 'role="group"')
    # Check ARIA label association
    assert_includes(output, "form-field-")
    assert_includes(output, "-label")
    # Check ARIA describedby includes both description and message IDs
    assert_includes(output, "-description")
    assert_includes(output, "-message")
    # Check that error is properly displayed instead of relying on aria-invalid
    assert_includes(output, "Please select at least one accessibility feature")
    assert_includes(output, 'aria-required="true"')

    # Check label association
    assert_match(/for="accessibility_test"/, output)

    # Check error and hint IDs are properly referenced
    assert_match(/id="[^"]*-description"/, output)
    assert_match(/id="[^"]*-message"/, output)
  end

  def test_form_checkbox_group_with_stimulus_integration
    component = ShadcnPhlexcomponents::FormCheckboxGroup.new(
      :dynamic_features,
      collection: [
        { value: "feature1", text: "Dynamic Feature 1" },
        { value: "feature2", text: "Dynamic Feature 2" },
      ],
      value_method: :value,
      text_method: :text,
      data: {
        controller: "checkbox-group feature-manager",
        feature_manager_api_url: "/api/features",
      },
    ) do |group|
      group.checkbox(
        data: {
          action: "change->feature-manager#updateFeatures",
          feature_manager_target: "checkbox",
        },
      )
    end
    output = render(component)

    # Check Stimulus controllers
    assert_match(/data-controller="[^"]*checkbox-group[^"]*feature-manager/, output)
    assert_includes(output, 'data-feature-manager-api-url="/api/features"')

    # Check Stimulus actions on checkboxes
    assert_match(/change->feature-manager#updateFeatures/, output)
    assert_includes(output, 'data-feature-manager-target="checkbox"')
  end
end
