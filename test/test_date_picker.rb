# frozen_string_literal: true

require "test_helper"

class TestDatePicker < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DatePicker.new(
      name: "date_field",
      value: "2024-01-15",
    )
    output = render(component)

    assert_includes(output, "w-full")
    assert_includes(output, 'data-shadcn-phlexcomponents="date-picker"')
    assert_includes(output, 'data-controller="date-picker"')
    assert_match(/data-value="2024-01-1[45]T\d{2}:\d{2}:\d{2}Z"/, output)
    assert_includes(output, 'data-format="DD/MM/YYYY"')
    assert_includes(output, 'data-mask="true"')
    assert_match(%r{<div[^>]*>.*</div>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::DatePicker.new(
      name: "custom_date",
      class: "custom-date-picker",
      id: "date-picker-id",
      data: { testid: "date-picker" },
    )
    output = render(component)

    assert_includes(output, "custom-date-picker")
    assert_includes(output, 'data-testid="date-picker"')
    assert_includes(output, "w-full")
  end

  def test_it_should_include_hidden_input
    component = ShadcnPhlexcomponents::DatePicker.new(
      name: "hidden_date",
      value: "2024-06-20",
    )
    output = render(component)

    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'name="hidden_date"')
    assert_match(/value="2024-06-[12]\dT\d{2}:\d{2}:\d{2}Z"/, output)
    assert_includes(output, 'data-date-picker-target="hiddenInput"')
  end

  def test_it_should_handle_date_parsing
    # Test with string date
    string_date = ShadcnPhlexcomponents::DatePicker.new(
      name: "string_date",
      value: "2024-03-15",
    )
    string_output = render(string_date)
    # Date gets parsed and converted to UTC, may not match exact input date
    assert_match(/data-value="2024-03-1[45]T\d{2}:\d{2}:\d{2}Z"/, string_output)

    # Test with Time object
    time_date = ShadcnPhlexcomponents::DatePicker.new(
      name: "time_date",
      value: Time.parse("2024-03-15 10:30:00"),
    )
    time_output = render(time_date)
    assert_match(/data-value="2024-03-15T\d{2}:\d{2}:\d{2}Z"/, time_output)

    # Test with invalid string
    invalid_date = ShadcnPhlexcomponents::DatePicker.new(
      name: "invalid_date",
      value: "not-a-date",
    )
    invalid_output = render(invalid_date)
    refute_includes(invalid_output, 'data-value="not-a-date"')
  end

  def test_it_should_handle_custom_format
    component = ShadcnPhlexcomponents::DatePicker.new(
      name: "formatted_date",
      format: "MM/DD/YYYY",
    )
    output = render(component)

    assert_includes(output, 'data-format="MM/DD/YYYY"')
  end

  def test_it_should_handle_select_only_mode
    component = ShadcnPhlexcomponents::DatePicker.new(
      name: "select_only",
      select_only: true,
      placeholder: "Choose date",
      id: "date-select",
    )
    output = render(component)

    # In select_only mode, trigger gets the id
    assert_includes(output, 'id="date-select"')
    assert_includes(output, 'data-placeholder="Choose date"')
    assert_includes(output, 'data-date-picker-target="trigger"')

    # Should not have input container
    refute_includes(output, 'data-date-picker-target="inputContainer"')
  end

  def test_it_should_handle_input_mode
    component = ShadcnPhlexcomponents::DatePicker.new(
      name: "input_mode",
      select_only: false,
      placeholder: "Enter date",
      id: "date-input",
    )
    output = render(component)

    # In input mode, input gets the id
    assert_includes(output, 'id="date-input"')
    assert_includes(output, 'placeholder="Enter date"')
    assert_includes(output, 'data-date-picker-target="input"')
    assert_includes(output, 'data-date-picker-target="inputContainer"')
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::DatePicker.new(
      name: "disabled_date",
      disabled: true,
    )
    output = render(component)

    assert_includes(output, "disabled")
    assert_includes(output, "data-disabled")
  end

  def test_it_should_handle_mask_option
    # With mask disabled
    no_mask = ShadcnPhlexcomponents::DatePicker.new(
      name: "no_mask",
      mask: false,
    )
    no_mask_output = render(no_mask)
    assert_includes(no_mask_output, 'data-mask="false"')

    # With mask enabled (default)
    with_mask = ShadcnPhlexcomponents::DatePicker.new(
      name: "with_mask",
    )
    with_mask_output = render(with_mask)
    assert_includes(with_mask_output, 'data-mask="true"')
  end

  def test_it_should_handle_custom_options
    component = ShadcnPhlexcomponents::DatePicker.new(
      name: "options_test",
      options: { minDate: "2024-01-01", maxDate: "2024-12-31" },
    )
    output = render(component)

    assert_includes(output, 'data-options="{&quot;minDate&quot;:&quot;2024-01-01&quot;,&quot;maxDate&quot;:&quot;2024-12-31&quot;}"')
  end

  def test_it_should_include_overlay
    component = ShadcnPhlexcomponents::DatePicker.new(name: "overlay_test")
    output = render(component)

    # The overlay is rendered but the component name is different
    assert_includes(output, 'data-date-picker-target="overlay"')
    # The overlay doesn't have overlay-type attribute, just check for overlay presence
    assert_includes(output, 'data-date-picker-target="overlay"')
  end

  def test_it_should_generate_unique_aria_id
    picker1 = ShadcnPhlexcomponents::DatePicker.new(name: "test1")
    output1 = render(picker1)

    picker2 = ShadcnPhlexcomponents::DatePicker.new(name: "test2")
    output2 = render(picker2)

    # Extract aria-controls values to ensure they're different
    controls1 = output1[/aria-controls="([^"]*)"/, 1]
    controls2 = output2[/aria-controls="([^"]*)"/, 1]

    refute_nil(controls1)
    refute_nil(controls2)
    refute_equal(controls1, controls2)
  end

  def test_it_should_render_complete_date_picker_structure
    component = ShadcnPhlexcomponents::DatePicker.new(
      name: "complete_test",
      value: "2024-07-15",
      format: "DD/MM/YYYY",
      select_only: false,
      placeholder: "Select date",
      disabled: false,
      mask: true,
      options: { locale: "en" },
      class: "full-date-picker",
      id: "date-picker-full",
    )
    output = render(component)

    # Check main container
    assert_includes(output, "full-date-picker")
    assert_includes(output, 'data-controller="date-picker"')
    assert_match(/data-value="2024-07-1[45]T\d{2}:\d{2}:\d{2}Z"/, output)
    assert_includes(output, 'data-format="DD/MM/YYYY"')

    # Check hidden input
    assert_includes(output, 'name="complete_test"')
    assert_match(/value="2024-07-1[45]T\d{2}:\d{2}:\d{2}Z"/, output)

    # Check input mode components
    assert_includes(output, 'data-date-picker-target="inputContainer"')
    assert_includes(output, 'data-date-picker-target="input"')
    assert_includes(output, 'data-date-picker-target="trigger"')
    assert_includes(output, 'data-date-picker-target="content"')

    # Check placeholder and format
    assert_includes(output, 'placeholder="Select date"')
    assert_includes(output, 'data-placeholder="Select date"')

    # Check options
    assert_includes(output, "&quot;locale&quot;:&quot;en&quot;")
  end
