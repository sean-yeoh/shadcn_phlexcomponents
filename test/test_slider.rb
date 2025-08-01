# frozen_string_literal: true

require "test_helper"

class TestSlider < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Slider.new(
      name: "volume",
      value: 50,
      id: "volume-slider",
    )
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="slider"')
    assert_includes(output, 'data-controller="slider"')
    assert_includes(output, 'data-range="false"')
    assert_includes(output, 'data-value="50"')
    assert_includes(output, 'data-orientation="horizontal"')
    assert_includes(output, 'data-step="1"')
    assert_includes(output, 'data-min="0"')
    assert_includes(output, 'data-max="100"')
    assert_includes(output, 'data-disabled="false"')
    assert_includes(output, 'data-id="volume-slider"')
  end

  def test_it_should_render_with_default_values
    component = ShadcnPhlexcomponents::Slider.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="slider"')
    assert_includes(output, 'data-controller="slider"')
    assert_includes(output, 'data-range="false"')
    assert_includes(output, 'data-orientation="horizontal"')
    assert_includes(output, 'data-step="1"')
    assert_includes(output, 'data-min="0"')
    assert_includes(output, 'data-max="100"')
    assert_includes(output, 'data-disabled="false"')
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Slider.new(
      name: "custom_slider",
      value: 75,
      min: 10,
      max: 200,
      step: 5,
      class: "custom-slider",
      id: "slider-id",
      data: { testid: "volume-control" },
    )
    output = render(component)

    assert_includes(output, "custom-slider")
    assert_includes(output, 'id="slider-id"')
    assert_includes(output, 'data-testid="volume-control"')
    assert_includes(output, 'data-value="75"')
    assert_includes(output, 'data-min="10"')
    assert_includes(output, 'data-max="200"')
    assert_includes(output, 'data-step="5"')
  end

  def test_it_should_handle_vertical_orientation
    component = ShadcnPhlexcomponents::Slider.new(
      name: "vertical_slider",
      orientation: :vertical,
      value: 25,
    )
    output = render(component)

    assert_includes(output, 'data-orientation="vertical"')
    assert_includes(output, 'data-value="25"')
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::Slider.new(
      name: "disabled_slider",
      disabled: true,
      value: 30,
    )
    output = render(component)

    assert_includes(output, 'data-disabled="true"')
    assert_includes(output, 'data-value="30"')
  end

  def test_it_should_include_hidden_input
    component = ShadcnPhlexcomponents::Slider.new(
      name: "test_slider",
      value: 40,
    )
    output = render(component)

    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'name="test_slider"')
    assert_includes(output, 'value="40"')
    assert_includes(output, 'data-slider-target="hiddenInput"')
  end

  def test_it_should_include_slider_target
    component = ShadcnPhlexcomponents::Slider.new(name: "target_test")
    output = render(component)

    assert_includes(output, 'data-slider-target="slider"')
  end

  def test_it_should_handle_range_slider
    component = ShadcnPhlexcomponents::Slider.new(
      name: ["start", "end"],
      value: [20, 80],
      range: true,
    )
    output = render(component)

    assert_includes(output, 'data-range="true"')
    assert_includes(output, 'data-value="20"')
    assert_includes(output, 'data-end-value="80"')
    assert_includes(output, 'name="start"')
    assert_includes(output, 'name="end"')
    assert_includes(output, 'value="20"')
    assert_includes(output, 'value="80"')
    assert_includes(output, 'data-slider-target="hiddenInput"')
    assert_includes(output, 'data-slider-target="endHiddenInput"')
  end

  def test_it_should_handle_options
    options = { tooltip: true, animate: false }
    component = ShadcnPhlexcomponents::Slider.new(
      name: "options_slider",
      options: options,
    )
    output = render(component)

    assert_includes(output, 'data-options="{&quot;tooltip&quot;:true,&quot;animate&quot;:false}"')
  end

  def test_it_should_validate_range_parameters
    # Test invalid name parameter for range
    assert_raises(ArgumentError, "Expected an array for \"name\", got String") do
      ShadcnPhlexcomponents::Slider.new(
        name: "single_name",
        range: true,
      )
    end

    # Test invalid value parameter for range
    assert_raises(ArgumentError, "Expected an array for \"value\", got Integer") do
      ShadcnPhlexcomponents::Slider.new(
        name: ["start", "end"],
        value: 50,
        range: true,
      )
    end
  end

  def test_it_should_handle_wrapper_structure
    component = ShadcnPhlexcomponents::Slider.new(name: "wrapper_test")
    output = render(component)

    # Check outer wrapper with padding
    assert_includes(output, 'class="py-[6px]"')

    # Check structure contains hidden input and slider target
    assert_match(%r{<div[^>]*py-\[6px\][^>]*>.*<div[^>]*data-shadcn-phlexcomponents="slider"[^>]*>.*<input[^>]*type="hidden"[^>]*>.*<div[^>]*data-slider-target="slider"[^>]*></div>.*</div>.*</div>}m, output)
  end
