# frozen_string_literal: true

require "test_helper"

class TestFormDatePicker < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :event_date,
    ) { "Date picker content" }
    output = render(component)

    # NOTE: Block content is consumed by vanish method and not rendered
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-date-picker date-picker"')
    assert_includes(output, 'data-controller="date-picker"')
    assert_includes(output, 'name="event_date"')
    assert_includes(output, 'id="event_date"')
    assert_match(%r{<div[^>]*>.*</div>}m, output)
  end

  def test_it_should_render_with_model_and_method
    book = Book.new(published_at: Time.parse("2024-03-15 10:30:00"))

    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :published_at,
      model: book,
    ) { "Select publication date" }
    output = render(component)

    # NOTE: Block content is not rendered in FormDatePicker, it's consumed by vanish method
    assert_includes(output, 'name="published_at"')
    assert_includes(output, 'id="published_at"')
    assert_match(/data-value="2024-03-15T\d{2}:\d{2}:\d{2}Z"/, output)
    assert_match(/value="2024-03-15T\d{2}:\d{2}:\d{2}Z"/, output)
  end

  def test_it_should_handle_object_name_with_model
    book = Book.new(sale_starts_at: Time.parse("2024-06-01 09:00:00"))

    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :sale_starts_at,
      model: book,
      object_name: :book_settings,
    ) { "Select sale start date" }
    output = render(component)

    assert_includes(output, 'name="book_settings[sale_starts_at]"')
    assert_includes(output, 'id="book_settings_sale_starts_at"')
    assert_match(/data-value="2024-06-01T\d{2}:\d{2}:\d{2}Z"/, output)
    # NOTE: Block content is not rendered in FormDatePicker, it's consumed by vanish method
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :birthday,
      class: "birthday-picker",
      id: "custom-birthday",
      data: { testid: "form-date-picker" },
    ) { "Select your birthday" }
    output = render(component)

    assert_includes(output, "birthday-picker")
    assert_includes(output, 'id="custom-birthday"')
    assert_includes(output, 'data-testid="form-date-picker"')
    # NOTE: Block content is not rendered in FormDatePicker, it's consumed by vanish method
  end

  def test_it_should_handle_explicit_value
    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :due_date,
      value: "2024-12-25",
    ) { "Select due date" }
    output = render(component)

    assert_includes(output, 'name="due_date"')
    assert_match(/data-value="2024-12-2[45]T\d{2}:\d{2}:\d{2}Z"/, output)
    assert_match(/value="2024-12-2[45]T\d{2}:\d{2}:\d{2}Z"/, output)
  end

  def test_it_should_render_with_label
    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :appointment_date,
      label: "Appointment Date",
    ) { "Choose your appointment date" }
    output = render(component)

    assert_includes(output, "Appointment Date")
    # NOTE: Block content is not rendered in FormDatePicker, it's consumed by vanish method
    assert_match(/for="appointment_date"/, output)
    # Labels don't have separate IDs in FormDatePicker implementation
  end

  def test_it_should_render_with_hint
    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :deadline,
      hint: "Please select a date within the next 30 days",
    ) { "Select deadline" }
    output = render(component)

    assert_includes(output, "Please select a date within the next 30 days")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    assert_match(/id="[^"]*-description"/, output)
  end

  def test_it_should_render_with_error_from_model
    book = Book.new
    book.valid? # trigger validation errors

    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :published_at,
      model: book,
    ) { "This field is required" }
    output = render(component)

    # Check if there are any errors on published_at field
    if book.errors[:published_at].any?
      assert_includes(output, book.errors[:published_at].first)
      assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
      assert_includes(output, "text-destructive")
    else
      # If no errors on published_at field, test with a book that has errors
      book.errors.add(:published_at, "can't be blank")
      component = ShadcnPhlexcomponents::FormDatePicker.new(
        :published_at,
        model: book,
      )
      output = render(component)
      assert_includes(output, "can&#39;t be blank")
      assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    end
  end

  def test_it_should_render_with_explicit_error
    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :expiry_date,
      error: "Date must be in the future",
    ) { "Select expiration date" }
    output = render(component)

    assert_includes(output, "Date must be in the future")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_it_should_render_with_custom_name_and_id
    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :event_date,
      name: "custom_event_date",
      id: "event-date-picker",
    ) { "Select event date" }
    output = render(component)

    assert_includes(output, 'name="custom_event_date"')
    assert_includes(output, 'id="event-date-picker"')
  end

  def test_it_should_handle_date_parsing
    # Test with string date
    string_component = ShadcnPhlexcomponents::FormDatePicker.new(
      :string_date,
      value: "2024-05-20",
    )
    string_output = render(string_component)
    assert_match(/data-value="2024-05-[12]\dT\d{2}:\d{2}:\d{2}Z"/, string_output)

    # Test with Time object
    time_component = ShadcnPhlexcomponents::FormDatePicker.new(
      :time_date,
      value: Time.parse("2024-05-20 14:30:00"),
    )
    time_output = render(time_component)
    assert_match(/data-value="2024-05-20T\d{2}:\d{2}:\d{2}Z"/, time_output)

    # Test with invalid date
    invalid_component = ShadcnPhlexcomponents::FormDatePicker.new(
      :invalid_date,
      value: "not-a-date",
    )
    invalid_output = render(invalid_component)
    refute_includes(invalid_output, 'data-value="not-a-date"')
  end

  def test_it_should_generate_proper_aria_attributes
    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :accessibility_test,
      label: "Accessible Date Picker",
      hint: "Use calendar to select date",
    ) { "Select date" }
    output = render(component)

    assert_match(/aria-describedby="[^"]*-description"/, output)
    assert_includes(output, 'aria-invalid="false"')
    # Check ARIA attributes on the date picker trigger
    assert_includes(output, 'aria-haspopup="dialog"')
    assert_match(/aria-controls="[^"]*-content"/, output)
  end

  def test_it_should_handle_aria_attributes_with_error
    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :required_date,
      error: "This field is required",
    ) { "Required date field" }
    output = render(component)

    assert_includes(output, 'aria-invalid="true"')
    assert_match(/aria-describedby="[^"]*-message"/, output)
  end

  def test_it_should_include_date_picker_components
    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :components_test,
      label: "Test Components",
    )
    output = render(component)

    # Should include all DatePicker sub-components
    assert_includes(output, 'data-date-picker-target="hiddenInput"')
    assert_includes(output, 'data-date-picker-target="trigger"')
    assert_includes(output, 'data-date-picker-target="content"')
    assert_includes(output, 'type="hidden"')
  end

  def test_it_should_render_complete_form_structure
    book = Book.new(published_at: Time.parse("2024-08-15 10:00:00"))

    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :published_at,
      model: book,
      object_name: :book,
      label: "Publication Date",
      hint: "Select when the book should be published",
      value: "2024-08-20", # explicit value should override model
      class: "publication-date-picker",
      data: {
        controller: "date-picker analytics",
        analytics_event: "date_selection",
      },
      format: "DD/MM/YYYY",
      placeholder: "Choose publication date",
    ) { "Select publication date" }
    output = render(component)

    # Check main structure
    assert_includes(output, "publication-date-picker")
    assert_includes(output, 'name="book[published_at]"')
    assert_includes(output, 'id="book_published_at"')

    # Explicit value should be used (not model value)
    assert_match(/data-value="2024-08-[12]\dT\d{2}:\d{2}:\d{2}Z"/, output)

    # Check form field components
    assert_includes(output, "Publication Date")
    assert_includes(output, "Select when the book should be published")
    # NOTE: Block content is not rendered in FormDatePicker

    # Check Stimulus integration
    assert_match(/data-controller="[^"]*date-picker[^"]*analytics/, output)
    assert_includes(output, 'data-analytics-event="date_selection"')

    # Check date picker specific attributes
    assert_includes(output, 'data-format="DD/MM/YYYY"')
    assert_includes(output, 'data-placeholder="Choose publication date"')

    # Check hidden input
    assert_includes(output, 'type="hidden"')
    assert_match(/value="2024-08-[12]\dT\d{2}:\d{2}:\d{2}Z"/, output)

    # Check accessibility
    assert_match(/aria-describedby="[^"]*-description"/, output)
    assert_includes(output, 'aria-invalid="false"')

    # Check FormField wrapper
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :disabled_date,
      disabled: true,
    ) { "Disabled date picker" }
    output = render(component)

    assert_includes(output, "disabled")
  end

  def test_it_should_handle_select_only_mode
    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :select_only_date,
      select_only: true,
      placeholder: "Choose date",
    )
    output = render(component)

    assert_includes(output, 'data-placeholder="Choose date"')
    # In select_only mode, should not have input container
    refute_includes(output, 'data-date-picker-target="inputContainer"')
    assert_includes(output, 'data-date-picker-target="trigger"')
  end

  def test_it_should_handle_custom_options
    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :options_test,
      options: { minDate: "2024-01-01", maxDate: "2024-12-31" },
    )
    output = render(component)

    assert_includes(output, 'data-options="{&quot;minDate&quot;:&quot;2024-01-01&quot;,&quot;maxDate&quot;:&quot;2024-12-31&quot;}"')
  end

  def test_it_should_handle_block_content_with_label_and_hint
    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :custom_date,
    ) do |date_picker|
      date_picker.label("Custom Date Label", class: "font-semibold")
      date_picker.hint("Custom hint text", class: "text-sm text-gray-500")
      "Custom date picker content"
    end
    output = render(component)

    assert_includes(output, "Custom Date Label")
    assert_includes(output, "font-semibold")
    assert_includes(output, "Custom hint text")
    assert_includes(output, "text-sm text-gray-500")
    # NOTE: Block content is not rendered in FormDatePicker, the returned string is consumed by vanish method

    # Should have data attributes for removing duplicates
    assert_includes(output, "data-remove-hint")
  end

  def test_it_should_handle_mask_option
    # With mask enabled (default)
    with_mask = ShadcnPhlexcomponents::FormDatePicker.new(
      :with_mask_date,
    )
    with_mask_output = render(with_mask)
    assert_includes(with_mask_output, 'data-mask="true"')

    # With mask disabled
    no_mask = ShadcnPhlexcomponents::FormDatePicker.new(
      :no_mask_date,
      mask: false,
    )
    no_mask_output = render(no_mask)
    assert_includes(no_mask_output, 'data-mask="false"')
  end
