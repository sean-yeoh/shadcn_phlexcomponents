# frozen_string_literal: true

require "test_helper"

class TestDialog < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Dialog.new(open: false) { "Dialog content" }
    output = render(component)

    assert_includes(output, "Dialog content")
    assert_includes(output, "inline-flex max-w-fit")
    assert_includes(output, 'data-shadcn-phlexcomponents="dialog"')
    assert_includes(output, 'data-controller="dialog"')
    assert_includes(output, 'data-dialog-is-open-value="false"')
    assert_match(%r{<div[^>]*>.*Dialog content.*</div>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Dialog.new(
      class: "custom-dialog",
      id: "dialog-id",
      data: { testid: "dialog" },
    ) { "Custom content" }
    output = render(component)

    assert_includes(output, "custom-dialog")
    assert_includes(output, 'id="dialog-id"')
    assert_includes(output, 'data-testid="dialog"')
    assert_includes(output, "inline-flex max-w-fit")
  end

  def test_it_should_handle_open_state
    component = ShadcnPhlexcomponents::Dialog.new(open: true) { "Content" }
    output = render(component)

    assert_includes(output, 'data-dialog-is-open-value="true"')
  end

  def test_it_should_generate_unique_aria_id
    dialog1 = ShadcnPhlexcomponents::Dialog.new do |dialog|
      dialog.trigger { "Trigger 1" }
      dialog.content { "Content 1" }
    end
    output1 = render(dialog1)

    dialog2 = ShadcnPhlexcomponents::Dialog.new do |dialog|
      dialog.trigger { "Trigger 2" }
      dialog.content { "Content 2" }
    end
    output2 = render(dialog2)

    # Extract aria-controls values to ensure they're different
    controls1 = output1[/aria-controls="([^"]*)"/, 1]
    controls2 = output2[/aria-controls="([^"]*)"/, 1]

    refute_nil(controls1)
    refute_nil(controls2)
    refute_equal(controls1, controls2)
  end

  def test_it_should_include_overlay
    component = ShadcnPhlexcomponents::Dialog.new { "Content" }
    output = render(component)

    # Check for overlay target
    assert_includes(output, 'data-dialog-target="overlay"')
    assert_includes(output, 'data-state="closed"')
  end

  def test_it_should_render_with_helper_methods
    component = ShadcnPhlexcomponents::Dialog.new do |dialog|
      dialog.trigger(class: "custom-trigger") { "Open Dialog" }
      dialog.content(class: "custom-content") do
        dialog.header do
          dialog.title { "Dialog Title" }
          dialog.description { "Dialog description text" }
        end
        dialog.footer do
          "Footer content"
        end
      end
    end
    output = render(component)

    # Check trigger
    assert_includes(output, "Open Dialog")
    assert_includes(output, "custom-trigger")
    assert_includes(output, 'role="button"')
    assert_includes(output, 'data-dialog-target="trigger"')

    # Check content
    assert_includes(output, "custom-content")
    assert_includes(output, 'role="dialog"')
    assert_includes(output, 'data-dialog-target="content"')

    # Check header structure
    assert_includes(output, "flex flex-col gap-2 text-center sm:text-left")

    # Check title
    assert_includes(output, "Dialog Title")
    assert_includes(output, "text-lg leading-none font-semibold")

    # Check description
    assert_includes(output, "Dialog description text")
    assert_includes(output, "text-muted-foreground text-sm")

    # Check footer
    assert_includes(output, "Footer content")
    assert_includes(output, "flex flex-col-reverse gap-2 sm:flex-row sm:justify-end")
  end

  def test_it_should_render_complete_dialog_structure
    component = ShadcnPhlexcomponents::Dialog.new(
      open: false,
      class: "full-dialog",
    ) do |dialog|
      dialog.trigger(class: "trigger-style") { "Open Full Dialog" }
      dialog.content(class: "content-style") do
        dialog.header do
          dialog.title(class: "custom-title") { "Complete Dialog" }
          dialog.description(class: "custom-description") { "This is a complete dialog example" }
        end

        dialog.footer(class: "custom-footer") do
          dialog.close(class: "close-button") { "Cancel" }
          "Save"
        end
      end
    end
    output = render(component)

    # Check main container
    assert_includes(output, "full-dialog")
    assert_includes(output, 'data-controller="dialog"')
    assert_includes(output, 'data-dialog-is-open-value="false"')

    # Check trigger with styling
    assert_includes(output, "Open Full Dialog")
    assert_includes(output, "trigger-style")
    assert_includes(output, 'aria-haspopup="dialog"')

    # Check content and structure
    assert_includes(output, "content-style")
    assert_includes(output, 'data-state="closed"')

    # Check title and description with custom classes
    assert_includes(output, "Complete Dialog")
    assert_includes(output, "custom-title")
    assert_includes(output, "This is a complete dialog example")
    assert_includes(output, "custom-description")

    # Check that content is present (the string content might not be visible due to DialogContent structure)
    assert_includes(output, "Complete Dialog")

    # Check footer and close functionality
    assert_includes(output, "custom-footer")
    assert_includes(output, "Cancel")
    assert_includes(output, "close-button")

    # Check close icon is included
    assert_includes(output, 'data-action="click->dialog#close"')
    assert_match(%r{<svg[^>]*>.*</svg>}m, output) # Close icon SVG
  end
