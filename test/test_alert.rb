# frozen_string_literal: true

require "test_helper"
# require_relative "../lib/shadcn_phlexcomponents/components/base"
# require_relative "../lib/shadcn_phlexcomponents/components/alert"

class TestAlert < ComponentTest
  def test_renders_basic_alert
    component = ShadcnPhlexcomponents::Alert.new
    output = render(component) { "Alert message" }
  end
  #   def test_renders_basic_alert
  #     component = ShadcnPhlexcomponents::Alert.new

  #     output = render(component) { "Alert message" }

  #     assert_includes(output, 'role="alert"')
  #     assert_includes(output, "Alert message")
  #     assert_includes(output, "relative w-full rounded-lg border")
  #   end

  #   def test_renders_default_variant
  #     component = ShadcnPhlexcomponents::Alert.new(variant: :default)

  #     output = render(component) { "Default alert" }

  #     assert_includes(output, "bg-card text-card-foreground")
  #     assert_includes(output, "Default alert")
  #   end

  #   def test_renders_destructive_variant
  #     component = ShadcnPhlexcomponents::Alert.new(variant: :destructive)

  #     output = render(component) { "Error alert" }

  #     assert_includes(output, "text-destructive bg-card")
  #     assert_includes(output, "Error alert")
  #   end

  #   def test_merges_custom_classes
  #     component = ShadcnPhlexcomponents::Alert.new(class: "custom-class")

  #     output = render(component) { "Custom alert" }

  #     assert_includes(output, "custom-class")
  #     assert_includes(output, "relative w-full rounded-lg border")
  #   end

  #   def test_accepts_custom_attributes
  #     component = ShadcnPhlexcomponents::Alert.new(id: "my-alert", data: { testid: "alert" })

  #     output = render(component) { "Alert with attributes" }

  #     assert_includes(output, 'id="my-alert"')
  #     assert_includes(output, 'data-testid="alert"')
  #   end

  #   def test_includes_shadcn_data_attribute
  #     component = ShadcnPhlexcomponents::Alert.new

  #     output = render(component) { "Alert" }

  #     assert_includes(output, 'data-shadcn-phlexcomponents="alert"')
  #   end

  #   def test_alert_with_title_and_description
  #     component = ShadcnPhlexcomponents::Alert.new

  #     output = render(component) do |alert|
  #       alert.title { "Alert Title" }
  #       alert.description { "Alert description text" }
  #     end

  #     assert_includes(output, "Alert Title")
  #     assert_includes(output, "Alert description text")
  #   end
  # end

  # class TestAlertTitle < ComponentTest
  #   def test_renders_alert_title
  #     component = ShadcnPhlexcomponents::AlertTitle.new

  #     output = render(component) { "Title Text" }

  #     assert_includes(output, "Title Text")
  #     assert_includes(output, "col-start-2 line-clamp-1 min-h-4 font-medium tracking-tight")
  #   end

  #   def test_alert_title_with_custom_attributes
  #     component = ShadcnPhlexcomponents::AlertTitle.new(class: "custom-title-class")

  #     output = render(component) { "Custom Title" }

  #     assert_includes(output, "custom-title-class")
  #     assert_includes(output, "Custom Title")
  #   end

  #   def test_alert_title_data_attribute
  #     component = ShadcnPhlexcomponents::AlertTitle.new

  #     output = render(component) { "Title" }

  #     assert_includes(output, 'data-shadcn-phlexcomponents="alert-title"')
  #   end
  # end

  # class TestAlertDescription < ComponentTest
  #   def test_renders_alert_description
  #     component = ShadcnPhlexcomponents::AlertDescription.new

  #     output = render(component) { "Description text" }

  #     assert_includes(output, "Description text")
  #     assert_includes(output, "text-muted-foreground col-start-2 grid justify-items-start gap-1")
  #   end

  #   def test_alert_description_with_custom_attributes
  #     component = ShadcnPhlexcomponents::AlertDescription.new(class: "custom-desc-class")

  #     output = render(component) { "Custom description" }

  #     assert_includes(output, "custom-desc-class")
  #     assert_includes(output, "Custom description")
  #   end

  #   def test_alert_description_data_attribute
  #     component = ShadcnPhlexcomponents::AlertDescription.new

  #     output = render(component) { "Description" }

  #     assert_includes(output, 'data-shadcn-phlexcomponents="alert-description"')
  #   end
end
