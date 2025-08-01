# frozen_string_literal: true

require "test_helper"

class TestProgress < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Progress.new(value: 50)
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="progress"')
    assert_includes(output, 'role="progressbar"')
    assert_includes(output, 'aria-valuemax="100"')
    assert_includes(output, 'aria-valuemin="0"')
    assert_includes(output, 'aria-valuenow="50"')
    assert_includes(output, 'data-controller="progress"')
    assert_includes(output, 'data-progress-percent-value="50"')
    assert_match(%r{<div[^>]*>.*</div>}m, output)
  end

  def test_it_should_render_with_default_value
    component = ShadcnPhlexcomponents::Progress.new
    output = render(component)

    assert_includes(output, 'aria-valuenow="0"')
    assert_includes(output, 'data-progress-percent-value="0"')
    assert_includes(output, "bg-primary/20")
    assert_includes(output, "relative h-2 w-full overflow-hidden rounded-full")
  end

  def test_it_should_render_with_custom_value
    component = ShadcnPhlexcomponents::Progress.new(value: 75)
    output = render(component)

    assert_includes(output, 'aria-valuenow="75"')
    assert_includes(output, 'data-progress-percent-value="75"')
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Progress.new(
      value: 25,
      class: "custom-progress",
      id: "progress-id",
      data: { testid: "progress-bar" },
    )
    output = render(component)

    assert_includes(output, "custom-progress")
    assert_includes(output, 'id="progress-id"')
    assert_includes(output, 'data-testid="progress-bar"')
    assert_includes(output, 'aria-valuenow="25"')
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::Progress.new(value: 40)
    output = render(component)

    assert_includes(output, "bg-primary/20")
    assert_includes(output, "relative h-2 w-full")
    assert_includes(output, "overflow-hidden rounded-full")
  end

  def test_it_should_include_progress_indicator
    component = ShadcnPhlexcomponents::Progress.new(value: 60)
    output = render(component)

    # Check that ProgressIndicator is included
    assert_includes(output, 'data-progress-target="indicator"')
    assert_includes(output, "bg-primary")
    assert_includes(output, "h-full w-full flex-1 transition-all")
  end

  def test_it_should_handle_different_values
    values = [0, 25, 50, 75, 100]

    values.each do |value|
      component = ShadcnPhlexcomponents::Progress.new(value: value)
      output = render(component)

      assert_includes(output, "aria-valuenow=\"#{value}\"")
      assert_includes(output, "data-progress-percent-value=\"#{value}\"")
      assert_includes(output, "translateX(-#{100 - value}%)")
    end
  end

  def test_it_should_handle_zero_value
    component = ShadcnPhlexcomponents::Progress.new(value: 0)
    output = render(component)

    assert_includes(output, 'aria-valuenow="0"')
    assert_includes(output, "translateX(-100%)")
  end

  def test_it_should_handle_complete_value
    component = ShadcnPhlexcomponents::Progress.new(value: 100)
    output = render(component)

    assert_includes(output, 'aria-valuenow="100"')
    assert_includes(output, "translateX(-0%)")
  end

  def test_it_should_handle_aria_attributes
    component = ShadcnPhlexcomponents::Progress.new(
      value: 30,
      aria: {
        label: "File upload progress",
        describedby: "upload-status",
      },
    )
    output = render(component)

    assert_includes(output, 'aria-label="File upload progress"')
    assert_includes(output, 'aria-describedby="upload-status"')
    assert_includes(output, 'aria-valuenow="30"')
  end

  def test_it_should_handle_data_attributes
    component = ShadcnPhlexcomponents::Progress.new(
      value: 45,
      data: {
        upload_target: "progressBar",
        action: "upload:progress->upload#updateProgress",
      },
    )
    output = render(component)

    # Should merge with default progress controller
    assert_includes(output, 'data-controller="progress"')
    assert_includes(output, 'data-upload-target="progressBar"')
    assert_includes(output, "upload#updateProgress")
  end

  def test_it_should_handle_title_attribute
    component = ShadcnPhlexcomponents::Progress.new(
      value: 80,
      title: "Download progress: 80%",
    )
    output = render(component)

    assert_includes(output, 'title="Download progress: 80%"')
    assert_includes(output, 'aria-valuenow="80"')
  end
end

