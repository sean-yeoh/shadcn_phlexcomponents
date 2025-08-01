# frozen_string_literal: true

require "test_helper"

class TestAlert < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Alert.new { "Alert message" }
    output = render(component)

    assert_includes(output, 'role="alert"')
    assert_includes(output, "Alert message")
    assert_includes(output, "relative w-full rounded-lg border")
  end

  def test_it_should_render_title
    component = ShadcnPhlexcomponents::Alert.new do |a|
      a.title { "Alert title" }
    end
    output = render(component)

    assert_includes(output, "Alert title")
    assert_includes(output, "col-start-2 line-clamp-1 min-h-4")
  end

  def test_it_should_render_description
    component = ShadcnPhlexcomponents::Alert.new do |a|
      a.description { "Alert description" }
    end
    output = render(component)

    assert_includes(output, "Alert description")
    assert_includes(output, "text-muted-foreground col-start-2 grid")
  end

  def test_it_should_render_default_variant
    component = ShadcnPhlexcomponents::Alert.new(variant: :default)

    output = render(component)

    assert_includes(output, "bg-card text-card-foreground")
  end

  def test_it_should_render_destructive_variant
    component = ShadcnPhlexcomponents::Alert.new(variant: :destructive)

    output = render(component)

    assert_includes(output, "text-destructive bg-card [&>svg]:text-current")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Alert.new(class: "alert-class", id: "alert-id", data: { testid: "alert" })

    output = render(component)

    assert_includes(output, "alert-class")
    assert_includes(output, 'id="alert-id"')
    assert_includes(output, 'data-testid="alert"')
  end

  def test_it_should_render_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.alert = {
      root: {
        base: "custom-alert",
      },
      title: {
        base: "custom-title",
      },
      description: {
        base: "custom-description",
      },
    }

    # Set configuration
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload the Alert class to pick up the new configuration
    ShadcnPhlexcomponents.send(:remove_const, :Alert) if ShadcnPhlexcomponents.const_defined?(:Alert)
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/alert.rb", __dir__))

    component = ShadcnPhlexcomponents::Alert.new do |a|
      a.title { "Alert title" }
      a.description { "Alert description" }
    end

    output = render(component)

    assert_includes(output, "custom-alert")
    assert_includes(output, "custom-title")
    assert_includes(output, "custom-description")
  ensure
    # Restore and reload class
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, ShadcnPhlexcomponents::Configuration.new)
    ShadcnPhlexcomponents.send(:remove_const, :Alert) if ShadcnPhlexcomponents.const_defined?(:Alert)
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/alert.rb", __dir__))
  end
end

class TestAlertTitle < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AlertTitle.new { "Alert title" }

    output = render(component)

    assert_includes(output, "Alert title")
    assert_includes(output, "col-start-2 line-clamp-1")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AlertTitle.new(class: "alert-title-class", id: "alert-title-id", data: { testid: "alert-title" })

    output = render(component)

    assert_includes(output, "alert-title-class")
    assert_includes(output, 'id="alert-title-id"')
    assert_includes(output, 'data-testid="alert-title"')
  end
end

class TestAlertDescription < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AlertDescription.new { "Alert description" }

    output = render(component)

    assert_includes(output, "Alert description")
    assert_includes(output, "text-muted-foreground col-start-2 grid")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AlertDescription.new(class: "alert-description-class", id: "alert-description-id", data: { testid: "alert-description" })

    output = render(component)

    assert_includes(output, "alert-description-class")
    assert_includes(output, 'id="alert-description-id"')
    assert_includes(output, 'data-testid="alert-description"')
  end
end