end

class TestSliderIntegration < ComponentTest
  def test_volume_control_slider
    component = ShadcnPhlexcomponents::Slider.new(
      name: "volume",
      value: 65,
      min: 0,
      max: 100,
      step: 1,
      id: "volume-control",
      class: "volume-slider w-full",
      aria: {
        label: "Volume control",
        valuetext: "Volume at 65%",
      },
      data: {
        controller: "slider audio-control",
        audio_control_target: "volumeSlider",
        action: "slider:change->audio-control#updateVolume",
      },
    )
    output = render(component)

    # Check volume control structure
    assert_includes(output, "volume-slider w-full")
    assert_includes(output, 'data-value="65"')
    assert_includes(output, 'data-min="0"')
    assert_includes(output, 'data-max="100"')
    assert_includes(output, 'data-id="volume-control"')

    # Check accessibility
    assert_includes(output, 'aria-label="Volume control"')
    assert_includes(output, 'aria-valuetext="Volume at 65%"')

    # Check stimulus integration
    assert_match(/data-controller="[^"]*slider[^"]*audio-control[^"]*"/, output)
    assert_includes(output, 'data-audio-control-target="volumeSlider"')
    assert_includes(output, "audio-control#updateVolume")

    # Check hidden input
    assert_includes(output, 'name="volume"')
    assert_includes(output, 'value="65"')
  end

  def test_price_range_slider
    component = ShadcnPhlexcomponents::Slider.new(
      name: ["min_price", "max_price"],
      value: [100, 500],
      range: true,
      min: 0,
      max: 1000,
      step: 10,
      class: "price-range-slider",
      data: {
        controller: "slider price-filter",
        price_filter_target: "rangeSlider",
        action: "slider:change->price-filter#updateRange",
      },
    )
    output = render(component)

    # Check range slider structure
    assert_includes(output, "price-range-slider")
    assert_includes(output, 'data-range="true"')
    assert_includes(output, 'data-value="100"')
    assert_includes(output, 'data-end-value="500"')
    assert_includes(output, 'data-min="0"')
    assert_includes(output, 'data-max="1000"')
    assert_includes(output, 'data-step="10"')

    # Check stimulus integration
    assert_match(/data-controller="[^"]*slider[^"]*price-filter[^"]*"/, output)
    assert_includes(output, 'data-price-filter-target="rangeSlider"')
    assert_includes(output, "price-filter#updateRange")

    # Check both hidden inputs
    assert_includes(output, 'name="min_price"')
    assert_includes(output, 'name="max_price"')
    assert_includes(output, 'value="100"')
    assert_includes(output, 'value="500"')
    assert_includes(output, 'data-slider-target="hiddenInput"')
    assert_includes(output, 'data-slider-target="endHiddenInput"')
  end

  def test_brightness_control_slider
    component = ShadcnPhlexcomponents::Slider.new(
      name: "brightness",
      value: 80,
      min: 10,
      max: 100,
      step: 5,
      class: "brightness-control",
      aria: {
        label: "Screen brightness",
        valuenow: "80",
        valuemin: "10",
        valuemax: "100",
      },
      data: {
        controller: "slider display-control",
        display_control_target: "brightnessSlider",
        display_control_unit: "percent",
        action: "slider:change->display-control#setBrightness",
      },
    )
    output = render(component)

    # Check brightness control
    assert_includes(output, "brightness-control")
    assert_includes(output, 'data-value="80"')
    assert_includes(output, 'data-min="10"')
    assert_includes(output, 'data-max="100"')
    assert_includes(output, 'data-step="5"')

    # Check accessibility
    assert_includes(output, 'aria-label="Screen brightness"')
    assert_includes(output, 'aria-valuenow="80"')
    assert_includes(output, 'aria-valuemin="10"')
    assert_includes(output, 'aria-valuemax="100"')

    # Check controller integration
    assert_match(/data-controller="[^"]*slider[^"]*display-control[^"]*"/, output)
    assert_includes(output, 'data-display-control-target="brightnessSlider"')
    assert_includes(output, 'data-display-control-unit="percent"')
    assert_includes(output, "display-control#setBrightness")
  end

  def test_vertical_timeline_slider
    component = ShadcnPhlexcomponents::Slider.new(
      name: "timeline_position",
      value: 45,
      orientation: :vertical,
      min: 0,
      max: 100,
      step: 1,
      class: "timeline-slider h-64",
      data: {
        controller: "slider timeline-control",
        timeline_control_target: "positionSlider",
        timeline_control_duration: "300",
        action: "slider:change->timeline-control#seek",
      },
    )
    output = render(component)

    # Check vertical slider
    assert_includes(output, "timeline-slider h-64")
    assert_includes(output, 'data-orientation="vertical"')
    assert_includes(output, 'data-value="45"')

    # Check controller integration
    assert_match(/data-controller="[^"]*slider[^"]*timeline-control[^"]*"/, output)
    assert_includes(output, 'data-timeline-control-target="positionSlider"')
    assert_includes(output, 'data-timeline-control-duration="300"')
    assert_includes(output, "timeline-control#seek")
  end

  def test_disabled_slider
    component = ShadcnPhlexcomponents::Slider.new(
      name: "disabled_control",
      value: 50,
      disabled: true,
      class: "disabled-slider opacity-50 cursor-not-allowed",
      aria: {
        label: "Disabled control",
        disabled: "true",
      },
    )
    output = render(component)

    # Check disabled state
    assert_includes(output, "disabled-slider opacity-50 cursor-not-allowed")
    assert_includes(output, 'data-disabled="true"')
    assert_includes(output, 'aria-label="Disabled control"')
    assert_includes(output, 'aria-disabled="true"')
  end

  def test_slider_with_custom_options
    custom_options = {
      tooltip: true,
      animate: true,
      connect: true,
      handles: 1,
      behaviour: "tap-drag",
      format: {
        to: "function(value) { return Math.round(value) + '%'; }",
        from: "function(value) { return Number(value.replace('%', '')); }",
      },
    }

    component = ShadcnPhlexcomponents::Slider.new(
      name: "percentage",
      value: 33,
      options: custom_options,
      class: "percentage-slider",
    )
    output = render(component)

    # Check options are JSON encoded
    assert_includes(output, "percentage-slider")
    assert_includes(output, 'data-value="33"')
    # JSON encoding will escape quotes and include the options
    assert_includes(output, "data-options=")
    assert_includes(output, "tooltip")
    assert_includes(output, "animate")
  end

  def test_temperature_range_slider
    component = ShadcnPhlexcomponents::Slider.new(
      name: ["temp_min", "temp_max"],
      value: [18, 24],
      range: true,
      min: -10,
      max: 40,
      step: 0.5,
      class: "temperature-slider",
      aria: {
        label: "Temperature range selector",
      },
      data: {
        controller: "slider thermostat",
        thermostat_target: "temperatureRange",
        thermostat_unit: "celsius",
        action: "slider:change->thermostat#updateRange",
      },
    )
    output = render(component)

    # Check temperature range
    assert_includes(output, "temperature-slider")
    assert_includes(output, 'data-range="true"')
    assert_includes(output, 'data-value="18"')
    assert_includes(output, 'data-end-value="24"')
    assert_includes(output, 'data-min="-10"')
    assert_includes(output, 'data-max="40"')
    assert_includes(output, 'data-step="0.5"')

    # Check accessibility
    assert_includes(output, 'aria-label="Temperature range selector"')

    # Check controller integration
    assert_match(/data-controller="[^"]*slider[^"]*thermostat[^"]*"/, output)
    assert_includes(output, 'data-thermostat-target="temperatureRange"')
    assert_includes(output, 'data-thermostat-unit="celsius"')
    assert_includes(output, "thermostat#updateRange")

    # Check range inputs
    assert_includes(output, 'name="temp_min"')
    assert_includes(output, 'name="temp_max"')
    assert_includes(output, 'value="18"')
    assert_includes(output, 'value="24"')
  end

  def test_form_integration_slider
    component = ShadcnPhlexcomponents::Slider.new(
      name: "quality",
      value: 75,
      min: 1,
      max: 100,
      step: 1,
      id: "quality-slider",
      class: "form-slider w-full",
      data: {
        controller: "slider form-field",
        form_field_target: "qualityInput",
        form_field_validation: "required",
        action: "slider:change->form-field#validate",
      },
    )
    output = render(component)

    # Check form integration
    assert_includes(output, "form-slider w-full")
    assert_includes(output, 'data-id="quality-slider"')
    assert_includes(output, 'data-value="75"')

    # Check form controller integration
    assert_match(/data-controller="[^"]*slider[^"]*form-field[^"]*"/, output)
    assert_includes(output, 'data-form-field-target="qualityInput"')
    assert_includes(output, 'data-form-field-validation="required"')
    assert_includes(output, "form-field#validate")

    # Check form input
    assert_includes(output, 'name="quality"')
    assert_includes(output, 'value="75"')
    assert_includes(output, 'type="hidden"')
  end
end
