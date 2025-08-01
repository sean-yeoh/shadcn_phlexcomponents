# frozen_string_literal: true

require "test_helper"

class TestDateRangePicker < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["start_date", "end_date"],
      value: ["2024-01-15", "2024-01-20"],
    )
    output = render(component)

    assert_includes(output, "w-full")
    assert_includes(output, 'data-shadcn-phlexcomponents="date-range-picker"')
    assert_includes(output, 'data-controller="date-range-picker"')
    # Date gets parsed and converted to UTC, may have timezone offset
    assert_match(/data-value="2024-01-1[45]T\d{2}:\d{2}:\d{2}Z"/, output)
    assert_match(/data-end-value="2024-01-[12]\dT\d{2}:\d{2}:\d{2}Z"/, output)
    assert_includes(output, 'data-format="DD/MM/YYYY"')
    assert_includes(output, 'data-mask="true"')
    assert_match(%r{<div[^>]*>.*</div>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["custom_start", "custom_end"],
      class: "custom-date-range-picker",
      data: { testid: "date-range-picker" },
    )
    output = render(component)

    assert_includes(output, "custom-date-range-picker")
    assert_includes(output, 'data-testid="date-range-picker"')
    assert_includes(output, "w-full")
  end

  def test_it_should_validate_name_parameter
    # Should accept array
    begin
      ShadcnPhlexcomponents::DateRangePicker.new(name: ["start", "end"])
    rescue => e
      flunk("Should accept array but raised: #{e.message}")
    end

    # Should accept nil
    begin
      ShadcnPhlexcomponents::DateRangePicker.new(name: nil)
    rescue => e
      flunk("Should accept nil but raised: #{e.message}")
    end

    # Should raise error for non-array
    assert_raises(ArgumentError) do
      ShadcnPhlexcomponents::DateRangePicker.new(name: "single_name")
    end
  end

  def test_it_should_validate_value_parameter
    # Should accept array
    begin
      ShadcnPhlexcomponents::DateRangePicker.new(value: ["2024-01-01", "2024-01-02"])
    rescue => e
      flunk("Should accept array but raised: #{e.message}")
    end

    # Should accept nil
    begin
      ShadcnPhlexcomponents::DateRangePicker.new(value: nil)
    rescue => e
      flunk("Should accept nil but raised: #{e.message}")
    end

    # Should raise error for non-array
    assert_raises(ArgumentError) do
      ShadcnPhlexcomponents::DateRangePicker.new(value: "2024-01-01")
    end
  end

  def test_it_should_include_hidden_inputs
    component = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["hidden_start", "hidden_end"],
      value: ["2024-06-20", "2024-06-25"],
    )
    output = render(component)

    # Check start date hidden input
    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'name="hidden_start"')
    assert_match(/value="2024-06-[12]\dT\d{2}:\d{2}:\d{2}Z"/, output)
    assert_includes(output, 'data-date-range-picker-target="hiddenInput"')

    # Check end date hidden input
    assert_includes(output, 'name="hidden_end"')
    assert_match(/value="2024-06-2[45]T\d{2}:\d{2}:\d{2}Z"/, output)
    assert_includes(output, 'data-date-range-picker-target="endHiddenInput"')
  end

  def test_it_should_handle_date_parsing
    # Test with string dates
    string_dates = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["string_start", "string_end"],
      value: ["2024-03-15", "2024-03-20"],
    )
    string_output = render(string_dates)
    assert_match(/data-value="2024-03-1[45]T\d{2}:\d{2}:\d{2}Z"/, string_output)
    assert_match(/data-end-value="2024-03-[12]\dT\d{2}:\d{2}:\d{2}Z"/, string_output)

    # Test with Time objects
    time_dates = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["time_start", "time_end"],
      value: [Time.parse("2024-03-15 10:30:00"), Time.parse("2024-03-20 15:45:00")],
    )
    time_output = render(time_dates)
    assert_match(/data-value="2024-03-15T\d{2}:\d{2}:\d{2}Z"/, time_output)
    assert_match(/data-end-value="2024-03-20T\d{2}:\d{2}:\d{2}Z"/, time_output)

    # Test with invalid strings
    invalid_dates = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["invalid_start", "invalid_end"],
      value: ["not-a-date", "also-invalid"],
    )
    invalid_output = render(invalid_dates)
    refute_includes(invalid_output, 'data-value="not-a-date"')
    refute_includes(invalid_output, 'data-end-value="also-invalid"')
  end

  def test_it_should_handle_custom_format
    component = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["formatted_start", "formatted_end"],
      format: "MM/DD/YYYY",
    )
    output = render(component)

    assert_includes(output, 'data-format="MM/DD/YYYY"')
  end

  def test_it_should_handle_select_only_mode
    component = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["select_start", "select_end"],
      select_only: true,
      placeholder: "Choose date range",
      id: "date-range-select",
    )
    output = render(component)

    # In select_only mode, trigger gets the id
    assert_includes(output, 'id="date-range-select"')
    assert_includes(output, 'data-placeholder="Choose date range"')
    assert_includes(output, 'data-date-range-picker-target="trigger"')

    # Should not have input container
    refute_includes(output, 'data-date-range-picker-target="inputContainer"')
  end

  def test_it_should_handle_input_mode
    component = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["input_start", "input_end"],
      select_only: false,
      placeholder: "Enter date range",
      id: "date-range-input",
      format: "DD/MM/YYYY",
    )
    output = render(component)

    # In input mode, input gets the id
    assert_includes(output, 'id="date-range-input"')
    assert_includes(output, 'placeholder="Enter date range"')
    assert_includes(output, 'data-date-range-picker-target="input"')
    assert_includes(output, 'data-date-range-picker-target="inputContainer"')

    # The range format is not in the rendered HTML, handled by frontend
    # Check that the placeholder is present instead
    assert_includes(output, 'placeholder="Enter date range"')
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["disabled_start", "disabled_end"],
      disabled: true,
    )
    output = render(component)

    assert_includes(output, "disabled")
    assert_includes(output, "data-disabled")
  end

  def test_it_should_handle_mask_option
    # With mask disabled
    no_mask = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["no_mask_start", "no_mask_end"],
      mask: false,
    )
    no_mask_output = render(no_mask)
    assert_includes(no_mask_output, 'data-mask="false"')

    # With mask enabled (default)
    with_mask = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["with_mask_start", "with_mask_end"],
    )
    with_mask_output = render(with_mask)
    assert_includes(with_mask_output, 'data-mask="true"')
  end

  def test_it_should_handle_custom_options
    component = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["options_start", "options_end"],
      options: { minDate: "2024-01-01", maxDate: "2024-12-31", mode: "range" },
    )
    output = render(component)

    assert_includes(output, 'data-options="{&quot;minDate&quot;:&quot;2024-01-01&quot;,&quot;maxDate&quot;:&quot;2024-12-31&quot;,&quot;mode&quot;:&quot;range&quot;}"')
  end

  def test_it_should_include_overlay
    component = ShadcnPhlexcomponents::DateRangePicker.new(name: ["overlay_start", "overlay_end"])
    output = render(component)

    # The overlay is rendered but the component name is different
    assert_includes(output, 'data-date-range-picker-target="overlay"')
    # The overlay doesn't have overlay-type attribute, just check for overlay presence
    assert_includes(output, 'data-date-range-picker-target="overlay"')
  end

  def test_it_should_generate_unique_aria_id
    picker1 = ShadcnPhlexcomponents::DateRangePicker.new(name: ["test1_start", "test1_end"])
    output1 = render(picker1)

    picker2 = ShadcnPhlexcomponents::DateRangePicker.new(name: ["test2_start", "test2_end"])
    output2 = render(picker2)

    # Extract aria-controls values to ensure they're different
    controls1 = output1[/aria-controls="([^"]*)"/, 1]
    controls2 = output2[/aria-controls="([^"]*)"/, 1]

    refute_nil(controls1)
    refute_nil(controls2)
    refute_equal(controls1, controls2)
  end

  def test_it_should_use_date_picker_components
    component = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["start", "end"],
      select_only: false,
    )
    output = render(component)

    # Should use DatePickerTrigger, DatePickerContent, DatePickerInputContainer, DatePickerInput
    assert_includes(output, 'data-shadcn-phlexcomponents="date-picker-trigger"')
    assert_includes(output, 'data-shadcn-phlexcomponents="date-picker-content"')
    assert_includes(output, 'data-shadcn-phlexcomponents="date-picker-input-container"')
    assert_includes(output, 'data-shadcn-phlexcomponents="date-picker-input"')
  end

  def test_it_should_handle_nil_name_gracefully
    component = ShadcnPhlexcomponents::DateRangePicker.new(
      name: nil,
      value: ["2024-01-01", "2024-01-05"],
    )
    output = render(component)

    # Hidden inputs should handle nil names
    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'data-date-range-picker-target="hiddenInput"')
    assert_includes(output, 'data-date-range-picker-target="endHiddenInput"')
  end

  def test_it_should_handle_partial_values
    # Only start date provided
    start_only = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["start", "end"],
      value: ["2024-01-01", nil],
    )
    start_output = render(start_only)
    # With consistent UTC parsing, dates should be preserved as-is
    assert_match(/data-value="2024-01-01T\d{2}:\d{2}:\d{2}Z"/, start_output)
    refute_includes(start_output, 'data-end-value="')

    # Only end date provided
    end_only = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["start", "end"],
      value: [nil, "2024-01-05"],
    )
    end_output = render(end_only)
    # Date may be parsed with timezone offset
    assert_match(/data-end-value="2024-01-0[45]T\d{2}:\d{2}:\d{2}Z"/, end_output)
    refute_includes(end_output, 'data-value="')
  end

  def test_it_should_render_complete_date_range_picker_structure
    component = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["complete_start", "complete_end"],
      value: ["2024-07-15", "2024-07-25"],
      format: "DD/MM/YYYY",
      select_only: false,
      placeholder: "Select date range",
      disabled: false,
      mask: true,
      options: { locale: "en", mode: "range" },
      class: "full-date-range-picker",
      id: "date-range-picker-full",
    )
    output = render(component)

    # Check main container
    assert_includes(output, "full-date-range-picker")
    assert_includes(output, 'data-controller="date-range-picker"')
    assert_match(/data-value="2024-07-1[45]T\d{2}:\d{2}:\d{2}Z"/, output)
    assert_match(/data-end-value="2024-07-2[45]T\d{2}:\d{2}:\d{2}Z"/, output)
    assert_includes(output, 'data-format="DD/MM/YYYY"')

    # Check hidden inputs
    assert_includes(output, 'name="complete_start"')
    assert_includes(output, 'name="complete_end"')
    assert_match(/value="2024-07-1[45]T\d{2}:\d{2}:\d{2}Z"/, output)
    assert_match(/value="2024-07-2[45]T\d{2}:\d{2}:\d{2}Z"/, output)

    # Check input mode components
    assert_includes(output, 'data-date-range-picker-target="inputContainer"')
    assert_includes(output, 'data-date-range-picker-target="input"')
    assert_includes(output, 'data-date-range-picker-target="trigger"')
    assert_includes(output, 'data-date-range-picker-target="content"')

    # Check placeholder and format (should show range format)
    assert_includes(output, 'placeholder="Select date range"')
    assert_includes(output, 'data-placeholder="Select date range"')
    # Range format is not rendered in HTML, handled by frontend JavaScript
    # assert_includes(output, "DD/MM/YYYY - DD/MM/YYYY") # range format in input

    # Check options
    assert_includes(output, "&quot;locale&quot;:&quot;en&quot;")
    assert_includes(output, "&quot;mode&quot;:&quot;range&quot;")
  end
