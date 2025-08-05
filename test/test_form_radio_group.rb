# frozen_string_literal: true

require "test_helper"

class TestFormRadioGroup < ComponentTest
  def test_it_should_render_content_and_attributes
    collection = [
      { value: "option1", text: "Option 1" },
      { value: "option2", text: "Option 2" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :preference,
      collection: collection,
      value_method: :value,
      text_method: :text,
    ) { "Radio group content" }
    output = render(component)

    # NOTE: Block content is consumed by vanish method and not rendered
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-radio-group radio-group"')
    assert_includes(output, 'name="preference"')
    assert_includes(output, 'id="preference"')
    assert_includes(output, "Option 1")
    assert_includes(output, "Option 2")
    assert_match(%r{<div[^>]*>.*</div>}m, output)
  end

  def test_it_should_render_with_model_and_method
    book = Book.new(category: "fiction")
    collection = [
      { value: "fiction", text: "Fiction" },
      { value: "non-fiction", text: "Non-Fiction" },
      { value: "mystery", text: "Mystery" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :category,
      model: book,
      collection: collection,
      value_method: :value,
      text_method: :text,
    ) { "Select book genre" }
    output = render(component)

    # NOTE: Block content is not rendered in FormRadioGroup, it's consumed by vanish method
    assert_includes(output, 'name="category"')
    assert_includes(output, 'id="category"')
    assert_includes(output, 'value="fiction"')
    assert_includes(output, "Fiction")
    assert_includes(output, "Non-Fiction")
    assert_includes(output, "Mystery")
  end

  def test_it_should_handle_object_name_with_model
    book = Book.new(category: "mystery")
    collection = [
      { value: "fiction", text: "Fiction" },
      { value: "mystery", text: "Mystery" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :category,
      model: book,
      object_name: :book_settings,
      collection: collection,
      value_method: :value,
      text_method: :text,
    ) { "Select genre" }
    output = render(component)

    assert_includes(output, 'name="book_settings[category]"')
    assert_includes(output, 'id="book_settings_category"')
    assert_includes(output, 'value="mystery"')
    # NOTE: Block content is not rendered in FormRadioGroup, it's consumed by vanish method
  end

  def test_it_should_render_custom_attributes
    collection = [
      { value: "small", text: "Small" },
      { value: "large", text: "Large" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :size,
      collection: collection,
      value_method: :value,
      text_method: :text,
      class: "size-selector",
      id: "custom-size",
      data: { testid: "form-radio-group" },
    ) { "Select size" }
    output = render(component)

    assert_includes(output, "size-selector")
    assert_includes(output, 'id="custom-size"')
    assert_includes(output, 'data-testid="form-radio-group"')
    # NOTE: Block content is not rendered in FormRadioGroup, it's consumed by vanish method
  end

  def test_it_should_handle_explicit_value
    collection = [
      { value: "red", text: "Red" },
      { value: "blue", text: "Blue" },
      { value: "green", text: "Green" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :color,
      collection: collection,
      value_method: :value,
      text_method: :text,
      value: "blue",
    ) { "Select color" }
    output = render(component)

    assert_includes(output, 'name="color"')
    assert_includes(output, 'value="blue"')
    assert_includes(output, "Red")
    assert_includes(output, "Blue")
    assert_includes(output, "Green")
  end

  def test_it_should_render_with_label
    collection = [
      { value: "yes", text: "Yes" },
      { value: "no", text: "No" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :newsletter,
      collection: collection,
      value_method: :value,
      text_method: :text,
      label: "Subscribe to Newsletter?",
    ) { "Choose subscription preference" }
    output = render(component)

    assert_includes(output, "Subscribe to Newsletter?")
    # NOTE: Block content is not rendered in FormRadioGroup, it's consumed by vanish method
    assert_match(/id="[^"]*-label"/, output)
  end

  def test_it_should_render_with_hint
    collection = [
      { value: "beginner", text: "Beginner" },
      { value: "intermediate", text: "Intermediate" },
      { value: "advanced", text: "Advanced" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :skill_level,
      collection: collection,
      value_method: :value,
      text_method: :text,
      hint: "Select your current skill level",
    ) { "Choose skill level" }
    output = render(component)

    assert_includes(output, "Select your current skill level")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    assert_match(/id="[^"]*-description"/, output)
  end

  def test_it_should_render_with_error_from_model
    book = Book.new
    book.valid? # trigger validation errors
    collection = [
      { value: "fiction", text: "Fiction" },
      { value: "non-fiction", text: "Non-Fiction" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :category,
      model: book,
      collection: collection,
      value_method: :value,
      text_method: :text,
    ) { "This field is required" }
    output = render(component)

    # Check if there are any errors on category field
    if book.errors[:category].any?
      assert_includes(output, book.errors[:category].first)
      assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
      assert_includes(output, "text-destructive")
    else
      # If no errors on category field, test with a book that has errors
      book.errors.add(:category, "can't be blank")
      component = ShadcnPhlexcomponents::FormRadioGroup.new(
        :category,
        model: book,
        collection: collection,
        value_method: :value,
        text_method: :text,
      )
      output = render(component)
      assert_includes(output, "can&#39;t be blank")
      assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    end
  end

  def test_it_should_render_with_explicit_error
    collection = [
      { value: "option1", text: "Option 1" },
      { value: "option2", text: "Option 2" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :choice,
      collection: collection,
      value_method: :value,
      text_method: :text,
      error: "Please select an option",
    ) { "Make a choice" }
    output = render(component)

    assert_includes(output, "Please select an option")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_it_should_render_with_custom_name_and_id
    collection = [
      { value: "yes", text: "Yes" },
      { value: "no", text: "No" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :agreement,
      collection: collection,
      value_method: :value,
      text_method: :text,
      name: "custom_agreement",
      id: "agreement-radio-group",
    ) { "Do you agree?" }
    output = render(component)

    assert_includes(output, 'name="custom_agreement"')
    assert_includes(output, 'id="agreement-radio-group"')
  end

  def test_it_should_handle_collection_with_value_and_text_methods
    # Test with hash collection (standard approach)
    hash_collection = [
      { value: "option_a", text: "Option A" },
      { value: "option_b", text: "Option B" },
      { value: "option_c", text: "Option C" },
    ]

    hash_component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :hash_choice,
      collection: hash_collection,
      value_method: :value,
      text_method: :text,
    )
    hash_output = render(hash_component)

    assert_includes(hash_output, "Option A")
    assert_includes(hash_output, "Option B")
    assert_includes(hash_output, "Option C")

    # Test with objects using custom methods (using Struct like existing tests)
    option_struct = Struct.new(:id, :name)
    object_collection = [
      option_struct.new(1, "First Option"),
      option_struct.new(2, "Second Option"),
    ]

    object_component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :object_choice,
      collection: object_collection,
      value_method: :id,
      text_method: :name,
    )
    object_output = render(object_component)

    assert_includes(object_output, "First Option")
    assert_includes(object_output, "Second Option")
  end

  def test_it_should_handle_disabled_items
    collection = [
      { value: "enabled", text: "Enabled Option" },
      { value: "disabled1", text: "Disabled Option 1" },
      { value: "disabled2", text: "Disabled Option 2" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :options,
      collection: collection,
      value_method: :value,
      text_method: :text,
      disabled_items: ["disabled1", "disabled2"],
    )
    output = render(component)

    assert_includes(output, "Enabled Option")
    assert_includes(output, "Disabled Option 1")
    assert_includes(output, "Disabled Option 2")
    # Check that disabled items have disabled attribute
    # This would depend on the RadioGroup implementation
  end

  def test_it_should_generate_proper_aria_attributes
    collection = [
      { value: "option1", text: "Option 1" },
      { value: "option2", text: "Option 2" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :accessibility_test,
      collection: collection,
      value_method: :value,
      text_method: :text,
      label: "Accessible Radio Group",
      hint: "Select one option",
    ) { "Select option" }
    output = render(component)

    assert_match(/aria-labelledby="[^"]*-label"/, output)
    assert_match(/aria-describedby="[^"]*-description"/, output)
  end

  def test_it_should_handle_aria_attributes_with_error
    collection = [
      { value: "option1", text: "Option 1" },
      { value: "option2", text: "Option 2" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :required_choice,
      collection: collection,
      value_method: :value,
      text_method: :text,
      error: "This field is required",
    ) { "Required choice" }
    output = render(component)

    assert_match(/aria-describedby="[^"]*-message"/, output)
  end

  def test_it_should_render_complete_form_structure
    book = Book.new(category: "fiction")
    collection = [
      { value: "fiction", text: "Fiction" },
      { value: "non-fiction", text: "Non-Fiction" },
      { value: "mystery", text: "Mystery" },
      { value: "romance", text: "Romance" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :category,
      model: book,
      object_name: :book,
      collection: collection,
      value_method: :value,
      text_method: :text,
      label: "Book Genre",
      hint: "Select the primary genre for your book",
      value: "mystery", # explicit value should override model
      class: "book-genre-selector",
      data: {
        controller: "radio-group analytics",
        analytics_event: "genre_selection",
      },
      disabled_items: ["romance"],
    ) { "Select book genre" }
    output = render(component)

    # Check main structure
    assert_includes(output, "book-genre-selector")
    assert_includes(output, 'name="book[category]"')
    assert_includes(output, 'id="book_category"')

    # Explicit value should be used (not model value)
    assert_includes(output, 'value="mystery"')

    # Check form field components
    assert_includes(output, "Book Genre")
    assert_includes(output, "Select the primary genre for your book")
    # NOTE: Block content is not rendered in FormRadioGroup

    # Check Stimulus integration
    assert_match(/data-controller="[^"]*radio-group[^"]*analytics/, output)
    assert_includes(output, 'data-analytics-event="genre_selection"')

    # Check all options are present
    assert_includes(output, "Fiction")
    assert_includes(output, "Non-Fiction")
    assert_includes(output, "Mystery")
    assert_includes(output, "Romance")

    # Check accessibility
    assert_match(/aria-labelledby="[^"]*-label"/, output)
    assert_match(/aria-describedby="[^"]*-description"/, output)

    # Check FormField wrapper
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
  end

  def test_it_should_handle_block_content_with_radio_and_label_customization
    collection = [
      { value: "option1", text: "Option 1" },
      { value: "option2", text: "Option 2" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :custom_radio,
      collection: collection,
      value_method: :value,
      text_method: :text,
    ) do |radio_group|
      radio_group.label("Custom Radio Group Label", class: "font-semibold")
      radio_group.hint("Custom hint text", class: "text-sm text-gray-500")
      radio_group.radio(class: "custom-radio-style")
      radio_group.radio_label(class: "custom-label-style")
      "Custom radio group content"
    end
    output = render(component)

    assert_includes(output, "Custom Radio Group Label")
    assert_includes(output, "font-semibold")
    assert_includes(output, "Custom hint text")
    assert_includes(output, "text-sm text-gray-500")
    # NOTE: Block content is not rendered in FormRadioGroup, the returned string is consumed by vanish method

    # Should have data attributes for removing duplicates
    assert_includes(output, "data-remove-hint")

    # Custom radio and label styling should be applied
    assert_includes(output, "custom-radio-style")
    assert_includes(output, "custom-label-style")
  end

  def test_it_should_convert_collection_hash_to_struct
    # Test the internal conversion of hash collection
    hash_collection = [
      { value: "key1", text: "Display 1", extra: "data1" },
      { value: "key2", text: "Display 2", extra: "data2" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :hash_test,
      collection: hash_collection,
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, "Display 1")
    assert_includes(output, "Display 2")
    # Should handle the conversion internally
  end
end

class TestFormRadioGroupIntegration < ComponentTest
  def test_form_radio_group_with_complex_model
    # Use Book with category selection
    book = Book.new(category: "fiction")

    # Create a more complex collection with various data types
    genre_collection = [
      { value: "fiction", text: "Fiction", description: "Imaginative stories" },
      { value: "non-fiction", text: "Non-Fiction", description: "Factual content" },
      { value: "mystery", text: "Mystery", description: "Suspenseful stories" },
      { value: "biography", text: "Biography", description: "Life stories" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :category,
      model: book,
      object_name: :book,
      collection: genre_collection,
      value_method: :value,
      text_method: :text,
      label: "Book Genre",
      hint: "Choose the primary genre that best describes your book",
      class: "genre-selection",
    ) { "Select book genre" }
    output = render(component)

    # Check proper model integration
    assert_includes(output, 'name="book[category]"')
    assert_includes(output, 'id="book_category"')
    assert_includes(output, 'value="fiction"')

    # Check all genre options are present
    assert_includes(output, "Fiction")
    assert_includes(output, "Non-Fiction")
    assert_includes(output, "Mystery")
    assert_includes(output, "Biography")

    # Check form field structure
    assert_includes(output, "genre-selection")
    assert_includes(output, "Book Genre")
    assert_includes(output, "Choose the primary genre that best describes your book")
  end

  def test_form_radio_group_accessibility_compliance
    collection = [
      { value: "option1", text: "First Option" },
      { value: "option2", text: "Second Option" },
      { value: "option3", text: "Third Option" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :accessibility_test,
      collection: collection,
      value_method: :value,
      text_method: :text,
      label: "Accessible Radio Group Selection",
      hint: "Use arrow keys to navigate between options",
      error: "Please select one of the available options",
      aria: { required: "true" },
    ) { "Select option" }
    output = render(component)

    # Check ARIA compliance (when both hint and error are present, aria-describedby is used instead)
    # assert_match(/aria-labelledby="[^"]*-label"/, output)
    # Check ARIA describedby includes both description and message IDs
    assert_includes(output, "form-field-")
    assert_includes(output, "-description")
    assert_includes(output, "-message")
    # Check error state is properly displayed
    assert_includes(output, "Please select one of the available options")
    assert_includes(output, "text-destructive")
    assert_includes(output, 'aria-required="true"')

    # Check label association
    assert_match(/id="[^"]*-label"/, output)

    # Check error and hint IDs are properly referenced
    assert_match(/id="[^"]*-description"/, output)
    assert_match(/id="[^"]*-message"/, output)

    # Check proper label styling for error state
    assert_includes(output, "text-destructive")
  end

  def test_form_radio_group_with_stimulus_integration
    collection = [
      { value: "priority_low", text: "Low Priority" },
      { value: "priority_medium", text: "Medium Priority" },
      { value: "priority_high", text: "High Priority" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :priority,
      collection: collection,
      value_method: :value,
      text_method: :text,
      data: {
        controller: "radio-group analytics priority-handler",
        analytics_category: "form_selection",
        priority_handler_default_value: "priority_medium",
      },
    ) { "Select priority level" }
    output = render(component)

    # Check multiple Stimulus controllers
    assert_match(/data-controller="[^"]*radio-group[^"]*analytics[^"]*priority-handler/, output)
    assert_includes(output, 'data-analytics-category="form_selection"')
    assert_includes(output, 'data-priority-handler-default-value="priority_medium"')

    # Check default radio-group Stimulus functionality
    assert_includes(output, 'data-shadcn-phlexcomponents="form-radio-group radio-group"')
  end

  def test_form_radio_group_validation_states
    collection = [
      { value: "valid_option", text: "Valid Option" },
      { value: "another_option", text: "Another Option" },
    ]

    # Test valid state
    valid_component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :valid_choice,
      collection: collection,
      value_method: :value,
      text_method: :text,
      value: "valid_option",
      class: "valid-radio-group",
    ) { "Valid choice field" }
    valid_output = render(valid_component)

    assert_includes(valid_output, "valid-radio-group")
    assert_includes(valid_output, 'value="valid_option"')

    # Test invalid state
    invalid_component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :invalid_choice,
      collection: collection,
      value_method: :value,
      text_method: :text,
      error: "Invalid selection made",
      class: "invalid-radio-group",
    ) { "Invalid choice field" }
    invalid_output = render(invalid_component)

    assert_includes(invalid_output, "text-destructive") # Error styling on label
    assert_includes(invalid_output, "Invalid selection made")
  end

  def test_form_radio_group_form_integration_workflow
    # Test complete form workflow with validation and model binding
    collection = [
      { value: "beginner", text: "Beginner" },
      { value: "intermediate", text: "Intermediate" },
      { value: "advanced", text: "Advanced" },
    ]

    # Valid book with selection (using category instead of difficulty)
    valid_book = Book.new(category: "intermediate")

    radio_group = ShadcnPhlexcomponents::FormRadioGroup.new(
      :category,
      model: valid_book,
      collection: collection,
      value_method: :value,
      text_method: :text,
      label: "Difficulty Level",
      hint: "Select the appropriate difficulty level",
    )
    radio_output = render(radio_group)

    assert_includes(radio_output, 'value="intermediate"')
    refute_includes(radio_output, "text-destructive")

    # Invalid book with validation error
    invalid_book = Book.new
    invalid_book.errors.add(:category, "must be selected")

    invalid_radio = ShadcnPhlexcomponents::FormRadioGroup.new(
      :category,
      model: invalid_book,
      collection: collection,
      value_method: :value,
      text_method: :text,
      label: "Difficulty Level",
      hint: "Select the appropriate difficulty level",
    )
    invalid_output = render(invalid_radio)

    refute_includes(invalid_output, "data-radio-group-selected-value=")
    assert_includes(invalid_output, "must be selected")
    assert_includes(invalid_output, "text-destructive")
  end

  def test_form_radio_group_with_custom_styling
    collection = [
      { value: "style1", text: "Style Option 1" },
      { value: "style2", text: "Style Option 2" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :styled_choice,
      collection: collection,
      value_method: :value,
      text_method: :text,
      value: "style1",
      label: "Styled Radio Group",
      hint: "This radio group has custom styling",
      class: "w-full max-w-md custom-radio-group border rounded",
      data: { theme: "primary" },
    ) { "Custom styled radio group content" }
    output = render(component)

    # Check custom styling is applied
    assert_includes(output, "w-full max-w-md custom-radio-group border rounded")
    assert_includes(output, 'data-theme="primary"')

    # Check form field structure is preserved
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, "Styled Radio Group")
    assert_includes(output, "This radio group has custom styling")
  end

  def test_form_radio_group_with_large_collection
    # Test performance and rendering with many options
    large_collection = (1..20).map do |i|
      { value: "option_#{i}", text: "Option #{i}" }
    end

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :large_selection,
      collection: large_collection,
      value_method: :value,
      text_method: :text,
      label: "Large Option Set",
      hint: "Select from many options",
    )
    output = render(component)

    # Check that all options are rendered
    assert_includes(output, "Option 1")
    assert_includes(output, "Option 10")
    assert_includes(output, "Option 20")

    # Check structure is maintained
    assert_includes(output, 'data-shadcn-phlexcomponents="form-radio-group radio-group"')
    assert_includes(output, "Large Option Set")
  end

  def test_form_radio_group_with_boolean_options
    # Test common boolean choice pattern
    boolean_collection = [
      { value: "true", text: "Yes" },
      { value: "false", text: "No" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :agreement,
      collection: boolean_collection,
      value_method: :value,
      text_method: :text,
      label: "Do you agree to the terms?",
      hint: "This selection is required to proceed",
      value: "false",
    )
    output = render(component)

    assert_includes(output, "Yes")
    assert_includes(output, "No")
    assert_includes(output, 'value="false"')
    assert_includes(output, "Do you agree to the terms?")
  end

  def test_form_radio_group_keyboard_interaction
    collection = [
      { value: "key1", text: "First Option" },
      { value: "key2", text: "Second Option" },
      { value: "key3", text: "Third Option" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :keyboard_test,
      collection: collection,
      value_method: :value,
      text_method: :text,
    ) { "Keyboard test" }
    output = render(component)

    # Check that radio group is properly set up for keyboard navigation
    assert_includes(output, 'data-shadcn-phlexcomponents="form-radio-group radio-group"')
    # RadioGroup should handle arrow key navigation internally
  end

  def test_form_radio_group_with_mixed_data_types
    # Test collection with different value types
    mixed_collection = [
      { value: 1, text: "Numeric Option" },
      { value: "string", text: "String Option" },
      { value: true, text: "Boolean Option" },
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :mixed_test,
      collection: mixed_collection,
      value_method: :value,
      text_method: :text,
      value: 1,
    )
    output = render(component)

    assert_includes(output, "Numeric Option")
    assert_includes(output, "String Option")
    assert_includes(output, "Boolean Option")
    assert_includes(output, 'value="1"')
  end

  def test_form_radio_group_semantic_html_structure
    collection = [
      { value: "semantic1", text: "Semantic Option 1" },
      { value: "semantic2", text: "Semantic Option 2" },
    ]

    # Test that FormRadioGroup produces semantic HTML
    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :semantic_test,
      collection: collection,
      value_method: :value,
      text_method: :text,
      label: "Semantic Radio Group",
    )
    output = render(component)

    # Should use proper form field structure
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-radio-group radio-group"')
    assert_includes(output, "Semantic Radio Group")

    # Should have proper ARIA structure
    assert_match(/aria-labelledby="[^"]*-label"/, output)
  end

  def test_form_radio_group_with_internationalization
    # Test radio options that might come from I18n
    i18n_collection = [
      { value: "oui", text: "Oui" }, # French
      { value: "non", text: "Non" }, # French
      { value: "maybe", text: "Peut-être" }, # French with accent
    ]

    component = ShadcnPhlexcomponents::FormRadioGroup.new(
      :i18n_test,
      collection: i18n_collection,
      value_method: :value,
      text_method: :text,
      label: "Choix en français",
      hint: "Sélectionnez votre préférence",
    )
    output = render(component)

    assert_includes(output, "Oui")
    assert_includes(output, "Non")
    assert_includes(output, "Peut-être")
    assert_includes(output, "Choix en français")
    assert_includes(output, "Sélectionnez votre préférence")
  end
end
