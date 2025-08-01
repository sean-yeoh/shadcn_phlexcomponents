# frozen_string_literal: true

require "test_helper"

class TestButton < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Button.new { "Click me" }
    output = render(component)

    assert_includes(output, "Click me")
    assert_includes(output, "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium")
    assert_includes(output, "bg-primary text-primary-foreground shadow-xs hover:bg-primary/90")
    assert_includes(output, "h-9 px-4 py-2 has-[>svg]:px-3")
    assert_includes(output, 'type="button"')
    assert_match(%r{<button[^>]*type="button"[^>]*>.*Click me.*</button>}m, output)
  end

  def test_it_should_render_default_variant
    component = ShadcnPhlexcomponents::Button.new(variant: :default) { "Default" }
    output = render(component)

    assert_includes(output, "Default")
    assert_includes(output, "bg-primary text-primary-foreground shadow-xs hover:bg-primary/90")
  end

  def test_it_should_render_destructive_variant
    component = ShadcnPhlexcomponents::Button.new(variant: :destructive) { "Delete" }
    output = render(component)

    assert_includes(output, "Delete")
    assert_includes(output, "bg-destructive text-white shadow-xs hover:bg-destructive/90")
    assert_includes(output, "focus-visible:ring-destructive/20")
    assert_includes(output, "dark:focus-visible:ring-destructive/40")
  end

  def test_it_should_render_outline_variant
    component = ShadcnPhlexcomponents::Button.new(variant: :outline) { "Outline" }
    output = render(component)

    assert_includes(output, "Outline")
    assert_includes(output, "border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground")
    assert_includes(output, "dark:bg-input/30 dark:border-input dark:hover:bg-input/50")
  end

  def test_it_should_render_secondary_variant
    component = ShadcnPhlexcomponents::Button.new(variant: :secondary) { "Secondary" }
    output = render(component)

    assert_includes(output, "Secondary")
    assert_includes(output, "bg-secondary text-secondary-foreground shadow-xs hover:bg-secondary/80")
  end

  def test_it_should_render_ghost_variant
    component = ShadcnPhlexcomponents::Button.new(variant: :ghost) { "Ghost" }
    output = render(component)

    assert_includes(output, "Ghost")
    assert_includes(output, "hover:bg-accent hover:text-accent-foreground dark:hover:bg-accent/50")
    refute_includes(output, "bg-primary") # Should not have background by default
  end

  def test_it_should_render_link_variant
    component = ShadcnPhlexcomponents::Button.new(variant: :link) { "Link" }
    output = render(component)

    assert_includes(output, "Link")
    assert_includes(output, "text-primary underline-offset-4 hover:underline")
    refute_includes(output, "bg-primary") # Should not have background
  end

  def test_it_should_render_default_size
    component = ShadcnPhlexcomponents::Button.new(size: :default) { "Default Size" }
    output = render(component)

    assert_includes(output, "Default Size")
    assert_includes(output, "h-9 px-4 py-2 has-[>svg]:px-3")
  end

  def test_it_should_render_small_size
    component = ShadcnPhlexcomponents::Button.new(size: :sm) { "Small" }
    output = render(component)

    assert_includes(output, "Small")
    assert_includes(output, "h-8 rounded-md gap-1.5 px-3 has-[>svg]:px-2.5")
  end

  def test_it_should_render_large_size
    component = ShadcnPhlexcomponents::Button.new(size: :lg) { "Large" }
    output = render(component)

    assert_includes(output, "Large")
    assert_includes(output, "h-10 rounded-md px-6 has-[>svg]:px-4")
  end

  def test_it_should_render_icon_size
    component = ShadcnPhlexcomponents::Button.new(size: :icon) { "🔍" }
    output = render(component)

    assert_includes(output, "🔍")
    assert_includes(output, "size-9")
    refute_includes(output, "px-4") # Icon buttons don't have horizontal padding
  end

  def test_it_should_handle_variant_and_size_combinations
    component = ShadcnPhlexcomponents::Button.new(variant: :destructive, size: :lg) { "Delete Large" }
    output = render(component)

    assert_includes(output, "Delete Large")
    assert_includes(output, "bg-destructive text-white")
    assert_includes(output, "h-10 rounded-md px-6")
  end

  def test_it_should_render_custom_type
    component = ShadcnPhlexcomponents::Button.new(type: :submit) { "Submit" }
    output = render(component)

    assert_includes(output, "Submit")
    assert_includes(output, 'type="submit"')
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Button.new(
      variant: :outline,
      size: :sm,
      class: "custom-button",
      id: "my-button",
      data: { testid: "button", action: "click->controller#action" },
      aria: { label: "Custom button" },
    ) { "Custom" }
    output = render(component)

    assert_includes(output, "custom-button")
    assert_includes(output, 'id="my-button"')
    assert_includes(output, 'data-testid="button"')
    assert_includes(output, 'data-action="click->controller#action"')
    assert_includes(output, 'aria-label="Custom button"')
    assert_includes(output, "Custom")
    assert_includes(output, "border bg-background") # outline variant
    assert_includes(output, "h-8") # sm size
  end

  def test_it_should_render_with_icons
    component = ShadcnPhlexcomponents::Button.new(variant: :default) do
      "📧 Send Email"
    end
    output = render(component)

    assert_includes(output, "📧 Send Email")
    assert_includes(output, "[&_svg]:pointer-events-none")
    assert_includes(output, "[&_svg:not([class*='size-'])]:size-4")
    assert_includes(output, "has-[>svg]:px-3") # Adjusted padding for icons
  end

  def test_it_should_render_disabled_state
    component = ShadcnPhlexcomponents::Button.new(disabled: true) { "Disabled" }
    output = render(component)

    assert_includes(output, "Disabled")
    assert_includes(output, "disabled")
    assert_includes(output, "disabled:pointer-events-none disabled:opacity-50")
  end

  def test_it_should_render_focus_and_accessibility_states
    component = ShadcnPhlexcomponents::Button.new(
      variant: :outline,
      tabindex: 0,
      aria: { pressed: "false", invalid: "true" },
    ) { "Accessible" }
    output = render(component)

    assert_includes(output, "Accessible")
    assert_includes(output, 'tabindex="0"')
    assert_includes(output, 'aria-pressed="false"')
    assert_includes(output, 'aria-invalid="true"')
    assert_includes(output, "focus-visible:border-ring")
    assert_includes(output, "focus-visible:ring-ring/50")
    assert_includes(output, "aria-invalid:ring-destructive/20")
    assert_includes(output, "aria-invalid:border-destructive")
  end

  def test_it_should_handle_loading_state
    component = ShadcnPhlexcomponents::Button.new(
      variant: :default,
      disabled: true,
      data: { loading: "true" },
    ) { "⏳ Loading..." }
    output = render(component)

    assert_includes(output, "⏳ Loading...")
    assert_includes(output, "disabled")
    assert_includes(output, 'data-loading="true"')
    assert_includes(output, "disabled:pointer-events-none disabled:opacity-50")
  end

  def test_it_should_render_as_form_submit_button
    component = ShadcnPhlexcomponents::Button.new(
      type: :submit,
      variant: :default,
      form: "my-form",
    ) { "Submit Form" }
    output = render(component)

    assert_includes(output, "Submit Form")
    assert_includes(output, 'type="submit"')
    assert_includes(output, 'form="my-form"')
  end

  def test_it_should_handle_complex_content
    component = ShadcnPhlexcomponents::Button.new(variant: :secondary, size: :lg) do
      "📊 View Report"
    end
    output = render(component)

    assert_includes(output, "📊 View Report")
    assert_includes(output, "bg-secondary text-secondary-foreground")
    assert_includes(output, "h-10") # lg size
    assert_includes(output, "gap-2") # gap between content
  end
