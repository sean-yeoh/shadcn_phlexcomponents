# frozen_string_literal: true

require "test_helper"

class TestAspectRatio < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AspectRatio.new { "Aspect ratio content" }
    output = render(component)

    assert_includes(output, "relative w-full")
    assert_includes(output, "absolute inset-0")
    assert_includes(output, "Aspect ratio content")
    # Default 1/1 ratio should have 100% padding-bottom
    assert_includes(output, "padding-bottom: 100.0%")
  end

  def test_it_should_render_with_custom_ratio
    component = ShadcnPhlexcomponents::AspectRatio.new(ratio: "16/9") { "16:9 content" }
    output = render(component)

    assert_includes(output, "16:9 content")
    # 16/9 ratio should have ~56.25% padding-bottom (100 / (16/9))
    assert_match(/padding-bottom:\s*56\.25%/, output)
  end

  def test_it_should_render_with_square_ratio
    component = ShadcnPhlexcomponents::AspectRatio.new(ratio: "1/1") { "Square content" }
    output = render(component)

    assert_includes(output, "Square content")
    # 1/1 ratio should have 100% padding-bottom
    assert_includes(output, "padding-bottom: 100.0%")
  end

  def test_it_should_render_with_portrait_ratio
    component = ShadcnPhlexcomponents::AspectRatio.new(ratio: "3/4") { "Portrait content" }
    output = render(component)

    assert_includes(output, "Portrait content")
    # 3/4 ratio should have ~133.33% padding-bottom (100 / (3/4))
    assert_match(/padding-bottom:\s*133\.333/, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AspectRatio.new(ratio: "2/1", class: "aspect-class", id: "aspect-id", data: { testid: "aspect" })
    output = render(component)

    assert_includes(output, "aspect-class")
    assert_includes(output, 'id="aspect-id"')
    assert_includes(output, 'data-testid="aspect"')
    # 2/1 ratio should have 50% padding-bottom
    assert_includes(output, "padding-bottom: 50.0%")
  end
end

class TestAspectRatioContainer < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AspectRatioContainer.new(ratio: 1.0) { "Container content" }
    output = render(component)

    assert_includes(output, "relative w-full")
    assert_includes(output, "Container content")
    assert_includes(output, "padding-bottom: 100.0%")
  end

  def test_it_should_render_with_custom_ratio
    component = ShadcnPhlexcomponents::AspectRatioContainer.new(ratio: 1.777) { "Wide container" }
    output = render(component)

    assert_includes(output, "Wide container")
    # 1.777 ratio should have ~56.25% padding-bottom
    assert_match(/padding-bottom:\s*56\.2/, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AspectRatioContainer.new(ratio: 0.75, class: "container-class", id: "container-id")
    output = render(component)

    assert_includes(output, "container-class")
    assert_includes(output, 'id="container-id"')
    assert_includes(output, "relative w-full")
    # 0.75 ratio should have ~133.33% padding-bottom
    assert_match(/padding-bottom:\s*133\.333/, output)
  end
end

class TestAspectRatioWithCustomConfiguration < ComponentTest
  def test_aspect_ratio_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.aspect_ratio = {
      root: {
        base: "custom-aspect-base",
      },
      container: {
        base: "custom-container-base",
      },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload the AspectRatio classes to pick up the new configuration
    ["AspectRatioContainer", "AspectRatio"].each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/aspect_ratio.rb", __dir__))

    # Test AspectRatio with custom configuration
    aspect_component = ShadcnPhlexcomponents::AspectRatio.new { "Custom aspect" }
    aspect_output = render(aspect_component)
    assert_includes(aspect_output, "custom-aspect-base")

    # Test AspectRatioContainer with custom configuration
    container_component = ShadcnPhlexcomponents::AspectRatioContainer.new(ratio: 1.0) { "Custom container" }
    container_output = render(container_component)
    assert_includes(container_output, "custom-container-base")
  ensure
    # Restore and reload classes
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    ["AspectRatioContainer", "AspectRatio"].each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/aspect_ratio.rb", __dir__))
  end
end

class TestAspectRatioIntegration < ComponentTest
  def test_complete_aspect_ratio_structure
    component = ShadcnPhlexcomponents::AspectRatio.new(ratio: "16/9") do
      "Image content placeholder"
    end

    output = render(component)

    # Check container structure
    assert_includes(output, "relative w-full")
    assert_match(/padding-bottom:\s*56\.25%/, output)

    # Check content structure
    assert_includes(output, "absolute inset-0")
    assert_includes(output, "Image content placeholder")

    # Verify nested div structure
    assert_match(/<div[^>]*relative w-full[^>]*>.*<div[^>]*absolute inset-0[^>]*>/m, output)
  end
end
