# frozen_string_literal: true

require "test_helper"

class TestBadge < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Badge.new { "Badge text" }
    output = render(component)

    assert_includes(output, "Badge text")
    assert_includes(output, "inline-flex items-center justify-center rounded-md border px-2 py-0.5 text-xs font-medium")
    assert_includes(output, "border-transparent bg-primary text-primary-foreground")
    assert_includes(output, "<span")
    assert_includes(output, ">Badge text</span>")
  end

  def test_it_should_render_default_variant
    component = ShadcnPhlexcomponents::Badge.new(variant: :default) { "Default badge" }
    output = render(component)

    assert_includes(output, "Default badge")
    assert_includes(output, "border-transparent bg-primary text-primary-foreground")
    assert_includes(output, "[a&]:hover:bg-primary/90")
  end

  def test_it_should_render_secondary_variant
    component = ShadcnPhlexcomponents::Badge.new(variant: :secondary) { "Secondary badge" }
    output = render(component)

    assert_includes(output, "Secondary badge")
    assert_includes(output, "border-transparent bg-secondary text-secondary-foreground")
    assert_includes(output, "[a&]:hover:bg-secondary/90")
  end

  def test_it_should_render_destructive_variant
    component = ShadcnPhlexcomponents::Badge.new(variant: :destructive) { "Destructive badge" }
    output = render(component)

    assert_includes(output, "Destructive badge")
    assert_includes(output, "border-transparent bg-destructive text-white")
    assert_includes(output, "[a&]:hover:bg-destructive/90")
    assert_includes(output, "focus-visible:ring-destructive/20")
  end

  def test_it_should_render_outline_variant
    component = ShadcnPhlexcomponents::Badge.new(variant: :outline) { "Outline badge" }
    output = render(component)

    assert_includes(output, "Outline badge")
    assert_includes(output, "text-foreground")
    assert_includes(output, "[a&]:hover:bg-accent")
    assert_includes(output, "[a&]:hover:text-accent-foreground")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Badge.new(
      variant: :secondary,
      class: "badge-class",
      id: "badge-id",
      data: { testid: "badge" },
    ) { "Custom badge" }
    output = render(component)

    assert_includes(output, "badge-class")
    assert_includes(output, 'id="badge-id"')
    assert_includes(output, 'data-testid="badge"')
    assert_includes(output, "Custom badge")
    assert_includes(output, "bg-secondary")
  end

  def test_it_should_render_with_icon
    component = ShadcnPhlexcomponents::Badge.new(variant: :default) do
      "✓ Verified"
    end
    output = render(component)

    assert_includes(output, "✓ Verified")
    assert_includes(output, "bg-primary text-primary-foreground")
    # Badge has built-in icon sizing
    assert_includes(output, "[&>svg]:size-3")
  end

  def test_it_should_render_with_multiple_content_types
    component = ShadcnPhlexcomponents::Badge.new(variant: :outline) do
      "Count: 42"
    end
    output = render(component)

    assert_includes(output, "Count: 42")
    assert_includes(output, "text-foreground")
  end

  def test_it_should_render_focus_and_accessibility_attributes
    component = ShadcnPhlexcomponents::Badge.new(
      variant: :destructive,
      tabindex: 0,
      role: "status",
      aria: { label: "Error status" },
    ) { "Error" }
    output = render(component)

    assert_includes(output, 'tabindex="0"')
    assert_includes(output, 'role="status"')
    assert_includes(output, 'aria-label="Error status"')
    assert_includes(output, "focus-visible:border-ring")
    assert_includes(output, "focus-visible:ring-ring/50")
    assert_includes(output, "aria-invalid:ring-destructive/20")
  end

  def test_it_should_render_as_link_styles
    # Test that hover styles work when badge is inside a link
    component = ShadcnPhlexcomponents::Badge.new(variant: :default) { "Link badge" }
    output = render(component)

    # Contains link-specific hover styles
    assert_includes(output, "[a&]:hover:bg-primary/90")
    assert_includes(output, "Link badge")
  end

  def test_it_should_render_with_custom_styling
    component = ShadcnPhlexcomponents::Badge.new(
      variant: :secondary,
      class: "text-lg px-4 py-2",
    ) { "Large badge" }
    output = render(component)

    assert_includes(output, "Large badge")
    assert_includes(output, "text-lg px-4 py-2")
    # Should still include base classes
    assert_includes(output, "inline-flex items-center")
    assert_includes(output, "bg-secondary")
  end
end

