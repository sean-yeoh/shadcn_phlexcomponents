# frozen_string_literal: true

require "test_helper"

# Mock model for testing
class TestUser
  attr_accessor :name, :email, :age, :active, :role, :preferences, :bio, :start_date, :end_date, :rating

  def initialize(attrs = {})
    @name = attrs[:name]
    @email = attrs[:email]
    @age = attrs[:age]
    @active = attrs[:active] || false
    @role = attrs[:role]
    @preferences = attrs[:preferences] || []
    @bio = attrs[:bio]
    @start_date = attrs[:start_date]
    @end_date = attrs[:end_date]
    @rating = attrs[:rating] || 5
    @errors = MockErrors.new
  end

  def persisted?
    false
  end

  def to_model
    self
  end

  def model_name
    MockModelName.new("TestUser", "test_user")
  end

  attr_reader :errors

  class MockModelName
    attr_reader :name, :param_key

    def initialize(name, param_key)
      @name = name
      @param_key = param_key
    end

    def human
      name.humanize
    end
  end

  class MockErrors
    def initialize
      @errors = {}
    end

    def add(field, message)
      @errors[field] ||= []
      @errors[field] << message
    end

    def [](field)
      @errors[field] || []
    end

    def full_messages_for(field)
      self[field]
    end

    def present?
      @errors.any?
    end
  end
end

class TestForm < ComponentTest
  def setup
    @user = TestUser.new(name: "John Doe", email: "john@example.com", age: 30)
  end

  def test_form_component_initialization
    # Test that Form component can be instantiated
    component = ShadcnPhlexcomponents::Form.new
    refute_nil(component)
    refute(component.instance_variable_get(:@loading))
  end

  def test_form_with_loading_state
    # Test loading state is properly set
    component = ShadcnPhlexcomponents::Form.new(loading: true)
    assert(component.instance_variable_get(:@loading))
  end

  def test_form_with_model
    # Test form with model initialization
    component = ShadcnPhlexcomponents::Form.new(model: @user)
    assert_equal(@user, component.instance_variable_get(:@model))
    assert_equal("test_user", component.instance_variable_get(:@object_name))
  end

  def test_form_without_model
    # Test form without model
    component = ShadcnPhlexcomponents::Form.new
    refute(component.instance_variable_get(:@model))
    assert_nil(component.instance_variable_get(:@object_name))
  end
end

class TestFormField < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::FormField.new { "Field content" }
    output = render(component)

    assert_includes(output, "Field content")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, "space-y-2")
    assert_match(%r{<div[^>]*>Field content</div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::FormField.new(
      class: "custom-field",
      id: "field-id",
      data: { testid: "form-field" },
    ) { "Custom field" }
    output = render(component)

    assert_includes(output, "custom-field")
    assert_includes(output, 'id="field-id"')
    assert_includes(output, 'data-testid="form-field"')
    assert_includes(output, "space-y-2")
  end

  def test_it_should_handle_different_spacing
    component = ShadcnPhlexcomponents::FormField.new(class: "space-y-4") { "Spaced field" }
    output = render(component)

    assert_includes(output, "space-y-4")
    assert_includes(output, "Spaced field")
  end
end

class TestFormWithCustomConfiguration < ComponentTest
  def test_form_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.form = {
      field: { base: "custom-form-field-base" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    form_classes = ["FormField", "Form"]

    form_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/form.rb", __dir__))

    # Test components with custom configuration
    field = ShadcnPhlexcomponents::FormField.new { "Test" }
    assert_includes(render(field), "custom-form-field-base")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    form_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/form.rb", __dir__))
  end
end

class TestFormIntegration < ComponentTest
  def test_form_component_initialization
    # Test form component initialization with options
    component = ShadcnPhlexcomponents::Form.new(
      class: "test-form",
      data: { controller: "form validation" },
      aria: { label: "Test form" },
      role: "form",
    )

    options = component.instance_variable_get(:@options)
    assert_equal("test-form", options[:class])
    assert_equal("form validation", options[:data][:controller])
    assert_equal("Test form", options[:aria][:label])
    assert_equal("form", options[:role])
  end

  def test_form_field_structure
    component = ShadcnPhlexcomponents::FormField.new(class: "test-field") do
      "Field content"
    end

    output = render(component)

    # Check FormField structure
    assert_includes(output, "test-field")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, "space-y-2")
    assert_includes(output, "Field content")
  end

  def test_form_field_attributes_integration
    # Test FormField with custom attributes
    component = ShadcnPhlexcomponents::FormField.new(
      class: "custom-field",
      id: "field-id",
      data: { testid: "form-field" },
    ) { "Test content" }

    output = render(component)

    # Check that custom attributes are present in output
    assert_includes(output, "custom-field")
    assert_includes(output, 'id="field-id"')
    assert_includes(output, 'data-testid="form-field"')
    assert_includes(output, "Test content")
  end
end
