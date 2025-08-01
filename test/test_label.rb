# frozen_string_literal: true

require "test_helper"

class TestLabel < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Label.new { "Label text" }
    output = render(component)

    assert_includes(output, "Label text")
    assert_includes(output, 'data-shadcn-phlexcomponents="label"')
    assert_match(%r{<label[^>]*>Label text</label>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Label.new(
      class: "custom-label",
      id: "label-id",
      for: "input-id",
    ) { "Custom label" }
    output = render(component)

    assert_includes(output, "custom-label")
    assert_includes(output, 'id="label-id"')
    assert_includes(output, 'for="input-id"')
    assert_includes(output, "Custom label")
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::Label.new { "Styled label" }
    output = render(component)

    assert_includes(output, "flex items-center gap-2")
    assert_includes(output, "text-sm leading-none")
    assert_includes(output, "font-medium")
    assert_includes(output, "select-none")
    assert_includes(output, "group-data-[disabled=true]:pointer-events-none")
    assert_includes(output, "group-data-[disabled=true]:opacity-50")
    assert_includes(output, "peer-disabled:cursor-not-allowed")
    assert_includes(output, "peer-disabled:opacity-50")
  end

  def test_it_should_handle_for_attribute
    component = ShadcnPhlexcomponents::Label.new(for: "username") { "Username" }
    output = render(component)

    assert_includes(output, 'for="username"')
    assert_includes(output, "Username")
  end

  def test_it_should_handle_data_attributes
    component = ShadcnPhlexcomponents::Label.new(
      data: {
        testid: "username-label",
        controller: "label-animation",
        action: "click->label-animation#focus",
      },
    ) { "Animated label" }
    output = render(component)

    assert_includes(output, 'data-testid="username-label"')
    assert_includes(output, 'data-controller="label-animation"')
    assert_includes(output, 'data-action="click->label-animation#focus"')
  end

  def test_it_should_handle_aria_attributes
    component = ShadcnPhlexcomponents::Label.new(
      aria: {
        label: "Field label",
        describedby: "field-help",
      },
    ) { "Accessible label" }
    output = render(component)

    assert_includes(output, 'aria-label="Field label"')
    assert_includes(output, 'aria-describedby="field-help"')
  end

  def test_it_should_handle_required_indicator
    component = ShadcnPhlexcomponents::Label.new(
      class: "required",
    ) { "Required field *" }
    output = render(component)

    assert_includes(output, "required")
    assert_includes(output, "Required field *")
  end

  def test_it_should_handle_nested_content
    component = ShadcnPhlexcomponents::Label.new do |label|
      label.plain("Username ")
      label.span(class: "text-red-500") { "*" }
    end
    output = render(component)

    assert_includes(output, "Username")
    assert_includes(output, "text-red-500")
    assert_includes(output, "*")
  end

  def test_it_should_handle_icon_content
    component = ShadcnPhlexcomponents::Label.new(
      class: "with-icon",
    ) do
      "📧 Email Address"
    end
    output = render(component)

    assert_includes(output, "with-icon")
    assert_includes(output, "📧 Email Address")
    assert_includes(output, "flex items-center gap-2")
  end

  def test_it_should_handle_disabled_group_state
    component = ShadcnPhlexcomponents::Label.new(
      class: "group-data-[disabled=true]:opacity-50",
    ) { "Disabled group label" }
    output = render(component)

    assert_includes(output, "group-data-[disabled=true]:opacity-50")
    assert_includes(output, "group-data-[disabled=true]:pointer-events-none")
  end

  def test_it_should_handle_peer_disabled_state
    component = ShadcnPhlexcomponents::Label.new { "Peer disabled label" }
    output = render(component)

    assert_includes(output, "peer-disabled:cursor-not-allowed")
    assert_includes(output, "peer-disabled:opacity-50")
  end

  def test_it_should_handle_title_attribute
    component = ShadcnPhlexcomponents::Label.new(
      title: "This is a helpful tooltip",
    ) { "Tooltip label" }
    output = render(component)

    assert_includes(output, 'title="This is a helpful tooltip"')
  end

  def test_it_should_handle_multiple_classes
    component = ShadcnPhlexcomponents::Label.new(
      class: "custom-label required error",
    ) { "Multi-class label" }
    output = render(component)

    assert_includes(output, "custom-label")
    assert_includes(output, "required")
    assert_includes(output, "error")
    assert_includes(output, "flex items-center gap-2") # base classes still included
  end

  def test_it_should_handle_form_association
    component = ShadcnPhlexcomponents::Label.new(
      for: "user_email",
      form: "registration_form",
    ) { "Email" }
    output = render(component)

    assert_includes(output, 'for="user_email"')
    assert_includes(output, 'form="registration_form"')
  end
end

class TestLabelWithCustomConfiguration < ComponentTest
  def test_label_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.label = {
      base: "custom-label-base block text-lg font-bold",
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    label_classes = ["Label"]

    label_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/label.rb", __dir__))

    # Test components with custom configuration
    label = ShadcnPhlexcomponents::Label.new { "Test" }
    output = render(label)
    assert_includes(output, "custom-label-base")
    assert_includes(output, "block text-lg font-bold")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    label_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/label.rb", __dir__))
  end
end

class TestLabelIntegration < ComponentTest
  def test_complete_label_workflow
    component = ShadcnPhlexcomponents::Label.new(
      class: "field-label required",
      for: "user_email",
      id: "email-label",
      aria: {
        describedby: "email-help",
      },
      data: {
        controller: "label-animation field-validation",
        field_validation_target: "label",
        action: "click->field-validation#focusInput",
      },
    ) do
      "📧 Email Address *"
    end

    output = render(component)

    # Check main structure
    assert_includes(output, "field-label required")
    assert_includes(output, 'for="user_email"')
    assert_includes(output, 'id="email-label"')

    # Check content with emoji and required indicator
    assert_includes(output, "📧 Email Address *")

    # Check accessibility
    assert_includes(output, 'aria-describedby="email-help"')

    # Check stimulus integration
    assert_match(/data-controller="[^"]*label-animation[^"]*field-validation[^"]*"/, output)
    assert_includes(output, 'data-field-validation-target="label"')
    assert_includes(output, "click->field-validation#focusInput")

    # Check base styling classes
    assert_includes(output, "flex items-center gap-2")
    assert_includes(output, "text-sm leading-none font-medium")
    assert_includes(output, "select-none")
  end

  def test_label_accessibility_features
    component = ShadcnPhlexcomponents::Label.new(
      for: "password",
      aria: {
        label: "Password field label",
        describedby: "password-requirements password-error",
      },
      title: "Click to focus the password field",
    ) do
      "🔒 Password"
    end

    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'for="password"')
    assert_includes(output, 'aria-label="Password field label"')
    assert_includes(output, 'aria-describedby="password-requirements password-error"')
    assert_includes(output, 'title="Click to focus the password field"')

    # Check content
    assert_includes(output, "🔒 Password")

    # Check disabled state styling
    assert_includes(output, "peer-disabled:cursor-not-allowed")
    assert_includes(output, "peer-disabled:opacity-50")
  end

  def test_label_with_form_field_integration
    component = ShadcnPhlexcomponents::Label.new(
      class: "form-field-label",
      for: "user_preferences",
      data: {
        controller: "form-field",
        form_field_target: "label",
      },
    ) do
      "⚙️ Preferences"
    end

    output = render(component)

    # Check form integration
    assert_includes(output, "form-field-label")
    assert_includes(output, 'for="user_preferences"')
    assert_includes(output, 'data-controller="form-field"')
    assert_includes(output, 'data-form-field-target="label"')

    # Check content with emoji
    assert_includes(output, "⚙️ Preferences")

    # Check group disabled state styling
    assert_includes(output, "group-data-[disabled=true]:pointer-events-none")
    assert_includes(output, "group-data-[disabled=true]:opacity-50")
  end

  def test_label_with_required_indicator
    component = ShadcnPhlexcomponents::Label.new(
      class: "required-field",
      for: "full_name",
    ) do |label|
      label.plain("Full Name ")
      label.span(class: "text-destructive", aria: { label: "required" }) { "*" }
    end

    output = render(component)

    # Check structure
    assert_includes(output, "required-field")
    assert_includes(output, 'for="full_name"')

    # Check content with required indicator
    assert_includes(output, "Full Name")
    assert_includes(output, "text-destructive")
    assert_includes(output, 'aria-label="required"')
    assert_includes(output, "*")

    # Check that gap styling accommodates the content
    assert_includes(output, "flex items-center gap-2")
  end

  def test_label_stimulus_integration
    component = ShadcnPhlexcomponents::Label.new(
      data: {
        controller: "label-animation tooltip",
        tooltip_content_value: "Click to focus the associated input field",
        action: "mouseenter->tooltip#show mouseleave->tooltip#hide click->label-animation#pulse",
      },
    ) do
      "Interactive Label"
    end

    output = render(component)

    # Check multiple controllers
    assert_match(/data-controller="[^"]*label-animation[^"]*tooltip[^"]*"/, output)
    assert_includes(output, 'data-tooltip-content-value="Click to focus the associated input field"')

    # Check actions
    assert_match(/mouseenter->tooltip#show/, output)
    assert_match(/mouseleave->tooltip#hide/, output)
    assert_match(/click->label-animation#pulse/, output)

    # Check content
    assert_includes(output, "Interactive Label")
  end

  def test_label_with_nested_elements
    component = ShadcnPhlexcomponents::Label.new(
      class: "complex-label",
      for: "file_upload",
    ) do |label|
      label.plain("📎 Upload Files ")
      label.small(class: "text-muted-foreground") { "(Max 10MB)" }
    end

    output = render(component)

    # Check main structure
    assert_includes(output, "complex-label")
    assert_includes(output, 'for="file_upload"')

    # Check nested content
    assert_includes(output, "📎 Upload Files")
    assert_includes(output, "text-muted-foreground")
    assert_includes(output, "(Max 10MB)")

    # Check that flex layout handles nested elements
    assert_includes(output, "flex items-center gap-2")
  end
end