class TestBadgeWithCustomConfiguration < ComponentTest
  def test_badge_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.badge = {
      base: "custom-badge-base",
      variants: {
        variant: {
          default: "custom-default-variant",
          secondary: "custom-secondary-variant",
          destructive: "custom-destructive-variant",
          outline: "custom-outline-variant",
        },
      },
      defaults: {
        variant: :secondary,
      },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload the Badge class to pick up the new configuration
    ShadcnPhlexcomponents.send(:remove_const, :Badge) if ShadcnPhlexcomponents.const_defined?(:Badge)
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/badge.rb", __dir__))

    # Test Badge with custom configuration - default variant
    default_component = ShadcnPhlexcomponents::Badge.new(variant: :default) { "Default" }
    default_output = render(default_component)
    assert_includes(default_output, "custom-badge-base")
    assert_includes(default_output, "custom-default-variant")

    # Test Badge with custom configuration - secondary variant
    secondary_component = ShadcnPhlexcomponents::Badge.new(variant: :secondary) { "Secondary" }
    secondary_output = render(secondary_component)
    assert_includes(secondary_output, "custom-secondary-variant")

    # Test Badge with custom configuration - destructive variant
    destructive_component = ShadcnPhlexcomponents::Badge.new(variant: :destructive) { "Destructive" }
    destructive_output = render(destructive_component)
    assert_includes(destructive_output, "custom-destructive-variant")

    # Test Badge with custom configuration - outline variant
    outline_component = ShadcnPhlexcomponents::Badge.new(variant: :outline) { "Outline" }
    outline_output = render(outline_component)
    assert_includes(outline_output, "custom-outline-variant")

    # Test Badge with custom default variant (should use :default since we didn't change the component logic)
    no_variant_component = ShadcnPhlexcomponents::Badge.new { "No variant" }
    no_variant_output = render(no_variant_component)
    assert_includes(no_variant_output, "custom-default-variant") # Should use default variant
  ensure
    # Restore and reload class
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    ShadcnPhlexcomponents.send(:remove_const, :Badge) if ShadcnPhlexcomponents.const_defined?(:Badge)
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/badge.rb", __dir__))
  end
end

class TestBadgeIntegration < ComponentTest
  def test_badge_variants_showcase
    variants = [:default, :secondary, :destructive, :outline]

    variants.each do |variant|
      component = ShadcnPhlexcomponents::Badge.new(variant: variant) do
        content = variant == :default ? "⭐ " : ""
        content + "#{variant.to_s.capitalize} badge"
      end

      output = render(component)

      # Common base classes
      assert_includes(output, "inline-flex items-center justify-center")
      assert_includes(output, "rounded-md border px-2 py-0.5 text-xs font-medium")
      assert_includes(output, "#{variant.to_s.capitalize} badge")

      # Variant-specific classes
      case variant
      when :default
        assert_includes(output, "bg-primary text-primary-foreground")
        assert_includes(output, "⭐")
      when :secondary
        assert_includes(output, "bg-secondary text-secondary-foreground")
      when :destructive
        assert_includes(output, "bg-destructive text-white")
      when :outline
        assert_includes(output, "text-foreground")
      end
    end
  end

  def test_badge_with_complex_content
    component = ShadcnPhlexcomponents::Badge.new(variant: :secondary) do
      "👥 12 active users 📈"
    end

    output = render(component)

    # Check complex content structure
    assert_includes(output, "👥 12 active users 📈")

    # Check badge styling
    assert_includes(output, "bg-secondary text-secondary-foreground")
    assert_includes(output, "[&>svg]:size-3") # Built-in icon sizing
    assert_includes(output, "gap-1") # Built-in gap for content
  end

  def test_badge_accessibility_and_interactive_features
    component = ShadcnPhlexcomponents::Badge.new(
      variant: :outline,
      tabindex: 0,
      role: "button",
      aria: { pressed: "false", label: "Toggle notification" },
      data: { action: "click->notification#toggle" },
    ) do
      "🔔 3"
    end

    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'role="button"')
    assert_includes(output, 'tabindex="0"')
    assert_includes(output, 'aria-pressed="false"')
    assert_includes(output, 'aria-label="Toggle notification"')

    # Check interactive attributes
    assert_includes(output, 'data-action="click->notification#toggle"')

    # Check focus styles are present
    assert_includes(output, "focus-visible:border-ring")
    assert_includes(output, "focus-visible:ring-ring/50")
    assert_includes(output, "focus-visible:ring-[3px]")

    # Check content
    assert_includes(output, "🔔 3")
  end

  def test_badge_in_different_contexts
    # Badge as status indicator
    status_badge = ShadcnPhlexcomponents::Badge.new(variant: :destructive, class: "animate-pulse") do
      "⚠️ Offline"
    end
    status_output = render(status_badge)

    assert_includes(status_output, "animate-pulse")
    assert_includes(status_output, "⚠️ Offline")
    assert_includes(status_output, "bg-destructive")

    # Badge as count indicator
    count_badge = ShadcnPhlexcomponents::Badge.new(variant: :default, class: "absolute -top-2 -right-2") do
      "99+"
    end
    count_output = render(count_badge)

    assert_includes(count_output, "absolute -top-2 -right-2")
    assert_includes(count_output, "99+")
    assert_includes(count_output, "bg-primary")

    # Badge as tag
    tag_badge = ShadcnPhlexcomponents::Badge.new(variant: :secondary, class: "mr-2") do
      "React ✕"
    end
    tag_output = render(tag_badge)

    assert_includes(tag_output, "mr-2")
    assert_includes(tag_output, "React ✕")
    assert_includes(tag_output, "bg-secondary")
  end
end