class TestProgressIndicator < ComponentTest
  def test_it_should_render_indicator
    component = ShadcnPhlexcomponents::ProgressIndicator.new(value: 65)
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="progress-indicator"')
    assert_includes(output, 'data-progress-target="indicator"')
    assert_includes(output, "bg-primary h-full w-full flex-1 transition-all")
    assert_includes(output, "translateX(-35%)")
    assert_match(%r{<div[^>]*></div>}, output)
  end

  def test_it_should_render_with_custom_value
    component = ShadcnPhlexcomponents::ProgressIndicator.new(value: 90)
    output = render(component)

    assert_includes(output, "translateX(-10%)")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::ProgressIndicator.new(
      value: 55,
      class: "custom-indicator",
      id: "indicator-id",
    )
    output = render(component)

    assert_includes(output, "custom-indicator")
    assert_includes(output, 'id="indicator-id"')
    assert_includes(output, "translateX(-45%)")
  end

  def test_it_should_handle_nil_value
    component = ShadcnPhlexcomponents::ProgressIndicator.new
    output = render(component)

    assert_includes(output, "translateX(-100%)")
    assert_includes(output, 'data-progress-target="indicator"')
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::ProgressIndicator.new(value: 70)
    output = render(component)

    assert_includes(output, "bg-primary")
    assert_includes(output, "h-full w-full flex-1")
    assert_includes(output, "transition-all")
  end
end

