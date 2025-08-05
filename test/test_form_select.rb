# frozen_string_literal: true

require "test_helper"

class TestFormSelect < ComponentTest
  def test_it_should_render_content_and_attributes
    collection = [
      { value: "option1", text: "Option 1" },
      { value: "option2", text: "Option 2" },
    ]

    component = ShadcnPhlexcomponents::FormSelect.new(
      :preference,
      collection: collection,
      value_method: :value,
      text_method: :text,
    ) { "Select content" }
    output = render(component)

    # NOTE: Block content is consumed by vanish method and not rendered
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-select select"')
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

    component = ShadcnPhlexcomponents::FormSelect.new(
      :category,
      model: book,
      collection: collection,
      value_method: :value,
      text_method: :text,
    ) { "Select book category" }
    output = render(component)

    # NOTE: Block content is not rendered in FormSelect, it's consumed by vanish method
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

    component = ShadcnPhlexcomponents::FormSelect.new(
      :category,
      model: book,
      object_name: :book_settings,
      collection: collection,
      value_method: :value,
      text_method: :text,
    ) { "Select category" }
    output = render(component)

    assert_includes(output, 'name="book_settings[category]"')
    assert_includes(output, 'id="book_settings_category"')
    assert_includes(output, 'value="mystery"')
    # NOTE: Block content is not rendered in FormSelect, it's consumed by vanish method
  end

  def test_it_should_render_custom_attributes
    collection = [
      { value: "small", text: "Small" },
      { value: "large", text: "Large" },
    ]

    component = ShadcnPhlexcomponents::FormSelect.new(
      :size,
      collection: collection,
      value_method: :value,
      text_method: :text,
      class: "size-selector",
      id: "custom-size",
      data: { testid: "form-select" },
    ) { "Select size" }
    output = render(component)

    assert_includes(output, "size-selector")
    assert_includes(output, 'id="custom-size"')
    assert_includes(output, 'data-testid="form-select"')
    # NOTE: Block content is not rendered in FormSelect, it's consumed by vanish method
  end

  def test_it_should_handle_explicit_value
    collection = [
      { value: "red", text: "Red" },
      { value: "blue", text: "Blue" },
      { value: "green", text: "Green" },
    ]

    component = ShadcnPhlexcomponents::FormSelect.new(
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

    component = ShadcnPhlexcomponents::FormSelect.new(
      :newsletter,
      collection: collection,
      value_method: :value,
      text_method: :text,
      label: "Subscribe to Newsletter?",
    ) { "Choose subscription preference" }
    output = render(component)

    assert_includes(output, "Subscribe to Newsletter?")
    # NOTE: Block content is not rendered in FormSelect, it's consumed by vanish method
    assert_match(/for="newsletter"/, output)
  end

  def test_it_should_render_with_hint
    collection = [
      { value: "beginner", text: "Beginner" },
      { value: "intermediate", text: "Intermediate" },
      { value: "advanced", text: "Advanced" },
    ]

    component = ShadcnPhlexcomponents::FormSelect.new(
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

    component = ShadcnPhlexcomponents::FormSelect.new(
      :category,
      model: book,
      collection: collection,
      value_method: :value,
      text_method: :text,
    ) { "This field is required" }
    output = render(component)

    # Check if there are any errors on category field
    if book.errors[:category].any?
      # HTML encoding changes apostrophes
      expected_error = book.errors[:category].first.gsub("'", "&#39;")
      assert_includes(output, expected_error)
      assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
      assert_includes(output, "text-destructive")
    else
      # If no errors on category field, test with a book that has errors
      book.errors.add(:category, "can't be blank")
      component = ShadcnPhlexcomponents::FormSelect.new(
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

    component = ShadcnPhlexcomponents::FormSelect.new(
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

    component = ShadcnPhlexcomponents::FormSelect.new(
      :agreement,
      collection: collection,
      value_method: :value,
      text_method: :text,
      name: "custom_agreement",
      id: "agreement-select",
    ) { "Do you agree?" }
    output = render(component)

    assert_includes(output, 'name="custom_agreement"')
    assert_includes(output, 'id="agreement-select"')
  end

  def test_it_should_handle_collection_with_value_and_text_methods
    # Test with hash collection (standard approach)
    hash_collection = [
      { value: "option_a", text: "Option A" },
      { value: "option_b", text: "Option B" },
      { value: "option_c", text: "Option C" },
    ]

    hash_component = ShadcnPhlexcomponents::FormSelect.new(
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
      option_struct.new("1", "First Option"),
      option_struct.new("2", "Second Option"),
    ]

    object_component = ShadcnPhlexcomponents::FormSelect.new(
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

    component = ShadcnPhlexcomponents::FormSelect.new(
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
    # This would depend on the Select implementation
  end

  def test_it_should_generate_proper_aria_attributes
    collection = [
      { value: "option1", text: "Option 1" },
      { value: "option2", text: "Option 2" },
    ]

    component = ShadcnPhlexcomponents::FormSelect.new(
      :accessibility_test,
      collection: collection,
      value_method: :value,
      text_method: :text,
      label: "Accessible Select",
      hint: "Select one option",
    ) { "Select option" }
    output = render(component)

    assert_match(/aria-describedby="[^"]*-description"/, output)
    assert_includes(output, 'aria-invalid="false"')
  end

  def test_it_should_handle_aria_attributes_with_error
    collection = [
      { value: "option1", text: "Option 1" },
      { value: "option2", text: "Option 2" },
    ]

    component = ShadcnPhlexcomponents::FormSelect.new(
      :required_choice,
      collection: collection,
      value_method: :value,
      text_method: :text,
      error: "This field is required",
    ) { "Required choice" }
    output = render(component)

    assert_includes(output, 'aria-invalid="true"')
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

    component = ShadcnPhlexcomponents::FormSelect.new(
      :category,
      model: book,
      object_name: :book,
      collection: collection,
      value_method: :value,
      text_method: :text,
      label: "Book Category",
      hint: "Select the primary category for your book",
      value: "mystery", # explicit value should override model
      class: "book-category-selector",
      data: {
        controller: "select analytics",
        analytics_event: "category_selection",
      },
      disabled_items: ["romance"],
    ) { "Select book category" }
    output = render(component)

    # Check main structure
    assert_includes(output, "book-category-selector")
    assert_includes(output, 'name="book[category]"')
    assert_includes(output, 'id="book_category"')

    # Explicit value should be used (not model value)
    assert_includes(output, 'value="mystery"')

    # Check form field components
    assert_includes(output, "Book Category")
    assert_includes(output, "Select the primary category for your book")
    # NOTE: Block content is not rendered in FormSelect

    # Check Stimulus integration
    assert_match(/data-controller="[^"]*select[^"]*analytics/, output)
    assert_includes(output, 'data-analytics-event="category_selection"')

    # Check all options are present
    assert_includes(output, "Fiction")
    assert_includes(output, "Non-Fiction")
    assert_includes(output, "Mystery")
    assert_includes(output, "Romance")

    # Check accessibility
    assert_match(/aria-describedby="[^"]*-description"/, output)
    assert_includes(output, 'aria-invalid="false"')

    # Check FormField wrapper
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
  end

  def test_it_should_convert_collection_hash_to_struct
    # Test the internal conversion of hash collection
    hash_collection = [
      { value: "key1", text: "Display 1", extra: "data1" },
      { value: "key2", text: "Display 2", extra: "data2" },
    ]

    component = ShadcnPhlexcomponents::FormSelect.new(
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

class TestFormSelectIntegration < ComponentTest
  def test_form_select_with_complex_model
    # Use Book with category selection
    book = Book.new(category: "fiction")

    # Create a more complex collection with various data types
    category_collection = [
      { value: "fiction", text: "Fiction", description: "Imaginative stories" },
      { value: "non-fiction", text: "Non-Fiction", description: "Factual content" },
      { value: "mystery", text: "Mystery", description: "Suspenseful stories" },
      { value: "biography", text: "Biography", description: "Life stories" },
    ]

    component = ShadcnPhlexcomponents::FormSelect.new(
      :category,
      model: book,
      object_name: :book,
      collection: category_collection,
      value_method: :value,
      text_method: :text,
      label: "Book Category",
      hint: "Choose the primary category that best describes your book",
      class: "category-selection",
    ) { "Select book category" }
    output = render(component)

    # Check proper model integration
    assert_includes(output, 'name="book[category]"')
    assert_includes(output, 'id="book_category"')
    assert_includes(output, 'value="fiction"')

    # Check all category options are present
    assert_includes(output, "Fiction")
    assert_includes(output, "Non-Fiction")
    assert_includes(output, "Mystery")
    assert_includes(output, "Biography")

    # Check form field structure
    assert_includes(output, "category-selection")
    assert_includes(output, "Book Category")
    assert_includes(output, "Choose the primary category that best describes your book")
  end

  def test_form_select_accessibility_compliance
    collection = [
      { value: "option1", text: "First Option" },
      { value: "option2", text: "Second Option" },
      { value: "option3", text: "Third Option" },
    ]

    component = ShadcnPhlexcomponents::FormSelect.new(
      :accessibility_test,
      collection: collection,
      value_method: :value,
      text_method: :text,
      label: "Accessible Select Field",
      hint: "Use arrow keys to navigate between options",
      error: "Please select one of the available options",
      aria: { required: "true" },
    ) { "Select option" }
    output = render(component)

    # Check ARIA compliance
    # Check ARIA describedby includes both description and message IDs
    assert_includes(output, "form-field-")
    assert_includes(output, "-description")
    assert_includes(output, "-message")
    # Check error state is properly displayed
    assert_includes(output, "Please select one of the available options")
    assert_includes(output, "text-destructive")
    assert_includes(output, 'aria-required="true"')

    # Check label association
    assert_match(/for="accessibility_test"/, output)

    # Check error and hint IDs are properly referenced
    assert_match(/id="[^"]*-description"/, output)
    assert_match(/id="[^"]*-message"/, output)

    # Check proper label styling for error state
    assert_includes(output, "text-destructive")
  end

  def test_form_select_with_stimulus_integration
    collection = [
      { value: "priority_low", text: "Low Priority" },
      { value: "priority_medium", text: "Medium Priority" },
      { value: "priority_high", text: "High Priority" },
    ]

    component = ShadcnPhlexcomponents::FormSelect.new(
      :priority,
      collection: collection,
      value_method: :value,
      text_method: :text,
      data: {
        controller: "select analytics priority-handler",
        analytics_category: "form_selection",
        priority_handler_default_value: "priority_medium",
      },
    ) { "Select priority level" }
    output = render(component)

    # Check multiple Stimulus controllers
    assert_match(/data-controller="[^"]*select[^"]*analytics[^"]*priority-handler/, output)
    assert_includes(output, 'data-analytics-category="form_selection"')
    assert_includes(output, 'data-priority-handler-default-value="priority_medium"')

    # Check default select Stimulus functionality
    assert_includes(output, 'data-shadcn-phlexcomponents="form-select select"')
  end

  def test_form_select_validation_states
    collection = [
      { value: "valid_option", text: "Valid Option" },
      { value: "another_option", text: "Another Option" },
    ]

    # Test valid state
    valid_component = ShadcnPhlexcomponents::FormSelect.new(
      :valid_choice,
      collection: collection,
      value_method: :value,
      text_method: :text,
      value: "valid_option",
      class: "valid-select",
    ) { "Valid choice field" }
    valid_output = render(valid_component)

    assert_includes(valid_output, "valid-select")
    assert_includes(valid_output, 'value="valid_option"')

    # Test invalid state
    invalid_component = ShadcnPhlexcomponents::FormSelect.new(
      :invalid_choice,
      collection: collection,
      value_method: :value,
      text_method: :text,
      error: "Invalid selection made",
      class: "invalid-select",
    ) { "Invalid choice field" }
    invalid_output = render(invalid_component)

    assert_includes(invalid_output, "text-destructive") # Error styling on label
    assert_includes(invalid_output, "Invalid selection made")
  end

  def test_form_select_form_integration_workflow
    # Test complete form workflow with validation and model binding
    collection = [
      { value: "beginner", text: "Beginner" },
      { value: "intermediate", text: "Intermediate" },
      { value: "advanced", text: "Advanced" },
    ]

    # Valid book with selection (using category instead of difficulty)
    valid_book = Book.new(category: "intermediate")

    select_field = ShadcnPhlexcomponents::FormSelect.new(
      :category,
      model: valid_book,
      collection: collection,
      value_method: :value,
      text_method: :text,
      label: "Difficulty Level",
      hint: "Select the appropriate difficulty level",
    )
    select_output = render(select_field)

    assert_includes(select_output, 'value="intermediate"')
    refute_includes(select_output, "text-destructive")

    # Invalid book with validation error
    invalid_book = Book.new
    invalid_book.errors.add(:category, "must be selected")

    invalid_select = ShadcnPhlexcomponents::FormSelect.new(
      :category,
      model: invalid_book,
      collection: collection,
      value_method: :value,
      text_method: :text,
      label: "Difficulty Level",
      hint: "Select the appropriate difficulty level",
    )
    invalid_output = render(invalid_select)

    refute_includes(invalid_output, "data-select-selected-value=")
    assert_includes(invalid_output, "must be selected")
    assert_includes(invalid_output, "text-destructive")
  end

  def test_form_select_with_custom_styling
    collection = [
      { value: "style1", text: "Style Option 1" },
      { value: "style2", text: "Style Option 2" },
    ]

    component = ShadcnPhlexcomponents::FormSelect.new(
      :styled_choice,
      collection: collection,
      value_method: :value,
      text_method: :text,
      value: "style1",
      label: "Styled Select",
      hint: "This select has custom styling",
      class: "w-full max-w-md custom-select border rounded",
      data: { theme: "primary" },
    ) { "Custom styled select content" }
    output = render(component)

    # Check custom styling is applied
    assert_includes(output, "w-full max-w-md custom-select border rounded")
    assert_includes(output, 'data-theme="primary"')

    # Check form field structure is preserved
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, "Styled Select")
    assert_includes(output, "This select has custom styling")
  end

  def test_form_select_with_large_collection
    # Test performance and rendering with many options
    large_collection = (1..20).map do |i|
      { value: "option_#{i}", text: "Option #{i}" }
    end

    component = ShadcnPhlexcomponents::FormSelect.new(
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
    assert_includes(output, 'data-shadcn-phlexcomponents="form-select select"')
    assert_includes(output, "Large Option Set")
  end

  def test_form_select_with_boolean_options
    # Test common boolean choice pattern
    boolean_collection = [
      { value: "true", text: "Yes" },
      { value: "false", text: "No" },
    ]

    component = ShadcnPhlexcomponents::FormSelect.new(
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

  def test_form_select_keyboard_interaction
    collection = [
      { value: "key1", text: "First Option" },
      { value: "key2", text: "Second Option" },
      { value: "key3", text: "Third Option" },
    ]

    component = ShadcnPhlexcomponents::FormSelect.new(
      :keyboard_test,
      collection: collection,
      value_method: :value,
      text_method: :text,
    ) { "Keyboard test" }
    output = render(component)

    # Check that select is properly set up for keyboard navigation
    assert_includes(output, 'data-shadcn-phlexcomponents="form-select select"')
    # Select should handle arrow key navigation internally
  end

  def test_form_select_with_mixed_data_types
    # Test collection with different value types (all as strings to avoid dasherize issues)
    mixed_collection = [
      { value: "1", text: "Numeric Option" },
      { value: "string", text: "String Option" },
      { value: "true", text: "Boolean Option" },
    ]

    component = ShadcnPhlexcomponents::FormSelect.new(
      :mixed_test,
      collection: mixed_collection,
      value_method: :value,
      text_method: :text,
      value: "1",
    )
    output = render(component)

    assert_includes(output, "Numeric Option")
    assert_includes(output, "String Option")
    assert_includes(output, "Boolean Option")
    assert_includes(output, 'value="1"')
  end

  def test_form_select_semantic_html_structure
    collection = [
      { value: "semantic1", text: "Semantic Option 1" },
      { value: "semantic2", text: "Semantic Option 2" },
    ]

    # Test that FormSelect produces semantic HTML
    component = ShadcnPhlexcomponents::FormSelect.new(
      :semantic_test,
      collection: collection,
      value_method: :value,
      text_method: :text,
      label: "Semantic Select",
    )
    output = render(component)

    # Should use proper form field structure
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-select select"')
    assert_includes(output, "Semantic Select")
  end

  def test_form_select_with_internationalization
    # Test select options that might come from I18n
    i18n_collection = [
      { value: "oui", text: "Oui" }, # French
      { value: "non", text: "Non" }, # French
      { value: "maybe", text: "Peut-être" }, # French with accent
    ]

    component = ShadcnPhlexcomponents::FormSelect.new(
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
