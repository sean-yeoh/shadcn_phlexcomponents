# frozen_string_literal: true

require "test_helper"

class TestAccordion < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Accordion.new { "Accordion content" }
    output = render(component)

    assert_includes(output, 'data-multiple="false"')
    assert_includes(output, 'data-controller="accordion"')
    assert_includes(output, 'data-accordion-open-items-value="[]"')
    assert_includes(output, "Accordion content")
  end

  def test_it_should_render_item
    component = ShadcnPhlexcomponents::Accordion.new do |a|
      a.item(value: "item-1") do
        a.trigger { "Item 1" }
        a.content { "Item 1 content" }
      end
    end
    output = render(component)

    assert_includes(output, 'data-value="item-1"')
    assert_includes(output, "Item 1")
    assert_includes(output, "Item 1 content")
  end

  def test_it_should_render_accordion_with_multiple_enabled
    component = ShadcnPhlexcomponents::Accordion.new(multiple: true)
    output = render(component)

    assert_includes(output, 'data-multiple="true"')
  end

  def test_it_should_render_accordion_with_initial_value
    component = ShadcnPhlexcomponents::Accordion.new(value: "item-1")
    output = render(component)

    assert_includes(output, 'data-accordion-open-items-value="[&quot;item-1&quot;]"')
  end

  def test_it_should_render_accordion_with_multiple_values
    component = ShadcnPhlexcomponents::Accordion.new(value: ["item-1", "item-2"], multiple: true)
    output = render(component)

    assert_includes(output, 'data-multiple="true"')
    assert_includes(output, 'data-accordion-open-items-value="[&quot;item-1&quot;,&quot;item-2&quot;]"')
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Accordion.new(id: "accordion-id", class: "accordion-class", data: { testid: "accordion" })
    output = render(component)

    assert_includes(output, 'id="accordion-id"')
    assert_includes(output, "accordion-class")
    assert_includes(output, 'data-testid="accordion"')
  end
end

class TestAccordionItem < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AccordionItem.new(value: "item-1") { "Item content" }
    output = render(component)

    assert_includes(output, "border-b last:border-b-0")
    assert_includes(output, 'data-value="item-1"')
    assert_includes(output, 'data-accordion-target="item"')
    assert_includes(output, "Item content")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AccordionItem.new(value: "item-1", id: "accordion-item-id", class: "accordion-item-class")
    output = render(component)

    assert_includes(output, 'id="accordion-item-id"')
    assert_includes(output, "accordion-item-class")
  end
end