class TestProgressWithCustomConfiguration < ComponentTest
  def test_progress_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.progress = {
      root: { base: "custom-progress-base bg-secondary h-4" },
      indicator: { base: "custom-indicator-base bg-accent" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    progress_classes = ["ProgressIndicator", "Progress"]

    progress_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/progress.rb", __dir__))

    # Test components with custom configuration
    progress = ShadcnPhlexcomponents::Progress.new(value: 50)
    output = render(progress)
    assert_includes(output, "custom-progress-base")
    assert_includes(output, "bg-secondary h-4")

    indicator = ShadcnPhlexcomponents::ProgressIndicator.new(value: 50)
    indicator_output = render(indicator)
    assert_includes(indicator_output, "custom-indicator-base")
    assert_includes(indicator_output, "bg-accent")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    progress_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/progress.rb", __dir__))
  end
end

class TestProgressIntegration < ComponentTest
  def test_complete_progress_workflow
    component = ShadcnPhlexcomponents::Progress.new(
      value: 65,
      class: "file-upload-progress",
      id: "upload-progress",
      aria: {
        label: "File upload progress",
        describedby: "upload-status upload-help",
      },
      data: {
        controller: "progress file-upload",
        file_upload_target: "progressBar",
        action: "upload:progress->file-upload#updateProgress",
      },
      title: "Uploading... 65% complete",
    )

    output = render(component)

    # Check main structure
    assert_includes(output, "file-upload-progress")
    assert_includes(output, 'id="upload-progress"')

    # Check progress value
    assert_includes(output, 'aria-valuenow="65"')
    assert_includes(output, 'data-progress-percent-value="65"')

    # Check accessibility
    assert_includes(output, 'role="progressbar"')
    assert_includes(output, 'aria-label="File upload progress"')
    assert_includes(output, 'aria-describedby="upload-status upload-help"')
    assert_includes(output, 'title="Uploading... 65% complete"')

    # Check stimulus integration
    assert_match(/data-controller="[^"]*progress[^"]*file-upload[^"]*"/, output)
    assert_includes(output, 'data-file-upload-target="progressBar"')
    assert_includes(output, "file-upload#updateProgress")

    # Check indicator styling
    assert_includes(output, "translateX(-35%)")
    assert_includes(output, 'data-progress-target="indicator"')
  end

  def test_progress_accessibility_features
    component = ShadcnPhlexcomponents::Progress.new(
      value: 75,
      aria: {
        label: "Download progress",
        describedby: "download-status",
        valuetext: "75 percent complete",
      },
      title: "Downloading large file: 75% complete",
    )

    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'role="progressbar"')
    assert_includes(output, 'aria-label="Download progress"')
    assert_includes(output, 'aria-describedby="download-status"')
    assert_includes(output, 'aria-valuetext="75 percent complete"')
    assert_includes(output, 'aria-valuemin="0"')
    assert_includes(output, 'aria-valuemax="100"')
    assert_includes(output, 'aria-valuenow="75"')
    assert_includes(output, 'title="Downloading large file: 75% complete"')
  end

  def test_progress_stimulus_integration
    component = ShadcnPhlexcomponents::Progress.new(
      value: 40,
      data: {
        controller: "progress auto-save",
        auto_save_interval_value: "5000",
        action: "auto-save:progress->progress#update",
      },
    )

    output = render(component)

    # Check multiple controllers
    assert_match(/data-controller="[^"]*progress[^"]*auto-save[^"]*"/, output)
    assert_includes(output, 'data-auto-save-interval-value="5000"')

    # Check actions
    assert_includes(output, "progress#update")

    # Check default progress values
    assert_includes(output, 'aria-valuenow="40"')
    assert_includes(output, "translateX(-60%)")
  end

  def test_progress_with_form_integration
    component = ShadcnPhlexcomponents::Progress.new(
      value: 85,
      class: "form-progress",
      data: {
        controller: "progress form-validation",
        form_validation_target: "progressIndicator",
      },
    )

    output = render(component)

    # Check form integration
    assert_includes(output, "form-progress")
    assert_match(/data-controller="[^"]*progress[^"]*form-validation[^"]*"/, output)
    assert_includes(output, 'data-form-validation-target="progressIndicator"')

    # Check progress state
    assert_includes(output, 'aria-valuenow="85"')
    assert_includes(output, "translateX(-15%)")
  end

  def test_progress_loading_states
    # Test different loading states
    states = [
      { value: 0, label: "Initializing..." },
      { value: 25, label: "Processing..." },
      { value: 50, label: "Halfway there..." },
      { value: 75, label: "Almost done..." },
      { value: 100, label: "Complete!" },
    ]

    states.each do |state|
      component = ShadcnPhlexcomponents::Progress.new(
        value: state[:value],
        aria: { valuetext: state[:label] },
      )

      output = render(component)

      assert_includes(output, "aria-valuenow=\"#{state[:value]}\"")
      assert_includes(output, "aria-valuetext=\"#{state[:label]}\"")
      assert_includes(output, "translateX(-#{100 - state[:value]}%)")
    end
  end

  def test_progress_with_indeterminate_state
    # Simulate indeterminate progress (no specific value)
    component = ShadcnPhlexcomponents::Progress.new(
      class: "indeterminate-progress",
      aria: {
        label: "Loading...",
        valuetext: "Loading in progress",
      },
      data: {
        controller: "progress indeterminate-loader",
        action: "indeterminate-loader:animate->progress#pulse",
      },
    )

    output = render(component)

    # Check indeterminate state (default value 0)
    assert_includes(output, "indeterminate-progress")
    assert_includes(output, 'aria-valuenow="0"')
    assert_includes(output, 'aria-valuetext="Loading in progress"')
    assert_includes(output, "progress#pulse")
  end

  def test_progress_real_time_updates
    component = ShadcnPhlexcomponents::Progress.new(
      value: 30,
      class: "realtime-progress",
      data: {
        controller: "progress websocket-updater",
        websocket_updater_channel_value: "upload_progress",
        action: "websocket:message->websocket-updater#updateProgress",
      },
    )

    output = render(component)

    # Check real-time integration
    assert_includes(output, "realtime-progress")
    assert_match(/data-controller="[^"]*progress[^"]*websocket-updater[^"]*"/, output)
    assert_includes(output, 'data-websocket-updater-channel-value="upload_progress"')
    assert_includes(output, "websocket-updater#updateProgress")

    # Check current progress
    assert_includes(output, 'aria-valuenow="30"')
    assert_includes(output, "translateX(-70%)")
  end

  def test_progress_with_animation_classes
    component = ShadcnPhlexcomponents::Progress.new(
      value: 60,
      class: "animated-progress transition-all duration-500 ease-in-out",
    )

    output = render(component)

    # Check animation classes
    assert_includes(output, "animated-progress")
    assert_includes(output, "transition-all duration-500 ease-in-out")

    # Check that indicator includes transition by default
    assert_includes(output, "transition-all")
    assert_includes(output, "translateX(-40%)")
  end

  def test_progress_error_states
    component = ShadcnPhlexcomponents::Progress.new(
      value: 35,
      class: "error-progress border-destructive",
      aria: {
        label: "Upload failed",
        describedby: "error-message",
      },
      data: {
        controller: "progress error-handler",
        error_handler_retry_count: "3",
      },
    )

    output = render(component)

    # Check error state styling
    assert_includes(output, "error-progress")
    assert_includes(output, "border-destructive")

    # Check error accessibility
    assert_includes(output, 'aria-label="Upload failed"')
    assert_includes(output, 'aria-describedby="error-message"')

    # Check error handling
    assert_match(/data-controller="[^"]*progress[^"]*error-handler[^"]*"/, output)
    assert_includes(output, 'data-error-handler-retry-count="3"')
  end
end