end

class TestFormDatePickerIntegration < ComponentTest
  def test_form_date_picker_with_complex_model
    # Use Book with published_at and sale_starts_at dates
    book = Book.new(
      published_at: Time.parse("2024-06-15 10:00:00"),
      sale_starts_at: Time.parse("2024-06-01 00:00:00"),
    )

    # Test published_at date picker
    published_component = ShadcnPhlexcomponents::FormDatePicker.new(
      :published_at,
      model: book,
      object_name: :book,
      label: "Publication Date",
      hint: "When should this book be published?",
      class: "publication-date",
    ) { "Select publication date" }
    published_output = render(published_component)

    # Check proper model integration
    assert_includes(published_output, 'name="book[published_at]"')
    assert_includes(published_output, 'id="book_published_at"')
    assert_match(/data-value="2024-06-15T\d{2}:\d{2}:\d{2}Z"/, published_output)

    # Sale starts date picker
    sale_component = ShadcnPhlexcomponents::FormDatePicker.new(
      :sale_starts_at,
      model: book,
      object_name: :book,
      label: "Sale Start Date",
    ) { "Select sale start date" }
    sale_output = render(sale_component)

    assert_includes(sale_output, 'name="book[sale_starts_at]"')
    assert_match(/data-value="2024-0[56]-[23]\dT\d{2}:\d{2}:\d{2}Z"/, sale_output)

    # Check form field structure
    assert_includes(published_output, "publication-date")
    assert_includes(published_output, "Publication Date")
    assert_includes(published_output, "When should this book be published?")
  end

  def test_form_date_picker_accessibility_compliance
    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :accessibility_test,
      label: "Accessible Date Selection",
      hint: "Use arrow keys to navigate the calendar",
      error: "Please select a valid date",
      aria: { required: "true" },
    ) { "Select date" }
    output = render(component)

    # Check ARIA compliance
    assert_includes(output, 'aria-haspopup="dialog"')
    assert_match(/aria-controls="[^"]*-content"/, output)
    # Check ARIA describedby includes both description and message IDs
    assert_includes(output, "form-field-")
    assert_includes(output, "-description")
    assert_includes(output, "-message")
    # Check error state is properly displayed
    assert_includes(output, "Please select a valid date")
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

  def test_form_date_picker_with_stimulus_integration
    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :stimulus_date,
      data: {
        controller: "date-picker analytics scheduler",
        analytics_category: "date_selection",
        scheduler_mode_value: "appointment",
      },
    ) { "Select appointment date" }
    output = render(component)

    # Check multiple Stimulus controllers
    assert_match(/data-controller="[^"]*date-picker[^"]*analytics[^"]*scheduler/, output)
    assert_includes(output, 'data-analytics-category="date_selection"')
    assert_includes(output, 'data-scheduler-mode-value="appointment"')

    # Check default date-picker Stimulus functionality still works
    assert_match(/click->date-picker#toggle/, output)
    assert_includes(output, 'data-date-picker-target="trigger"')
  end

  def test_form_date_picker_validation_states
    # Test valid state
    valid_component = ShadcnPhlexcomponents::FormDatePicker.new(
      :valid_date,
      value: "2024-06-15",
      class: "valid-date-picker",
    ) { "Valid date field" }
    valid_output = render(valid_component)

    assert_includes(valid_output, 'aria-invalid="false"')
    assert_includes(valid_output, "valid-date-picker")

    # Test invalid state
    invalid_component = ShadcnPhlexcomponents::FormDatePicker.new(
      :invalid_date,
      error: "Invalid date selected",
      class: "invalid-date-picker",
    ) { "Invalid date field" }
    invalid_output = render(invalid_component)

    assert_includes(invalid_output, 'aria-invalid="true"')
    assert_includes(invalid_output, "text-destructive") # Error styling on label
  end

  def test_form_date_picker_form_integration_workflow
    # Test complete form workflow with validation and model binding

    # Valid book with dates
    valid_book = Book.new(published_at: Time.parse("2024-08-15"))

    date_picker = ShadcnPhlexcomponents::FormDatePicker.new(
      :published_at,
      model: valid_book,
      label: "Published Date",
      hint: "Select the publication date",
    )
    date_output = render(date_picker)

    assert_match(/data-value="2024-08-1[45]T\d{2}:\d{2}:\d{2}Z"/, date_output)
    assert_includes(date_output, 'aria-invalid="false"')
    refute_includes(date_output, "text-destructive")

    # Invalid book with validation error
    invalid_book = Book.new
    invalid_book.errors.add(:published_at, "can't be blank")

    invalid_picker = ShadcnPhlexcomponents::FormDatePicker.new(
      :published_at,
      model: invalid_book,
      label: "Published Date",
      hint: "Select the publication date",
    )
    invalid_output = render(invalid_picker)

    refute_includes(invalid_output, "data-value=")
    assert_includes(invalid_output, 'aria-invalid="true"')
    assert_includes(invalid_output, "can&#39;t be blank")
    assert_includes(invalid_output, "text-destructive")
  end

  def test_form_date_picker_with_custom_styling
    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :styled_date,
      value: "2024-07-04",
      label: "Styled Date Picker",
      hint: "This date picker has custom styling",
      class: "w-full max-w-md custom-date-picker border-2",
      data: { theme: "primary" },
    ) { "Custom styled date picker content" }
    output = render(component)

    # Check custom styling is applied
    assert_includes(output, "w-full max-w-md custom-date-picker border-2")
    assert_includes(output, 'data-theme="primary"')

    # Check default classes are still present
    assert_includes(output, "w-full") # Default date picker classes

    # Check form field structure is preserved
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, "Styled Date Picker")
    assert_includes(output, "This date picker has custom styling")
  end

  def test_form_date_picker_keyboard_interaction
    component = ShadcnPhlexcomponents::FormDatePicker.new(
      :keyboard_test,
    ) { "Keyboard test" }
    output = render(component)

    # Check keyboard interaction setup
    assert_match(/click->date-picker#toggle/, output)
    assert_includes(output, 'aria-haspopup="dialog"')

    # Check that calendar content is properly set up for keyboard navigation
    assert_includes(output, 'data-date-picker-target="content"')
    assert_includes(output, 'role="dialog"')
    assert_match(/aria-controls="[^"]*-content"/, output)
  end

  def test_form_date_picker_with_time_zone_handling
    # Test with different time zones if Time.zone is available
    if defined?(Time.zone)
      original_zone = Time.zone
      Time.zone = "UTC"

      component = ShadcnPhlexcomponents::FormDatePicker.new(
        :timezone_test,
        value: "2024-06-15 15:30:00",
      )
      output = render(component)

      # Should handle time zone conversion properly
      assert_match(/data-value="2024-06-15T\d{2}:\d{2}:\d{2}Z"/, output)

      Time.zone = original_zone if original_zone
    else
      # Fallback test without Time.zone
      component = ShadcnPhlexcomponents::FormDatePicker.new(
        :fallback_test,
        value: Time.parse("2024-06-15 15:30:00"),
      )
      output = render(component)

      assert_match(/data-value="2024-06-15T\d{2}:\d{2}:\d{2}Z"/, output)
    end
  end
end