end

class TestDialogTrigger < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DialogTrigger.new(
      aria_id: "test-dialog",
    ) { "Trigger content" }
    output = render(component)

    assert_includes(output, "Trigger content")
    assert_includes(output, 'data-shadcn-phlexcomponents="dialog-trigger"')
    assert_includes(output, 'role="button"')
    assert_includes(output, 'aria-controls="test-dialog-content"')
    assert_includes(output, 'data-dialog-target="trigger"')
    assert_includes(output, 'data-action="click->dialog#open"')
    assert_match(%r{<div[^>]*>.*Trigger content.*</div>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::DialogTrigger.new(
      aria_id: "custom-test",
      class: "custom-trigger",
      id: "trigger-id",
    ) { "Custom trigger" }
    output = render(component)

    assert_includes(output, "custom-trigger")
    assert_includes(output, 'id="trigger-id"')
    assert_includes(output, 'aria-controls="custom-test-content"')
  end

  def test_it_should_handle_as_child_mode
    component = ShadcnPhlexcomponents::DialogTrigger.new(
      as_child: true,
      aria_id: "test",
    ) { "<button class=\"my-button\">Child Button</button>".html_safe }
    output = render(component)

    assert_includes(output, 'data-as-child="true"')
    assert_includes(output, "my-button")
    assert_includes(output, "Child Button")
    assert_includes(output, 'data-action="click->dialog#open"')
  end

  def test_it_should_include_aria_attributes
    component = ShadcnPhlexcomponents::DialogTrigger.new(aria_id: "accessibility-test")
    output = render(component)

    assert_includes(output, 'aria-haspopup="dialog"')
    assert_includes(output, 'aria-expanded="false"')
    assert_includes(output, 'aria-controls="accessibility-test-content"')
  end
end

class TestDialogContent < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DialogContent.new(
      aria_id: "test-content",
    ) { "Content body" }
    output = render(component)

    assert_includes(output, "Content body")
    assert_includes(output, 'data-shadcn-phlexcomponents="dialog-content"')
    assert_includes(output, 'id="test-content-content"')
    assert_includes(output, 'role="dialog"')
    assert_includes(output, 'data-dialog-target="content"')
    assert_includes(output, 'data-state="closed"')
    assert_includes(output, 'style="display: none;"')
  end

  def test_it_should_include_accessibility_attributes
    component = ShadcnPhlexcomponents::DialogContent.new(aria_id: "a11y-test") { "Content" }
    output = render(component)

    assert_includes(output, 'aria-describedby="a11y-test-description"')
    assert_includes(output, 'aria-labelledby="a11y-test-title"')
    assert_includes(output, 'tabindex="-1"')
  end

  def test_it_should_include_close_icon
    component = ShadcnPhlexcomponents::DialogContent.new(aria_id: "close-test") { "Content" }
    output = render(component)

    # Check for close icon functionality
    assert_includes(output, 'data-action="click->dialog#close"')
    assert_includes(output, "sr-only")
    assert_includes(output, "close")
    assert_match(%r{<svg[^>]*>.*</svg>}m, output)
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::DialogContent.new(aria_id: "style-test") { "Content" }
    output = render(component)

    assert_includes(output, "bg-background")
    assert_includes(output, "data-[state=open]:animate-in")
    assert_includes(output, "data-[state=closed]:animate-out")
    assert_includes(output, "fixed top-[50%] left-[50%]")
    assert_includes(output, "z-50")
    assert_includes(output, "pointer-events-auto outline-none")
  end
end

class TestDialogHeader < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DialogHeader.new { "Header content" }
    output = render(component)

    assert_includes(output, "Header content")
    assert_includes(output, 'data-shadcn-phlexcomponents="dialog-header"')
    assert_includes(output, "flex flex-col gap-2 text-center sm:text-left")
    assert_match(%r{<div[^>]*>Header content</div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::DialogHeader.new(
      class: "custom-header",
      id: "header-id",
    ) { "Custom header" }
    output = render(component)

    assert_includes(output, "custom-header")
    assert_includes(output, 'id="header-id"')
  end
end

class TestDialogTitle < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DialogTitle.new(
      aria_id: "title-test",
    ) { "Dialog Title" }
    output = render(component)

    assert_includes(output, "Dialog Title")
    assert_includes(output, 'data-shadcn-phlexcomponents="dialog-title"')
    assert_includes(output, 'id="title-test-title"')
    assert_includes(output, "text-lg leading-none font-semibold")
    assert_match(%r{<h2[^>]*>Dialog Title</h2>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::DialogTitle.new(
      aria_id: "custom",
      class: "custom-title",
    ) { "Custom Title" }
    output = render(component)

    assert_includes(output, "custom-title")
    assert_includes(output, 'id="custom-title"') # Uses aria_id for default id
  end
end

class TestDialogDescription < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DialogDescription.new(
      aria_id: "desc-test",
    ) { "Dialog description" }
    output = render(component)

    assert_includes(output, "Dialog description")
    assert_includes(output, 'data-shadcn-phlexcomponents="dialog-description"')
    assert_includes(output, 'id="desc-test-description"')
    assert_includes(output, "text-muted-foreground text-sm")
    assert_match(%r{<p[^>]*>Dialog description</p>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::DialogDescription.new(
      aria_id: "custom",
      class: "custom-description",
    ) { "Custom Description" }
    output = render(component)

    assert_includes(output, "custom-description")
    assert_includes(output, 'id="custom-description"')
  end
end

class TestDialogFooter < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DialogFooter.new { "Footer content" }
    output = render(component)

    assert_includes(output, "Footer content")
    assert_includes(output, 'data-shadcn-phlexcomponents="dialog-footer"')
    assert_includes(output, "flex flex-col-reverse gap-2 sm:flex-row sm:justify-end")
    assert_match(%r{<div[^>]*>Footer content</div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::DialogFooter.new(
      class: "custom-footer",
      id: "footer-id",
    ) { "Custom footer" }
    output = render(component)

    assert_includes(output, "custom-footer")
    assert_includes(output, 'id="footer-id"')
  end
end

class TestDialogClose < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::DialogClose.new { "Close button" }
    output = render(component)

    assert_includes(output, "Close button")
    assert_includes(output, 'data-shadcn-phlexcomponents="dialog-close"')
    assert_includes(output, 'role="button"')
    assert_includes(output, 'data-action="click->dialog#close"')
    assert_match(%r{<div[^>]*>.*Close button.*</div>}m, output)
  end

  def test_it_should_handle_as_child_mode
    component = ShadcnPhlexcomponents::DialogClose.new(as_child: true) do
      "<button class=\"close-btn\">Cancel</button>".html_safe
    end
    output = render(component)

    assert_includes(output, "close-btn")
    assert_includes(output, "Cancel")
    assert_includes(output, 'data-action="click->dialog#close"')
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::DialogClose.new(
      class: "custom-close",
      id: "close-id",
    ) { "Close" }
    output = render(component)

    assert_includes(output, "custom-close")
    assert_includes(output, 'id="close-id"')
  end
end

class TestDialogCloseIcon < ComponentTest
  def test_it_should_render_close_icon
    component = ShadcnPhlexcomponents::DialogCloseIcon.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="dialog-close-icon"')
    assert_includes(output, 'data-action="click->dialog#close"')
    assert_includes(output, "sr-only")
    assert_includes(output, "close")
    assert_match(%r{<button[^>]*>.*</button>}m, output)
    assert_match(%r{<svg[^>]*>.*</svg>}m, output)
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::DialogCloseIcon.new
    output = render(component)

    assert_includes(output, "absolute top-4 right-4")
    assert_includes(output, "opacity-70 transition-opacity hover:opacity-100")
    assert_includes(output, "focus:ring-2")
    assert_includes(output, "focus:ring-offset-2")
  end
end

class TestDialogWithCustomConfiguration < ComponentTest
  def test_dialog_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.dialog = {
      root: { base: "custom-dialog-base" },
      content: { base: "custom-content-base" },
      header: { base: "custom-header-base" },
      title: { base: "custom-title-base" },
      description: { base: "custom-description-base" },
      footer: { base: "custom-footer-base" },
      close_icon: { base: "custom-close-icon-base" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    dialog_classes = [
      "DialogCloseIcon",
      "DialogClose",
      "DialogFooter",
      "DialogDescription",
      "DialogTitle",
      "DialogHeader",
      "DialogContent",
      "DialogTrigger",
      "Dialog",
    ]

    dialog_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/dialog.rb", __dir__))

    # Test components with custom configuration
    dialog = ShadcnPhlexcomponents::Dialog.new { "Test" }
    assert_includes(render(dialog), "custom-dialog-base")

    content = ShadcnPhlexcomponents::DialogContent.new(aria_id: "test") { "Content" }
    assert_includes(render(content), "custom-content-base")

    header = ShadcnPhlexcomponents::DialogHeader.new { "Header" }
    assert_includes(render(header), "custom-header-base")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    dialog_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/dialog.rb", __dir__))
  end
end

class TestDialogIntegration < ComponentTest
  def test_complete_dialog_workflow
    component = ShadcnPhlexcomponents::Dialog.new(
      open: false,
      class: "user-dialog",
      data: { controller: "dialog analytics", analytics_category: "user-interaction" },
    ) do |dialog|
      dialog.trigger(class: "open-btn") { "👤 Open User Profile" }
      dialog.content(class: "profile-dialog") do
        dialog.header do
          dialog.title { "🔧 User Settings" }
          dialog.description { "Manage your account settings and preferences" }
        end

        dialog.footer do
          dialog.close(class: "cancel-btn") { "Cancel" }
        end
      end
    end

    output = render(component)

    # Check main structure
    assert_includes(output, "user-dialog")
    # Controller merging may include spaces
    assert_match(/data-controller="[^"]*dialog[^"]*analytics[^"]*"/, output)
    assert_includes(output, 'data-analytics-category="user-interaction"')

    # Check trigger with emojis
    assert_includes(output, "👤 Open User Profile")
    assert_includes(output, "open-btn")
    assert_includes(output, 'aria-haspopup="dialog"')

    # Check content structure
    assert_includes(output, "profile-dialog")
    assert_includes(output, 'role="dialog"')

    # Check header with emojis and content
    assert_includes(output, "🔧 User Settings")
    assert_includes(output, "Manage your account settings and preferences")

    # Check footer buttons
    assert_includes(output, "cancel-btn")
    assert_includes(output, "Cancel")

    # Check close functionality
    assert_includes(output, 'data-action="click->dialog#close"')

    # Check accessibility
    assert_match(/aria-labelledby="[^"]*-title"/, output)
    assert_match(/aria-describedby="[^"]*-description"/, output)
  end

  def test_dialog_accessibility_features
    component = ShadcnPhlexcomponents::Dialog.new(
      aria: { label: "Settings dialog", describedby: "settings-help" },
    ) do |dialog|
      dialog.trigger(aria: { labelledby: "dialog-label" }) { "Accessible trigger" }
      dialog.content do
        dialog.header do
          dialog.title { "Accessible Dialog" }
          dialog.description { "This dialog follows accessibility guidelines" }
        end
      end
    end

    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'aria-label="Settings dialog"')
    assert_includes(output, 'aria-describedby="settings-help"')
    assert_includes(output, 'aria-labelledby="dialog-label"')

    # Check ARIA roles and relationships
    assert_includes(output, 'role="button"') # trigger
    assert_includes(output, 'role="dialog"') # content
    assert_includes(output, 'aria-haspopup="dialog"')
    assert_match(/aria-controls="[^"]*-content"/, output)
    assert_match(/aria-labelledby="[^"]*-title"/, output)
    assert_match(/aria-describedby="[^"]*-description"/, output)
  end

  def test_dialog_stimulus_integration
    component = ShadcnPhlexcomponents::Dialog.new(
      data: {
        controller: "dialog custom-modal",
        custom_modal_size_value: "large",
      },
    ) do |dialog|
      dialog.trigger(
        data: { action: "click->custom-modal#beforeOpen" },
      ) { "Stimulus trigger" }

      dialog.content do
        dialog.close(
          data: { action: "click->custom-modal#onClose" },
        ) { "Custom Close" }
      end
    end

    output = render(component)

    # Check multiple controllers
    assert_match(/data-controller="dialog[^"]*custom-modal/, output)
    assert_includes(output, 'data-custom-modal-size-value="large"')

    # Check custom actions
    assert_match(/click->custom-modal#beforeOpen/, output)
    assert_match(/click->custom-modal#onClose/, output)

    # Check default dialog actions still work
    assert_match(/click->dialog#open/, output)
    assert_match(/click->dialog#close/, output)
  end
end
