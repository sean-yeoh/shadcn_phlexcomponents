# frozen_string_literal: true

require "test_helper"

class TestInput < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Input.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="input"')
    assert_includes(output, 'type="text"')
    assert_match(/<input[^>]*>/, output)
  end

  def test_it_should_render_with_default_type
    component = ShadcnPhlexcomponents::Input.new
    output = render(component)

    assert_includes(output, 'type="text"')
  end

  def test_it_should_render_with_custom_type
    component = ShadcnPhlexcomponents::Input.new(type: :email)
    output = render(component)

    assert_includes(output, 'type="email"')
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Input.new(
      class: "custom-input",
      id: "input-id",
      name: "user_name",
      value: "test value",
      placeholder: "Enter your name",
    )
    output = render(component)

    assert_includes(output, "custom-input")
    assert_includes(output, 'id="input-id"')
    assert_includes(output, 'name="user_name"')
    assert_includes(output, 'value="test value"')
    assert_includes(output, 'placeholder="Enter your name"')
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::Input.new
    output = render(component)

    assert_includes(output, "border-input")
    assert_includes(output, "flex h-9 w-full")
    assert_includes(output, "rounded-md border")
    assert_includes(output, "bg-transparent px-3 py-1")
    assert_includes(output, "text-base")
    assert_includes(output, "shadow-xs")
    assert_includes(output, "transition-[color,box-shadow]")
    assert_includes(output, "outline-none")
    assert_includes(output, "focus-visible:border-ring")
    assert_includes(output, "focus-visible:ring-ring/50")
    assert_includes(output, "disabled:pointer-events-none")
    assert_includes(output, "disabled:cursor-not-allowed")
    assert_includes(output, "disabled:opacity-50")
  end

  def test_it_should_handle_different_input_types
    types = [
      [:text, "text"],
      [:email, "email"],
      [:password, "password"],
      [:number, "number"],
      [:tel, "tel"],
      [:url, "url"],
      [:search, "search"],
      [:date, "date"],
      [:time, "time"],
      [:datetime_local, "datetime-local"],
      [:file, "file"],
    ]

    types.each do |symbol, html_type|
      component = ShadcnPhlexcomponents::Input.new(type: symbol)
      output = render(component)

      assert_includes(output, "type=\"#{html_type}\"")
    end
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::Input.new(disabled: true)
    output = render(component)

    assert_includes(output, "disabled")
    assert_includes(output, "disabled:pointer-events-none")
    assert_includes(output, "disabled:cursor-not-allowed")
    assert_includes(output, "disabled:opacity-50")
  end

  def test_it_should_handle_readonly_state
    component = ShadcnPhlexcomponents::Input.new(readonly: true)
    output = render(component)

    assert_includes(output, "readonly")
  end

  def test_it_should_handle_required_state
    component = ShadcnPhlexcomponents::Input.new(required: true)
    output = render(component)

    assert_includes(output, "required")
  end

  def test_it_should_handle_aria_attributes
    component = ShadcnPhlexcomponents::Input.new(
      aria: {
        label: "Username input",
        describedby: "username-help",
        invalid: "true",
      },
    )
    output = render(component)

    assert_includes(output, 'aria-label="Username input"')
    assert_includes(output, 'aria-describedby="username-help"')
    assert_includes(output, 'aria-invalid="true"')
    assert_includes(output, "aria-invalid:ring-destructive/20")
    assert_includes(output, "aria-invalid:border-destructive")
  end

  def test_it_should_handle_data_attributes
    component = ShadcnPhlexcomponents::Input.new(
      data: {
        testid: "username-input",
        controller: "input-validation",
        action: "blur->input-validation#validate",
      },
    )
    output = render(component)

    assert_includes(output, 'data-testid="username-input"')
    assert_includes(output, 'data-controller="input-validation"')
    assert_includes(output, 'data-action="blur->input-validation#validate"')
  end

  def test_it_should_handle_file_input_styling
    component = ShadcnPhlexcomponents::Input.new(type: :file)
    output = render(component)

    assert_includes(output, 'type="file"')
    assert_includes(output, "file:text-foreground")
    assert_includes(output, "file:inline-flex file:h-7")
    assert_includes(output, "file:border-0 file:bg-transparent")
    assert_includes(output, "file:text-sm file:font-medium")
  end

  def test_it_should_handle_placeholder_styling
    component = ShadcnPhlexcomponents::Input.new(placeholder: "Enter text...")
    output = render(component)

    assert_includes(output, 'placeholder="Enter text..."')
    assert_includes(output, "placeholder:text-muted-foreground")
  end

  def test_it_should_handle_selection_styling
    component = ShadcnPhlexcomponents::Input.new
    output = render(component)

    assert_includes(output, "selection:bg-primary")
    assert_includes(output, "selection:text-primary-foreground")
  end

  def test_it_should_handle_min_max_attributes
    component = ShadcnPhlexcomponents::Input.new(
      type: :number,
      min: 0,
      max: 100,
      step: 5,
    )
    output = render(component)

    assert_includes(output, 'type="number"')
    assert_includes(output, 'min="0"')
    assert_includes(output, 'max="100"')
    assert_includes(output, 'step="5"')
  end
end

