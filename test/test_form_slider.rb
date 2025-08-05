# frozen_string_literal: true

require "test_helper"

class TestFormSlider < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::FormSlider.new(
      :volume,
    ) { "Slider content" }
    output = render(component)

    # NOTE: Block content is consumed by vanish method and not rendered
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-slider slider"')
    assert_includes(output, 'name="volume"')
    assert_includes(output, 'id="volume"')
    assert_match(%r{<div[^>]*>.*</div>}m, output)
  end

  def test_it_should_render_with_model_and_method
    book = Book.new(discount: 15)

    component = ShadcnPhlexcomponents::FormSlider.new(
      :discount,
      model: book,
    ) { "Select discount percentage" }
    output = render(component)

    # NOTE: Block content is not rendered in FormSlider, it's consumed by vanish method
    assert_includes(output, 'name="discount"')
    assert_includes(output, 'id="discount"')
    assert_includes(output, 'value="15"')
  end

  def test_it_should_handle_object_name_with_model
    book = Book.new(discount: 20)

    component = ShadcnPhlexcomponents::FormSlider.new(
      :discount,
      model: book,
      object_name: :book_settings,
    ) { "Select discount" }
    output = render(component)

    assert_includes(output, 'name="book_settings[discount]"')
    assert_includes(output, 'id="book_settings_discount"')
    assert_includes(output, 'value="20"')
    # NOTE: Block content is not rendered in FormSlider, it's consumed by vanish method
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::FormSlider.new(
      :brightness,
      class: "brightness-slider",
      id: "custom-brightness",
      data: { testid: "form-slider" },
    ) { "Adjust brightness" }
    output = render(component)

    assert_includes(output, "brightness-slider")
    assert_includes(output, 'id="custom-brightness"')
    assert_includes(output, 'data-testid="form-slider"')
    # NOTE: Block content is not rendered in FormSlider, it's consumed by vanish method
  end

  def test_it_should_handle_explicit_value
    component = ShadcnPhlexcomponents::FormSlider.new(
      :opacity,
      value: 75,
    ) { "Set opacity" }
    output = render(component)

    assert_includes(output, 'name="opacity"')
    assert_includes(output, 'value="75"')
  end

  def test_it_should_render_with_label
    component = ShadcnPhlexcomponents::FormSlider.new(
      :temperature,
      label: "Temperature Setting",
    ) { "Adjust temperature" }
    output = render(component)

    assert_includes(output, "Temperature Setting")
    # NOTE: Block content is not rendered in FormSlider, it's consumed by vanish method
    assert_match(/for="temperature"/, output)
  end

  def test_it_should_render_with_hint
    component = ShadcnPhlexcomponents::FormSlider.new(
      :volume,
      hint: "Drag the slider to adjust volume level",
    ) { "Set volume" }
    output = render(component)

    assert_includes(output, "Drag the slider to adjust volume level")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    assert_match(/id="[^"]*-description"/, output)
  end

  def test_it_should_render_with_error_from_model
    book = Book.new
    book.valid? # trigger validation errors

    component = ShadcnPhlexcomponents::FormSlider.new(
      :discount,
      model: book,
    ) { "This field is required" }
    output = render(component)

    # Check if there are any errors on discount field
    if book.errors[:discount].any?
      # HTML encoding changes apostrophes
      expected_error = book.errors[:discount].first.gsub("'", "&#39;")
      assert_includes(output, expected_error)
      assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
      assert_includes(output, "text-destructive")
    else
      # If no errors on discount field, test with a book that has errors
      book.errors.add(:discount, "must be a number")
      component = ShadcnPhlexcomponents::FormSlider.new(
        :discount,
        model: book,
      )
      output = render(component)
      assert_includes(output, "must be a number")
      assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    end
  end

  def test_it_should_render_with_explicit_error
    component = ShadcnPhlexcomponents::FormSlider.new(
      :volume,
      error: "Volume level is invalid",
    ) { "Set volume level" }
    output = render(component)

    assert_includes(output, "Volume level is invalid")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_it_should_render_with_custom_name_and_id
    component = ShadcnPhlexcomponents::FormSlider.new(
      :brightness,
      name: "custom_brightness",
      id: "brightness-slider",
    ) { "Adjust brightness" }
    output = render(component)

    assert_includes(output, 'name="custom_brightness"')
    assert_includes(output, 'id="brightness-slider"')
  end

  def test_it_should_handle_range_slider
    component = ShadcnPhlexcomponents::FormSlider.new(
      :min_price,
      :max_price,
      range: true,
      value: [10, 100],
    ) { "Select price range" }
    output = render(component)

    assert_includes(output, 'name="min_price"')
    assert_includes(output, 'name="max_price"')
    # Check range-specific attributes
    assert_includes(output, 'range="true"')
    # The value should be an array for range sliders
    # This would depend on the Slider implementation
  end

  def test_it_should_handle_range_slider_with_model
    book = Book.new(min_price: 5, max_price: 50)

    component = ShadcnPhlexcomponents::FormSlider.new(
      :min_price,
      :max_price,
      model: book,
      object_name: :book,
      range: true,
    ) { "Select price range" }
    output = render(component)

    assert_includes(output, 'name="book[min_price]"')
    assert_includes(output, 'name="book[max_price]"')
    # Should use model values for both endpoints
    # This would depend on the Slider implementation
  end

  def test_it_should_generate_proper_aria_attributes
    component = ShadcnPhlexcomponents::FormSlider.new(
      :accessibility_test,
      label: "Accessible Slider",
      hint: "Use arrow keys to adjust value",
    ) { "Adjust value" }
    output = render(component)

    assert_match(/aria-describedby="[^"]*-description"/, output)
    assert_includes(output, 'aria-invalid="false"')
  end

  def test_it_should_handle_aria_attributes_with_error
    component = ShadcnPhlexcomponents::FormSlider.new(
      :required_slider,
      error: "This field is required",
    ) { "Required slider" }
    output = render(component)

    assert_includes(output, 'aria-invalid="true"')
    assert_match(/aria-describedby="[^"]*-message"/, output)
  end

  def test_it_should_render_complete_form_structure
    book = Book.new(discount: 15)

    component = ShadcnPhlexcomponents::FormSlider.new(
      :discount,
      model: book,
      object_name: :book,
      label: "Discount Percentage",
      hint: "Drag to set discount percentage",
      value: 25, # explicit value should override model
      class: "discount-slider",
      data: {
        controller: "slider analytics",
        analytics_event: "discount_change",
      },
      min: 0,
      max: 100,
      step: 5,
    ) { "Set discount" }
    output = render(component)

    # Check main structure
    assert_includes(output, "discount-slider")
    assert_includes(output, 'name="book[discount]"')
    assert_includes(output, 'id="book_discount"')

    # Explicit value should be used (not model value)
    assert_includes(output, 'value="25"')

    # Check form field components
    assert_includes(output, "Discount Percentage")
    assert_includes(output, "Drag to set discount percentage")
    # NOTE: Block content is not rendered in FormSlider

    # Check Stimulus integration
    assert_match(/data-controller="[^"]*slider[^"]*analytics/, output)
    assert_includes(output, 'data-analytics-event="discount_change"')

    # Check slider specific attributes
    assert_includes(output, 'min="0"')
    assert_includes(output, 'max="100"')
    assert_includes(output, 'step="5"')

    # Check accessibility
    assert_match(/aria-describedby="[^"]*-description"/, output)
    assert_includes(output, 'aria-invalid="false"')

    # Check FormField wrapper
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::FormSlider.new(
      :disabled_slider,
      disabled: true,
    ) { "Disabled slider" }
    output = render(component)

    assert_includes(output, "disabled")
  end

  def test_it_should_handle_range_with_custom_label
    component = ShadcnPhlexcomponents::FormSlider.new(
      :min_price,
      :max_price,
      range: true,
      label: "Price Range",
    )
    output = render(component)

    assert_includes(output, "Price Range")
    # In range mode, should handle both field names properly
  end

  def test_it_should_handle_range_with_errors
    book = Book.new
    book.errors.add(:min_price, "must be greater than 0")
    book.errors.add(:max_price, "must be less than 1000")

    component = ShadcnPhlexcomponents::FormSlider.new(
      :min_price,
      :max_price,
      model: book,
      range: true,
    )
    output = render(component)

    # Should show both errors
    assert_includes(output, "must be greater than 0")
    assert_includes(output, "must be less than 1000")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_it_should_handle_block_content_with_label_and_hint
    component = ShadcnPhlexcomponents::FormSlider.new(
      :custom_slider,
    ) do |slider|
      slider.label("Custom Slider Label", class: "font-semibold")
      slider.hint("Custom hint text", class: "text-sm text-gray-500")
      "Custom slider content"
    end
    output = render(component)

    assert_includes(output, "Custom Slider Label")
    assert_includes(output, "font-semibold")
    assert_includes(output, "Custom hint text")
    assert_includes(output, "text-sm text-gray-500")
    # NOTE: Block content is not rendered in FormSlider, the returned string is consumed by vanish method

    # Should have data attributes for removing duplicates
    assert_includes(output, "data-remove-hint")
  end
end

class TestFormSliderIntegration < ComponentTest
  def test_form_slider_with_complex_model
    # Use Book with numeric attributes
    book = Book.new(
      discount: 15,
      min_price: 10,
      max_price: 100,
    )

    # Test discount slider
    discount_component = ShadcnPhlexcomponents::FormSlider.new(
      :discount,
      model: book,
      object_name: :book,
      label: "Discount Percentage",
      hint: "Set the discount percentage for this book",
      class: "discount-slider",
    ) { "Set discount" }
    discount_output = render(discount_component)

    # Check proper model integration
    assert_includes(discount_output, 'name="book[discount]"')
    assert_includes(discount_output, 'id="book_discount"')
    assert_includes(discount_output, 'value="15"')

    # Price range slider
    price_range_component = ShadcnPhlexcomponents::FormSlider.new(
      :min_price,
      :max_price,
      model: book,
      object_name: :book,
      range: true,
      label: "Price Range",
    ) { "Set price range" }
    price_range_output = render(price_range_component)

    assert_includes(price_range_output, 'name="book[min_price]"')
    assert_includes(price_range_output, 'name="book[max_price]"')
    # Should handle range values from model

    # Check form field structure
    assert_includes(discount_output, "discount-slider")
    assert_includes(discount_output, "Discount Percentage")
    assert_includes(discount_output, "Set the discount percentage for this book")
  end

  def test_form_slider_accessibility_compliance
    component = ShadcnPhlexcomponents::FormSlider.new(
      :accessibility_test,
      label: "Accessible Slider Control",
      hint: "Use left and right arrow keys to adjust the value",
      error: "Please select a valid range",
      aria: { required: "true" },
    ) { "Adjust value" }
    output = render(component)

    # Check ARIA compliance
    # Check ARIA describedby includes both description and message IDs
    assert_includes(output, "form-field-")
    assert_includes(output, "-description")
    assert_includes(output, "-message")
    # Check error state is properly displayed
    assert_includes(output, "Please select a valid range")
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

  def test_form_slider_with_stimulus_integration
    component = ShadcnPhlexcomponents::FormSlider.new(
      :stimulus_slider,
      data: {
        controller: "slider analytics formatter",
        analytics_category: "form_slider",
        formatter_type_value: "percentage",
      },
    ) { "Adjust percentage" }
    output = render(component)

    # Check multiple Stimulus controllers
    assert_match(/data-controller="[^"]*slider[^"]*analytics[^"]*formatter/, output)
    assert_includes(output, 'data-analytics-category="form_slider"')
    assert_includes(output, 'data-formatter-type-value="percentage"')

    # Check default slider Stimulus functionality
    assert_includes(output, 'data-shadcn-phlexcomponents="form-slider slider"')
  end

  def test_form_slider_validation_states
    # Test valid state
    valid_component = ShadcnPhlexcomponents::FormSlider.new(
      :valid_slider,
      value: 50,
      class: "valid-slider",
    ) { "Valid slider field" }
    valid_output = render(valid_component)

    assert_includes(valid_output, 'aria-invalid="false"')
    assert_includes(valid_output, "valid-slider")

    # Test invalid state
    invalid_component = ShadcnPhlexcomponents::FormSlider.new(
      :invalid_slider,
      error: "Value is out of range",
      class: "invalid-slider",
    ) { "Invalid slider field" }
    invalid_output = render(invalid_component)

    assert_includes(invalid_output, 'aria-invalid="true"')
    assert_includes(invalid_output, "text-destructive") # Error styling on label
  end

  def test_form_slider_form_integration_workflow
    # Test complete form workflow with validation and model binding

    # Valid book with numeric value
    valid_book = Book.new(discount: 25)

    slider_field = ShadcnPhlexcomponents::FormSlider.new(
      :discount,
      model: valid_book,
      label: "Discount Rate",
      hint: "Select the discount percentage",
    )
    slider_output = render(slider_field)

    assert_includes(slider_output, 'value="25"')
    assert_includes(slider_output, 'aria-invalid="false"')
    refute_includes(slider_output, "text-destructive")

    # Invalid book with validation error
    invalid_book = Book.new
    invalid_book.errors.add(:discount, "must be between 0 and 100")

    invalid_slider = ShadcnPhlexcomponents::FormSlider.new(
      :discount,
      model: invalid_book,
      label: "Discount Rate",
      hint: "Select the discount percentage",
    )
    invalid_output = render(invalid_slider)

    refute_includes(invalid_output, "value=")
    assert_includes(invalid_output, 'aria-invalid="true"')
    assert_includes(invalid_output, "must be between 0 and 100")
    assert_includes(invalid_output, "text-destructive")
  end

  def test_form_slider_with_custom_styling
    component = ShadcnPhlexcomponents::FormSlider.new(
      :styled_slider,
      value: 75,
      label: "Styled Slider",
      hint: "This slider has custom styling",
      class: "w-full max-w-md custom-slider border rounded",
      data: { theme: "primary" },
    ) { "Custom styled slider content" }
    output = render(component)

    # Check custom styling is applied
    assert_includes(output, "w-full max-w-md custom-slider border rounded")
    assert_includes(output, 'data-theme="primary"')

    # Check form field structure is preserved
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, "Styled Slider")
    assert_includes(output, "This slider has custom styling")
  end

  def test_form_slider_range_functionality
    # Test range slider with proper model integration
    book = Book.new(min_price: 20, max_price: 80)

    range_component = ShadcnPhlexcomponents::FormSlider.new(
      :min_price,
      :max_price,
      model: book,
      object_name: :book,
      range: true,
      label: "Price Range",
      hint: "Set minimum and maximum prices",
      min: 0,
      max: 100,
    )
    range_output = render(range_component)

    # Check range-specific structure
    assert_includes(range_output, 'name="book[min_price]"')
    assert_includes(range_output, 'name="book[max_price]"')
    assert_includes(range_output, 'range="true"')
    assert_includes(range_output, "Price Range")
    assert_includes(range_output, "Set minimum and maximum prices")

    # Check min/max constraints
    assert_includes(range_output, 'min="0"')
    assert_includes(range_output, 'max="100"')
  end

  def test_form_slider_keyboard_interaction
    component = ShadcnPhlexcomponents::FormSlider.new(
      :keyboard_test,
    ) { "Keyboard test" }
    output = render(component)

    # Check keyboard interaction setup
    assert_includes(output, 'data-shadcn-phlexcomponents="form-slider slider"')
    # Slider should handle arrow key navigation internally
  end

  def test_form_slider_with_step_values
    component = ShadcnPhlexcomponents::FormSlider.new(
      :stepped_slider,
      min: 0,
      max: 100,
      step: 10,
      value: 50,
    )
    output = render(component)

    assert_includes(output, 'min="0"')
    assert_includes(output, 'max="100"')
    assert_includes(output, 'step="10"')
    assert_includes(output, 'value="50"')
  end

  def test_form_slider_semantic_html_structure
    # Test that FormSlider produces semantic HTML
    component = ShadcnPhlexcomponents::FormSlider.new(
      :semantic_test,
      label: "Semantic Slider",
    )
    output = render(component)

    # Should use proper form field structure
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-slider slider"')
    assert_includes(output, "Semantic Slider")
  end

  def test_form_slider_with_decimal_values
    component = ShadcnPhlexcomponents::FormSlider.new(
      :decimal_test,
      value: 3.14,
      min: 0.0,
      max: 10.0,
      step: 0.1,
    )
    output = render(component)

    assert_includes(output, 'value="3.14"')
    assert_includes(output, 'min="0.0"')
    assert_includes(output, 'max="10.0"')
    assert_includes(output, 'step="0.1"')
  end

  def test_form_slider_label_generation_for_range
    # Test automatic label generation for range sliders
    component = ShadcnPhlexcomponents::FormSlider.new(
      :start_time,
      :end_time,
      range: true,
    )
    output = render(component)

    # Should generate label from method names
    # This would depend on the specific label generation logic
    # The component should handle converting [:start_time, :end_time] to readable text
    assert_includes(output, 'data-shadcn-phlexcomponents="form-slider slider"')
  end
end