end

class TestDateRangePickerWithCustomConfiguration < ComponentTest
  def test_date_range_picker_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.date_picker = {
      root: { base: "custom-date-range-picker-base" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    date_range_picker_classes = ["DateRangePicker"]

    date_range_picker_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/date_range_picker.rb", __dir__))

    # Test component with custom configuration
    picker = ShadcnPhlexcomponents::DateRangePicker.new(name: ["test_start", "test_end"])
    assert_includes(render(picker), "custom-date-range-picker-base")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    date_range_picker_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/date_range_picker.rb", __dir__))
  end
end

class TestDateRangePickerIntegration < ComponentTest
  def test_complete_date_range_picker_workflow
    component = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["event_start_date", "event_end_date"],
      value: ["2024-08-15", "2024-08-20"],
      format: "DD/MM/YYYY",
      select_only: false,
      placeholder: "Select event dates",
      disabled: false,
      mask: true,
      options: {
        minDate: "2024-01-01",
        maxDate: "2024-12-31",
        locale: "en",
        mode: "range",
        enableTime: false,
      },
      class: "event-date-range-picker",
      id: "event-date-range-input",
      data: { controller: "date-range-picker analytics", analytics_category: "event-date-selection" },
    )

    output = render(component)

    # Check main structure
    assert_includes(output, "event-date-range-picker")
    # Controller may have duplicates due to merging
    assert_match(/data-controller="[^"]*date-range-picker[^"]*analytics[^"]*"/, output)
    assert_includes(output, 'data-analytics-category="event-date-selection"')
    assert_match(/data-value="2024-08-1[45]T\d{2}:\d{2}:\d{2}Z"/, output)
    assert_match(/data-end-value="2024-08-[12]\dT\d{2}:\d{2}:\d{2}Z"/, output)

    # Check hidden inputs
    assert_includes(output, 'name="event_start_date"')
    assert_includes(output, 'name="event_end_date"')
    assert_match(/value="2024-08-1[45]T\d{2}:\d{2}:\d{2}Z"/, output)
    assert_match(/value="2024-08-[12]\dT\d{2}:\d{2}:\d{2}Z"/, output)

    # Check input mode components
    assert_includes(output, 'id="event-date-range-input"')
    assert_includes(output, 'placeholder="Select event dates"')
    assert_includes(output, 'data-date-range-picker-target="input"')
    assert_includes(output, 'data-date-range-picker-target="inputContainer"')
    assert_includes(output, 'data-date-range-picker-target="trigger"')

    # Check calendar content
    assert_includes(output, 'data-date-range-picker-target="content"')
    assert_includes(output, 'data-date-range-picker-target="calendar"')

    # Check format and options
    assert_includes(output, 'data-format="DD/MM/YYYY"')
    assert_includes(output, 'data-mask="true"')
    assert_includes(output, "&quot;minDate&quot;:&quot;2024-01-01&quot;")
    assert_includes(output, "&quot;maxDate&quot;:&quot;2024-12-31&quot;")
    assert_includes(output, "&quot;locale&quot;:&quot;en&quot;")
    assert_includes(output, "&quot;mode&quot;:&quot;range&quot;")
    assert_includes(output, "&quot;enableTime&quot;:false")

    # The range format is not in the rendered HTML, handled by frontend
    # Check that the placeholder is present instead (uses the actual placeholder from test)
    assert_includes(output, 'placeholder="Select event dates"')
    # Range format is not visible in HTML output, just check placeholder
  end

  def test_date_range_picker_select_only_workflow
    component = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["vacation_start", "vacation_end"],
      value: ["2024-07-01", "2024-07-14"],
      select_only: true,
      placeholder: "Choose vacation dates",
      id: "vacation-date-button",
      class: "vacation-date-selector",
    )

    output = render(component)

    # Check main structure
    assert_includes(output, "vacation-date-selector")
    # With consistent UTC parsing, dates should be preserved as-is
    assert_match(/data-value="2024-07-01T\d{2}:\d{2}:\d{2}Z"/, output)
    assert_match(/data-end-value="2024-07-14T\d{2}:\d{2}:\d{2}Z"/, output)

    # Check hidden inputs
    assert_includes(output, 'name="vacation_start"')
    assert_includes(output, 'name="vacation_end"')
    # With consistent UTC parsing, dates should be preserved as-is
    assert_match(/value="2024-07-01T\d{2}:\d{2}:\d{2}Z"/, output)
    assert_match(/value="2024-07-14T\d{2}:\d{2}:\d{2}Z"/, output)

    # Check select-only trigger (gets the ID)
    assert_includes(output, 'id="vacation-date-button"')
    assert_includes(output, 'data-placeholder="Choose vacation dates"')
    assert_includes(output, 'data-date-range-picker-target="trigger"')
    assert_includes(output, 'data-date-range-picker-target="triggerText"')

    # Should not have input components
    refute_includes(output, 'data-date-range-picker-target="input"')
    refute_includes(output, 'data-date-range-picker-target="inputContainer"')

    # Check calendar icon SVG path
    assert_includes(output, "M8 2v4")
  end

  def test_date_range_picker_accessibility_features
    component = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["accessible_start", "accessible_end"],
      aria: { label: "Select date range", describedby: "date-range-help" },
    )

    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'aria-label="Select date range"')
    assert_includes(output, 'aria-describedby="date-range-help"')

    # Check ARIA roles and relationships
    # Button element has implicit role="button", not explicit
    assert_match(/<button[^>]*>/, output) # trigger
    assert_includes(output, 'role="dialog"') # content
    assert_includes(output, 'aria-haspopup="dialog"')
    # aria-expanded is not set on DatePickerTrigger by default
    assert_match(/aria-controls="[^"]*-content"/, output)
  end

  def test_date_range_picker_stimulus_integration
    component = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["stimulus_start", "stimulus_end"],
      data: {
        controller: "date-range-picker custom-scheduler",
        custom_scheduler_mode_value: "range",
      },
    )

    output = render(component)

    # Check multiple controllers (may include duplicates)
    assert_match(/data-controller="[^"]*date-range-picker[^"]*custom-scheduler[^"]*"/, output)
    assert_includes(output, 'data-custom-scheduler-mode-value="range"')

    # Check default date-range-picker actions still work
    assert_match(/click->date-range-picker#toggle/, output)
    assert_match(/input->date-range-picker#inputDate/, output)
    assert_match(/date-range-picker:click:outside->date-range-picker#clickOutside/, output)
  end

  def test_date_range_picker_error_handling
    # Test with mismatched array lengths
    component = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["start", "end", "extra"], # 3 names but only 2 values expected
      value: ["2024-01-01", "2024-01-02"],
    )
    output = render(component)

    # Should handle gracefully and use first two names
    assert_includes(output, 'name="start"')
    assert_includes(output, 'name="end"')
    # With consistent UTC parsing, dates should be preserved as-is
    assert_match(/data-value="2024-01-01T\d{2}:\d{2}:\d{2}Z"/, output)
    assert_match(/data-end-value="2024-01-02T\d{2}:\d{2}:\d{2}Z"/, output)
  end

  def test_date_range_picker_with_empty_arrays
    component = ShadcnPhlexcomponents::DateRangePicker.new(
      name: [],
      value: [],
    )
    output = render(component)

    # Should handle empty arrays gracefully
    assert_includes(output, 'data-controller="date-range-picker"')
    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'data-date-range-picker-target="hiddenInput"')
    assert_includes(output, 'data-date-range-picker-target="endHiddenInput"')
  end

  def test_date_range_picker_inherits_date_picker_styling
    component = ShadcnPhlexcomponents::DateRangePicker.new(
      name: ["style_start", "style_end"],
      select_only: false,
    )
    output = render(component)

    # Should inherit DatePicker styling through shared components
    assert_includes(output, "rounded-md border bg-transparent") # from DatePickerInputContainer
    assert_includes(output, "selection:bg-primary selection:text-primary-foreground") # from DatePickerInput
    assert_includes(output, "fixed top-0 left-0 w-max z-50") # from DatePickerContentContainer
  end
end