class TestAccordionTrigger < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AccordionTrigger.new(aria_id: "accordion-123") { "Accordion trigger" }
    output = render(component)

    assert_includes(output, "focus-visible:border-ring focus-visible:ring-ring/50")
    assert_includes(output, 'id="accordion-123-trigger"')
    assert_includes(output, 'aria-controls="accordion-123-content"')
    assert_includes(output, 'aria-expanded="false"')
    assert_includes(output, 'data-state="closed"')
    assert_includes(output, 'data-accordion-target="trigger"')
    assert_includes(output, "Accordion trigger")
    assert_match(%r{<svg.+</svg>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AccordionTrigger.new(aria_id: "accordion-123", class: "accordion-trigger-class") { "Accordion trigger" }
    output = render(component)

    assert_includes(output, "accordion-trigger-class")
  end
end

class TestAccordionContent < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AccordionContent.new(aria_id: "accordion-123")
    output = render(component) { "Content text" }

    assert_includes(output, "pt-0 pb-4")
    assert_includes(output, 'id="accordion-123-content"')
    assert_includes(output, 'role="region"')
    assert_includes(output, 'aria-labelledby="accordion-123-trigger"')
    assert_includes(output, 'data-state="closed"')
    assert_includes(output, 'data-accordion-target="content"')
    assert_includes(output, "Content text")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AccordionContent.new(aria_id: "accordion-123", class: "custom-content")
    output = render(component) { "Custom content" }

    assert_includes(output, "custom-content")
    assert_includes(output, "pt-0 pb-4")
    assert_includes(output, "Custom content")
  end
end

class TestAccordionContentContainer < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AccordionContentContainer.new(aria_id: "accordion-123")
    output = render(component) { "Container content" }

    assert_includes(output, "data-[state=closed]:animate-accordion-up data-[state=open]:animate-accordion-down overflow-hidden text-sm")
    assert_includes(output, 'id="accordion-123-content"')
    assert_includes(output, 'role="region"')
    assert_includes(output, 'aria-labelledby="accordion-123-trigger"')
    assert_includes(output, 'data-state="closed"')
    assert_includes(output, 'data-accordion-target="content"')
    assert_includes(output, "Container content")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AccordionContentContainer.new(aria_id: "accordion-123", class: "custom-container")
    output = render(component) { "Custom container" }

    assert_includes(output, "custom-container")
    assert_includes(output, "data-[state=closed]:animate-accordion-up")
    assert_includes(output, "Custom container")
  end
end

class TestAccordionWithCustomConfiguration < ComponentTest
  def test_accordion_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.accordion = {
      item: {
        base: "custom-item-base",
      },
      trigger: {
        base: "custom-trigger-base",
      },
      content: {
        base: "custom-content-base",
      },
      content_container: {
        base: "custom-container-base",
      },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload the Accordion classes to pick up the new configuration
    ["AccordionContentContainer", "AccordionContent", "AccordionTrigger", "AccordionItem"].each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/accordion.rb", __dir__))

    # Test AccordionItem with custom configuration
    item_component = ShadcnPhlexcomponents::AccordionItem.new(value: "test")
    item_output = render(item_component) { "Item" }
    assert_includes(item_output, "custom-item-base")

    # Test AccordionTrigger with custom configuration
    trigger_component = ShadcnPhlexcomponents::AccordionTrigger.new(aria_id: "test")
    trigger_output = render(trigger_component) { "Trigger" }
    assert_includes(trigger_output, "custom-trigger-base")

    # Test AccordionContent with custom configuration
    content_component = ShadcnPhlexcomponents::AccordionContent.new(aria_id: "test")
    content_output = render(content_component) { "Content" }
    assert_includes(content_output, "custom-content-base")

    # Test AccordionContentContainer with custom configuration
    container_component = ShadcnPhlexcomponents::AccordionContentContainer.new(aria_id: "test")
    container_output = render(container_component) { "Container" }
    assert_includes(container_output, "custom-container-base")
  ensure
    # Restore and reload classes
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    ["AccordionContentContainer", "AccordionContent", "AccordionTrigger", "AccordionItem"].each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/accordion.rb", __dir__))
  end
end

class TestAccordionIntegration < ComponentTest
  def test_complete_accordion_structure
    component = ShadcnPhlexcomponents::Accordion.new(value: "item-1") do |accordion|
      accordion.item(value: "item-1") do
        accordion.trigger { "First Item" }
        accordion.content { "First item content" }
      end
      accordion.item(value: "item-2") do
        accordion.trigger { "Second Item" }
        accordion.content { "Second item content" }
      end
    end

    output = render(component)

    # Check accordion container
    assert_includes(output, 'data-controller="accordion"')
    assert_includes(output, 'data-accordion-open-items-value="[&quot;item-1&quot;]"')

    # Check accordion items
    assert_includes(output, 'data-value="item-1"')
    assert_includes(output, 'data-value="item-2"')

    # Check triggers
    assert_includes(output, "First Item")
    assert_includes(output, "Second Item")

    # Check content
    assert_includes(output, "First item content")
    assert_includes(output, "Second item content")

    # Check structural classes
    assert_includes(output, "border-b last:border-b-0")
    assert_includes(output, "focus-visible:border-ring")
    assert_includes(output, "pt-0 pb-4")
    assert_includes(output, "data-[state=closed]:animate-accordion-up")
  end
end