class TestInputWithCustomConfiguration < ComponentTest
  def test_input_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.input = {
      base: "custom-input-base px-4 py-2",
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    input_classes = ["Input"]

    input_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/input.rb", __dir__))

    # Test components with custom configuration
    input = ShadcnPhlexcomponents::Input.new
    output = render(input)
    assert_includes(output, "custom-input-base")
    assert_includes(output, "px-4 py-2")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    input_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/input.rb", __dir__))
  end
end

class TestInputIntegration < ComponentTest
  def test_complete_input_workflow
    component = ShadcnPhlexcomponents::Input.new(
      type: :email,
      class: "user-email-input",
      id: "email",
      name: "user[email]",
      value: "john@example.com",
      placeholder: "📧 Enter your email address",
      required: true,
      aria: {
        label: "Email address",
        describedby: "email-help email-error",
      },
      data: {
        controller: "input-validation email-checker",
        input_validation_rules_value: "email,required",
        action: "blur->input-validation#validate input->email-checker#check",
      },
    )

    output = render(component)

    # Check main structure
    assert_includes(output, "user-email-input")
    assert_includes(output, 'type="email"')
    assert_includes(output, 'id="email"')
    assert_includes(output, 'name="user[email]"')
    assert_includes(output, 'value="john@example.com"')

    # Check placeholder with emoji
    assert_includes(output, "📧 Enter your email address")

    # Check validation attributes
    assert_includes(output, "required")
    assert_includes(output, 'aria-label="Email address"')
    assert_includes(output, 'aria-describedby="email-help email-error"')

    # Check stimulus integration
    assert_match(/data-controller="[^"]*input-validation[^"]*email-checker[^"]*"/, output)
    assert_includes(output, 'data-input-validation-rules-value="email,required"')
    assert_match(/blur->input-validation#validate/, output)
    assert_match(/input->email-checker#check/, output)

    # Check styling classes
    assert_includes(output, "border-input")
    assert_includes(output, "focus-visible:ring-ring/50")
    assert_includes(output, "placeholder:text-muted-foreground")
  end

  def test_input_accessibility_features
    component = ShadcnPhlexcomponents::Input.new(
      type: :password,
      aria: {
        label: "Password",
        describedby: "password-help",
        invalid: "false",
      },
      autocomplete: "current-password",
      minlength: 8,
    )

    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'type="password"')
    assert_includes(output, 'aria-label="Password"')
    assert_includes(output, 'aria-describedby="password-help"')
    assert_includes(output, 'aria-invalid="false"')
    assert_includes(output, 'autocomplete="current-password"')
    assert_includes(output, 'minlength="8"')

    # Check styling for valid/invalid states
    assert_includes(output, "aria-invalid:ring-destructive/20")
    assert_includes(output, "aria-invalid:border-destructive")
  end

  def test_input_file_integration
    component = ShadcnPhlexcomponents::Input.new(
      type: :file,
      class: "file-upload",
      accept: "image/*,.pdf",
      multiple: true,
      data: {
        controller: "file-upload",
        action: "change->file-upload#handleFiles",
      },
    )

    output = render(component)

    # Check file input attributes
    assert_includes(output, 'type="file"')
    assert_includes(output, "file-upload")
    assert_includes(output, 'accept="image/*,.pdf"')
    assert_includes(output, "multiple")

    # Check file-specific styling
    assert_includes(output, "file:text-foreground")
    assert_includes(output, "file:inline-flex file:h-7")
    assert_includes(output, "file:border-0 file:bg-transparent")
    assert_includes(output, "file:text-sm file:font-medium")

    # Check stimulus integration
    assert_includes(output, 'data-controller="file-upload"')
    assert_includes(output, "change->file-upload#handleFiles")
  end

  def test_input_number_integration
    component = ShadcnPhlexcomponents::Input.new(
      type: :number,
      class: "quantity-input",
      min: 1,
      max: 999,
      step: 1,
      value: 5,
      data: {
        controller: "quantity-selector",
        action: "change->quantity-selector#updateTotal",
      },
    )

    output = render(component)

    # Check number input attributes
    assert_includes(output, 'type="number"')
    assert_includes(output, "quantity-input")
    assert_includes(output, 'min="1"')
    assert_includes(output, 'max="999"')
    assert_includes(output, 'step="1"')
    assert_includes(output, 'value="5"')

    # Check stimulus integration
    assert_includes(output, 'data-controller="quantity-selector"')
    assert_includes(output, "change->quantity-selector#updateTotal")
  end

  def test_input_search_integration
    component = ShadcnPhlexcomponents::Input.new(
      type: :search,
      class: "search-input",
      placeholder: "🔍 Search products...",
      autocomplete: "off",
      data: {
        controller: "search",
        action: "input->search#query:debounce(300)",
      },
    )

    output = render(component)

    # Check search input attributes
    assert_includes(output, 'type="search"')
    assert_includes(output, "search-input")
    assert_includes(output, "🔍 Search products...")
    assert_includes(output, 'autocomplete="off"')

    # Check stimulus integration with debounce
    assert_includes(output, 'data-controller="search"')
    assert_includes(output, "input->search#query:debounce(300)")
  end

  def test_input_date_integration
    component = ShadcnPhlexcomponents::Input.new(
      type: :date,
      class: "date-input",
      min: "2024-01-01",
      max: "2024-12-31",
      value: "2024-06-15",
      data: {
        controller: "date-picker",
        action: "change->date-picker#updateCalendar",
      },
    )

    output = render(component)

    # Check date input attributes
    assert_includes(output, 'type="date"')
    assert_includes(output, "date-input")
    assert_includes(output, 'min="2024-01-01"')
    assert_includes(output, 'max="2024-12-31"')
    assert_includes(output, 'value="2024-06-15"')

    # Check stimulus integration
    assert_includes(output, 'data-controller="date-picker"')
    assert_includes(output, "change->date-picker#updateCalendar")
  end
end