end

class TestButtonWithCustomConfiguration < ComponentTest
  def test_button_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.button = {
      base: "custom-button-base",
      variants: {
        variant: {
          default: "custom-default-variant",
          destructive: "custom-destructive-variant",
          outline: "custom-outline-variant",
          secondary: "custom-secondary-variant",
          ghost: "custom-ghost-variant",
          link: "custom-link-variant",
        },
        size: {
          default: "custom-default-size",
          sm: "custom-sm-size",
          lg: "custom-lg-size",
          icon: "custom-icon-size",
        },
      },
      defaults: {
        variant: :secondary,
        size: :lg,
      },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload the Button class to pick up the new configuration
    ShadcnPhlexcomponents.send(:remove_const, :Button) if ShadcnPhlexcomponents.const_defined?(:Button)
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/button.rb", __dir__))

    # Test Button with custom configuration - all variants
    variants = [:default, :destructive, :outline, :secondary, :ghost, :link]
    variants.each do |variant|
      component = ShadcnPhlexcomponents::Button.new(variant: variant) { variant.capitalize.to_s }
      output = render(component)
      assert_includes(output, "custom-button-base")
      assert_includes(output, "custom-#{variant}-variant")
    end

    # Test Button with custom configuration - all sizes
    sizes = [:default, :sm, :lg, :icon]
    sizes.each do |size|
      component = ShadcnPhlexcomponents::Button.new(size: size) { size.capitalize.to_s }
      output = render(component)
      assert_includes(output, "custom-button-base")
      assert_includes(output, "custom-#{size}-size")
    end

    # Test Button with custom defaults (using explicit no variant/size to use defaults)
    default_component = ShadcnPhlexcomponents::Button.new { "Default" }
    default_output = render(default_component)
    # Since no explicit variant/size is passed, it should use the custom configuration defaults
    assert_includes(default_output, "custom-default-variant") # Should use default variant from custom config
    assert_includes(default_output, "custom-default-size") # Should use default size from custom config
  ensure
    # Restore and reload class
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    ShadcnPhlexcomponents.send(:remove_const, :Button) if ShadcnPhlexcomponents.const_defined?(:Button)
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/button.rb", __dir__))
  end
end

class TestButtonIntegration < ComponentTest
  def test_button_variants_showcase
    variants = [:default, :destructive, :outline, :secondary, :ghost, :link]

    variants.each do |variant|
      component = ShadcnPhlexcomponents::Button.new(variant: variant) do
        content = case variant
        when :default then "✓ Save"
        when :destructive then "🗑️ Delete"
        when :outline then "📝 Edit"
        when :secondary then "📋 Copy"
        when :ghost then "👻 Ghost"
        when :link then "🔗 Link"
        end
        content
      end

      output = render(component)

      # Common base classes
      assert_includes(output, "inline-flex items-center justify-center")
      assert_includes(output, "gap-2 whitespace-nowrap rounded-md text-sm font-medium")
      assert_includes(output, "transition-all")

      # Variant-specific styling
      case variant
      when :default
        assert_includes(output, "bg-primary text-primary-foreground")
        assert_includes(output, "✓ Save")
      when :destructive
        assert_includes(output, "bg-destructive text-white")
        assert_includes(output, "🗑️ Delete")
      when :outline
        assert_includes(output, "border bg-background")
        assert_includes(output, "📝 Edit")
      when :secondary
        assert_includes(output, "bg-secondary text-secondary-foreground")
        assert_includes(output, "📋 Copy")
      when :ghost
        assert_includes(output, "hover:bg-accent")
        assert_includes(output, "👻 Ghost")
      when :link
        assert_includes(output, "text-primary underline-offset-4")
        assert_includes(output, "🔗 Link")
      end
    end
  end

  def test_button_sizes_showcase
    sizes = [:sm, :default, :lg, :icon]

    sizes.each do |size|
      content = size == :icon ? "🔍" : "#{size.to_s.capitalize} Button"
      component = ShadcnPhlexcomponents::Button.new(variant: :outline, size: size) { content }

      output = render(component)

      # Common classes
      assert_includes(output, "inline-flex items-center justify-center")

      # Size-specific classes
      case size
      when :sm
        assert_includes(output, "h-8 rounded-md gap-1.5 px-3")
        assert_includes(output, "Sm Button")
      when :default
        assert_includes(output, "h-9 px-4 py-2")
        assert_includes(output, "Default Button")
      when :lg
        assert_includes(output, "h-10 rounded-md px-6")
        assert_includes(output, "Lg Button")
      when :icon
        assert_includes(output, "size-9")
        assert_includes(output, "🔍")
      end
    end
  end

  def test_button_interactive_states_and_accessibility
    component = ShadcnPhlexcomponents::Button.new(
      variant: :destructive,
      size: :default,
      type: :button,
      role: "button",
      tabindex: 0,
      aria: {
        label: "Delete selected items",
        describedby: "delete-help",
        pressed: "false",
      },
      data: {
        action: "click->modal#confirm",
        testid: "delete-button",
      },
    ) { "🗑️ Delete Selected" }

    output = render(component)

    # Check interactive attributes
    assert_includes(output, 'type="button"')
    assert_includes(output, 'role="button"')
    assert_includes(output, 'tabindex="0"')

    # Check ARIA attributes
    assert_includes(output, 'aria-label="Delete selected items"')
    assert_includes(output, 'aria-describedby="delete-help"')
    assert_includes(output, 'aria-pressed="false"')

    # Check data attributes
    assert_includes(output, 'data-action="click->modal#confirm"')
    assert_includes(output, 'data-testid="delete-button"')

    # Check focus and interaction styles
    assert_includes(output, "focus-visible:border-ring")
    assert_includes(output, "focus-visible:ring-ring/50")
    assert_includes(output, "focus-visible:ring-[3px]")

    # Check variant styling
    assert_includes(output, "bg-destructive text-white")
    assert_includes(output, "hover:bg-destructive/90")

    # Check content
    assert_includes(output, "🗑️ Delete Selected")
  end

  def test_button_form_integration
    # Submit button
    submit_button = ShadcnPhlexcomponents::Button.new(
      type: :submit,
      variant: :default,
      form: "user-form",
      disabled: false,
    ) { "💾 Save Changes" }
    submit_output = render(submit_button)

    assert_includes(submit_output, 'type="submit"')
    assert_includes(submit_output, 'form="user-form"')
    assert_includes(submit_output, "💾 Save Changes")
    assert_includes(submit_output, "bg-primary text-primary-foreground")

    # Reset button
    reset_button = ShadcnPhlexcomponents::Button.new(
      type: :reset,
      variant: :outline,
      size: :sm,
    ) { "🔄 Reset" }
    reset_output = render(reset_button)

    assert_includes(reset_output, 'type="reset"')
    assert_includes(reset_output, "🔄 Reset")
    assert_includes(reset_output, "border bg-background")
    assert_includes(reset_output, "h-8") # sm size
  end

  def test_button_loading_and_disabled_states
    # Loading button
    loading_button = ShadcnPhlexcomponents::Button.new(
      variant: :default,
      disabled: true,
      aria: { busy: "true" },
      data: { loading: "true" },
    ) { "⏳ Processing..." }
    loading_output = render(loading_button)

    assert_includes(loading_output, "disabled")
    assert_includes(loading_output, 'aria-busy="true"')
    assert_includes(loading_output, 'data-loading="true"')
    assert_includes(loading_output, "disabled:pointer-events-none disabled:opacity-50")
    assert_includes(loading_output, "⏳ Processing...")

    # Disabled with reason
    disabled_button = ShadcnPhlexcomponents::Button.new(
      variant: :destructive,
      disabled: true,
      aria: { disabled: "true", describedby: "delete-disabled-reason" },
      title: "Cannot delete: item is in use",
    ) { "🗑️ Delete" }
    disabled_output = render(disabled_button)

    assert_includes(disabled_output, "disabled")
    assert_includes(disabled_output, 'aria-disabled="true"')
    assert_includes(disabled_output, 'aria-describedby="delete-disabled-reason"')
    assert_includes(disabled_output, 'title="Cannot delete: item is in use"')
  end
end