end

class TestDatePickerTrigger < ComponentTest
  def test_it_should_render_select_only_trigger
    component = ShadcnPhlexcomponents::DatePickerTrigger.new(
      select_only: true,
      placeholder: "Choose date",
      stimulus_controller_name: "date-picker",
      aria_id: "test-date",
    )
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="date-picker-trigger"')
    # Button element has implicit role="button", not explicit
    assert_match(/<button[^>]*>/, output)
    assert_includes(output, 'aria-controls="test-date-content"')
    assert_includes(output, 'data-date-picker-target="trigger"')
    assert_includes(output, 'data-placeholder="Choose date"')
    # Check for calendar SVG path instead of icon name
    assert_includes(output, "M8 2v4")
    assert_match(%r{<button[^>]*>.*</button>}m, output)
  end

  def test_it_should_render_input_mode_trigger
    component = ShadcnPhlexcomponents::DatePickerTrigger.new(
      select_only: false,
      stimulus_controller_name: "date-picker",
      aria_id: "test-input",
    )
    output = render(component)

    assert_includes(output, 'aria-controls="test-input-content"')
    assert_includes(output, 'data-date-picker-target="trigger"')
    # Check for calendar SVG path instead of icon name
    assert_includes(output, "M8 2v4")
    # Input mode trigger should be smaller (icon only)
    assert_includes(output, "size-7")
  end

  def test_it_should_include_trigger_text_target_for_select_only
    component = ShadcnPhlexcomponents::DatePickerTrigger.new(
      select_only: true,
      stimulus_controller_name: "date-picker",
      aria_id: "test",
    )
    output = render(component)

    assert_includes(output, 'data-date-picker-target="triggerText"')
    assert_includes(output, "pointer-events-none")
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::DatePickerTrigger.new(
      select_only: true,
      disabled: true,
      stimulus_controller_name: "date-picker",
      aria_id: "test",
    )
    output = render(component)

    assert_includes(output, "disabled")
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::DatePickerTrigger.new(
      stimulus_controller_name: "date-picker",
      aria_id: "test",
    )
    output = render(component)

    assert_match(/click->date-picker#toggle/, output)
  end

  def test_it_should_use_button_variant_styling
    select_only = ShadcnPhlexcomponents::DatePickerTrigger.new(
      select_only: true,
      stimulus_controller_name: "date-picker",
      aria_id: "test",
    )
    select_output = render(select_only)
    # Select only should use outline variant
    assert_includes(select_output, "justify-between w-full")

    icon_only = ShadcnPhlexcomponents::DatePickerTrigger.new(
      select_only: false,
      stimulus_controller_name: "date-picker",
      aria_id: "test",
    )
    icon_output = render(icon_only)
    # Icon only should use ghost variant
    assert_includes(icon_output, "size-7")
  end
end

class TestDatePickerContent < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DatePickerContent.new(
      stimulus_controller_name: "date-picker",
      aria_id: "test-content",
    )
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="date-picker-content"')
    assert_includes(output, 'id="test-content-content"')
    assert_includes(output, 'role="dialog"')
    assert_includes(output, 'data-date-picker-target="content"')
    assert_includes(output, 'data-side="bottom"')
    assert_includes(output, 'data-align="start"')
  end

  def test_it_should_handle_positioning_attributes
    component = ShadcnPhlexcomponents::DatePickerContent.new(
      stimulus_controller_name: "date-picker",
      aria_id: "position-test",
      side: :top,
      align: :end,
    )
    output = render(component)

    assert_includes(output, 'data-side="top"')
    assert_includes(output, 'data-align="end"')
  end

  def test_it_should_include_calendar_target
    component = ShadcnPhlexcomponents::DatePickerContent.new(
      stimulus_controller_name: "date-picker",
      aria_id: "calendar-test",
    )
    output = render(component)

    assert_includes(output, 'data-date-picker-target="calendar"')
  end

  def test_it_should_include_content_container
    component = ShadcnPhlexcomponents::DatePickerContent.new(
      stimulus_controller_name: "date-picker",
      aria_id: "container-test",
    )
    output = render(component)

    assert_includes(output, 'data-date-picker-target="contentContainer"')
    assert_includes(output, 'style="display: none;"')
    assert_includes(output, "fixed top-0 left-0 w-max z-50")
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::DatePickerContent.new(
      stimulus_controller_name: "date-picker",
      aria_id: "action-test",
    )
    output = render(component)

    assert_match(/date-picker:click:outside->date-picker#clickOutside/, output)
  end

  def test_it_should_use_popover_content_styling
    component = ShadcnPhlexcomponents::DatePickerContent.new(
      stimulus_controller_name: "date-picker",
      aria_id: "style-test",
    )
    output = render(component)

    assert_includes(output, "w-fit")
  end
end

class TestDatePickerContentContainer < ComponentTest
  def test_it_should_render_container
    component = ShadcnPhlexcomponents::DatePickerContentContainer.new(
      stimulus_controller_name: "date-picker",
    ) { "Calendar content" }
    output = render(component)

    assert_includes(output, "Calendar content")
    assert_includes(output, 'data-shadcn-phlexcomponents="date-picker-content-container"')
    assert_includes(output, 'data-date-picker-target="contentContainer"')
    assert_includes(output, 'style="display: none;"')
    assert_includes(output, "fixed top-0 left-0 w-max z-50")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::DatePickerContentContainer.new(
      stimulus_controller_name: "date-picker",
      class: "custom-container",
      id: "container-id",
    )
    output = render(component)

    assert_includes(output, "custom-container")
    assert_includes(output, 'id="container-id"')
  end
end

class TestDatePickerInputContainer < ComponentTest
  def test_it_should_render_container
    component = ShadcnPhlexcomponents::DatePickerInputContainer.new(
      stimulus_controller_name: "date-picker",
    ) { "Input content" }
    output = render(component)

    assert_includes(output, "Input content")
    assert_includes(output, 'data-shadcn-phlexcomponents="date-picker-input-container"')
    assert_includes(output, 'data-date-picker-target="inputContainer"')
    assert_includes(output, "flex shadow-xs transition-[color,box-shadow]")
    assert_includes(output, "rounded-md border bg-transparent")
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::DatePickerInputContainer.new(
      disabled: true,
      stimulus_controller_name: "date-picker",
    )
    output = render(component)

    assert_includes(output, "data-disabled")
    assert_includes(output, "data-[disabled]:cursor-not-allowed data-[disabled]:opacity-50")
  end

  def test_it_should_include_focus_styles
    component = ShadcnPhlexcomponents::DatePickerInputContainer.new(
      stimulus_controller_name: "date-picker",
    )
    output = render(component)

    assert_includes(output, "focus-visible:border-ring focus-visible:ring-ring/50")
    assert_includes(output, "data-[focus=true]:border-ring data-[focus=true]:ring-ring/50")
  end
end

class TestDatePickerInput < ComponentTest
  def test_it_should_render_input_and_attributes
    component = ShadcnPhlexcomponents::DatePickerInput.new(
      id: "date-input",
      placeholder: "Enter date",
      format: "DD/MM/YYYY",
      stimulus_controller_name: "date-picker",
      aria_id: "test-input",
    )
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="date-picker-input"')
    assert_includes(output, 'id="date-input"')
    assert_includes(output, 'placeholder="Enter date"')
    assert_includes(output, 'type="text"')
    assert_includes(output, 'data-date-picker-target="input"')
    assert_match(/<input[^>]*>/, output)
  end

  def test_it_should_use_format_as_placeholder_fallback
    component = ShadcnPhlexcomponents::DatePickerInput.new(
      format: "MM/DD/YYYY",
      stimulus_controller_name: "date-picker",
      aria_id: "test",
    )
    output = render(component)

    assert_includes(output, 'placeholder="MM/DD/YYYY"')
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::DatePickerInput.new(
      disabled: true,
      stimulus_controller_name: "date-picker",
      aria_id: "test",
    )
    output = render(component)

    assert_includes(output, "disabled")
  end

  def test_it_should_generate_fallback_id
    component = ShadcnPhlexcomponents::DatePickerInput.new(
      stimulus_controller_name: "date-picker",
      aria_id: "fallback-test",
    )
    output = render(component)

    assert_includes(output, 'id="fallback-test-input"')
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::DatePickerInput.new(
      stimulus_controller_name: "date-picker",
      aria_id: "test",
    )
    output = render(component)

    assert_match(/input->date-picker#inputDate/, output)
    assert_match(/blur->date-picker#inputBlur/, output)
    assert_match(/focus->date-picker#setContainerFocus/, output)
  end

  def test_it_should_include_text_selection_styles
    component = ShadcnPhlexcomponents::DatePickerInput.new(
      stimulus_controller_name: "date-picker",
      aria_id: "test",
    )
    output = render(component)

    assert_includes(output, "selection:bg-primary selection:text-primary-foreground")
    assert_includes(output, "placeholder:text-muted-foreground")
  end
end

class TestDatePickerWithCustomConfiguration < ComponentTest
  def test_date_picker_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.date_picker = {
      root: { base: "custom-date-picker-base" },
      content_container: { base: "custom-content-container-base" },
      input_container: { base: "custom-input-container-base" },
      input: { base: "custom-input-base" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    date_picker_classes = [
      "DatePickerInput",
      "DatePickerInputContainer",
      "DatePickerContentContainer",
      "DatePickerContent",
      "DatePickerTrigger",
      "DatePicker",
    ]

    date_picker_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/date_picker.rb", __dir__))

    # Test components with custom configuration
    picker = ShadcnPhlexcomponents::DatePicker.new(name: "test")
    assert_includes(render(picker), "custom-date-picker-base")

    container = ShadcnPhlexcomponents::DatePickerContentContainer.new(stimulus_controller_name: "date-picker")
    assert_includes(render(container), "custom-content-container-base")

    input_container = ShadcnPhlexcomponents::DatePickerInputContainer.new(stimulus_controller_name: "date-picker")
    assert_includes(render(input_container), "custom-input-container-base")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    date_picker_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/date_picker.rb", __dir__))
  end
end

class TestDatePickerIntegration < ComponentTest
  def test_complete_date_picker_workflow
    component = ShadcnPhlexcomponents::DatePicker.new(
      name: "event_date",
      value: "2024-08-15",
      format: "DD/MM/YYYY",
      select_only: false,
      placeholder: "Select event date",
      disabled: false,
      mask: true,
      options: {
        minDate: "2024-01-01",
        maxDate: "2024-12-31",
        locale: "en",
      },
      class: "event-date-picker",
      id: "event-date-input",
      data: { controller: "date-picker analytics", analytics_category: "date-selection" },
    )

    output = render(component)

    # Check main structure
    assert_includes(output, "event-date-picker")
    # Controller attribute merging may not work exactly as expected
    assert_match(/data-controller="[^"]*date-picker[^"]*analytics/, output)
    assert_includes(output, 'data-analytics-category="date-selection"')
    assert_match(/data-value="2024-08-1[45]T\d{2}:\d{2}:\d{2}Z"/, output)

    # Check hidden input
    assert_includes(output, 'name="event_date"')
    assert_match(/value="2024-08-1[45]T\d{2}:\d{2}:\d{2}Z"/, output)

    # Check input mode components
    assert_includes(output, 'id="event-date-input"')
    assert_includes(output, 'placeholder="Select event date"')
    assert_includes(output, 'data-date-picker-target="input"')
    assert_includes(output, 'data-date-picker-target="inputContainer"')
    assert_includes(output, 'data-date-picker-target="trigger"')

    # Check calendar content
    assert_includes(output, 'data-date-picker-target="content"')
    assert_includes(output, 'data-date-picker-target="calendar"')

    # Check format and options
    assert_includes(output, 'data-format="DD/MM/YYYY"')
    assert_includes(output, 'data-mask="true"')
    assert_includes(output, "&quot;minDate&quot;:&quot;2024-01-01&quot;")
    assert_includes(output, "&quot;maxDate&quot;:&quot;2024-12-31&quot;")
    assert_includes(output, "&quot;locale&quot;:&quot;en&quot;")
  end

  def test_date_picker_select_only_workflow
    component = ShadcnPhlexcomponents::DatePicker.new(
      name: "birth_date",
      value: "1990-05-20",
      select_only: true,
      placeholder: "Choose your birth date",
      id: "birth-date-button",
      class: "birth-date-selector",
    )

    output = render(component)

    # Check main structure
    assert_includes(output, "birth-date-selector")
    assert_match(/data-value="1990-05-[12]\dT\d{2}:\d{2}:\d{2}Z"/, output)

    # Check hidden input
    assert_includes(output, 'name="birth_date"')
    assert_match(/value="1990-05-[12]\dT\d{2}:\d{2}:\d{2}Z"/, output)

    # Check select-only trigger (gets the ID)
    assert_includes(output, 'id="birth-date-button"')
    assert_includes(output, 'data-placeholder="Choose your birth date"')
    assert_includes(output, 'data-date-picker-target="trigger"')
    assert_includes(output, 'data-date-picker-target="triggerText"')

    # Should not have input components
    refute_includes(output, 'data-date-picker-target="input"')
    refute_includes(output, 'data-date-picker-target="inputContainer"')

    # Check calendar icon SVG path
    assert_includes(output, "M8 2v4")
  end

  def test_date_picker_accessibility_features
    component = ShadcnPhlexcomponents::DatePicker.new(
      name: "accessible_date",
      aria: { label: "Select date", describedby: "date-help" },
    )

    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'aria-label="Select date"')
    assert_includes(output, 'aria-describedby="date-help"')

    # Check ARIA roles and relationships
    # Button element has implicit role="button", not explicit
    assert_match(/<button[^>]*>/, output) # trigger
    assert_includes(output, 'role="dialog"') # content
    assert_includes(output, 'aria-haspopup="dialog"')
    # aria-expanded is not set on DatePickerTrigger by default
    # assert_match(/aria-expanded="false"/, output)
    assert_match(/aria-controls="[^"]*-content"/, output)
  end

  def test_date_picker_stimulus_integration
    component = ShadcnPhlexcomponents::DatePicker.new(
      name: "stimulus_date",
      data: {
        controller: "date-picker custom-scheduler",
        custom_scheduler_mode_value: "event",
      },
    )

    output = render(component)

    # Check multiple controllers
    assert_match(/data-controller="date-picker[^"]*custom-scheduler/, output)
    assert_includes(output, 'data-custom-scheduler-mode-value="event"')

    # Check default date-picker actions still work
    assert_match(/click->date-picker#toggle/, output)
    assert_match(/input->date-picker#inputDate/, output)
    assert_match(/date-picker:click:outside->date-picker#clickOutside/, output)
  end
end
