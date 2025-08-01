# frozen_string_literal: true

require "test_helper"

class TestAlertDialog < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AlertDialog.new { "Alert dialog content" }
    output = render(component)

    assert_includes(output, 'data-controller="alert-dialog"')
    assert_includes(output, 'data-alert-dialog-is-open-value="false"')
    assert_includes(output, "inline-flex max-w-fit")
    assert_includes(output, "Alert dialog content")
    assert_includes(output, 'data-alert-dialog-target="overlay"')
  end

  def test_it_should_render_with_open_state
    component = ShadcnPhlexcomponents::AlertDialog.new(open: true) { "Content" }
    output = render(component)

    assert_includes(output, 'data-alert-dialog-is-open-value="true"')
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AlertDialog.new(id: "alert-dialog-id", class: "alert-dialog-class", data: { testid: "alert-dialog" }) { "Content" }
    output = render(component)

    assert_includes(output, 'id="alert-dialog-id"')
    assert_includes(output, "alert-dialog-class")
    assert_includes(output, 'data-testid="alert-dialog"')
  end

  def test_it_should_render_trigger
    component = ShadcnPhlexcomponents::AlertDialog.new do |dialog|
      dialog.trigger { "Open Dialog" }
    end
    output = render(component)

    assert_includes(output, "Open Dialog")
    assert_includes(output, 'role="button"')
    assert_includes(output, 'aria-haspopup="dialog"')
    assert_includes(output, 'aria-expanded="false"')
    assert_includes(output, 'data-alert-dialog-target="trigger"')
    assert_includes(output, 'data-action="click->alert-dialog#open"')
  end

  def test_it_should_render_content_structure
    component = ShadcnPhlexcomponents::AlertDialog.new do |dialog|
      dialog.content do
        dialog.header do
          dialog.title { "Alert Title" }
          dialog.description { "Alert description text" }
        end
        dialog.footer do
          dialog.cancel { "Cancel" }
          dialog.action { "Continue" }
        end
      end
    end
    output = render(component)

    assert_includes(output, "Alert Title")
    assert_includes(output, "Alert description text")
    assert_includes(output, "Cancel")
    assert_includes(output, "Continue")
  end
end

class TestAlertDialogTrigger < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AlertDialogTrigger.new(aria_id: "alert-dialog-123") { "Trigger text" }
    output = render(component)

    assert_includes(output, 'role="button"')
    assert_includes(output, 'aria-haspopup="dialog"')
    assert_includes(output, 'aria-expanded="false"')
    assert_includes(output, 'aria-controls="alert-dialog-123-content"')
    assert_includes(output, 'data-as-child="false"')
    assert_includes(output, 'data-alert-dialog-target="trigger"')
    assert_includes(output, 'data-action="click->alert-dialog#open"')
    assert_includes(output, "Trigger text")
  end

  def test_it_should_render_with_as_child
    component = ShadcnPhlexcomponents::AlertDialogTrigger.new(aria_id: "alert-dialog-123", as_child: true) do
      "<button class='custom-btn'>Custom Button</button>".html_safe
    end
    output = render(component)

    # Should merge the trigger attributes with the button element
    # Note: role="button" is removed when merging with actual button element
    assert_includes(output, 'aria-haspopup="dialog"')
    assert_includes(output, 'aria-expanded="false"')
    assert_includes(output, 'aria-controls="alert-dialog-123-content"')
    assert_includes(output, 'data-alert-dialog-target="trigger"')
    assert_includes(output, 'data-action="click->alert-dialog#open"')
    assert_includes(output, "Custom Button")
    assert_includes(output, "custom-btn")
    # Should be a button element, not a div
    assert_includes(output, "<button")
    assert_includes(output, "</button>")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AlertDialogTrigger.new(aria_id: "alert-dialog-123", class: "trigger-class", id: "trigger-id")
    output = render(component)

    assert_includes(output, "trigger-class")
    assert_includes(output, 'id="trigger-id"')
  end
end

class TestAlertDialogContent < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AlertDialogContent.new(aria_id: "alert-dialog-123") { "Content text" }
    output = render(component)

    assert_includes(output, 'id="alert-dialog-123-content"')
    assert_includes(output, 'tabindex="-1"')
    assert_includes(output, 'role="alertdialog"')
    assert_includes(output, 'aria-describedby="alert-dialog-123-description"')
    assert_includes(output, 'aria-labelledby="alert-dialog-123-title"')
    assert_includes(output, 'data-state="closed"')
    assert_includes(output, 'data-alert-dialog-target="content"')
    assert_match(/style="[^"]*display:\s*none/, output)
    assert_includes(output, "bg-background data-[state=open]:animate-in")
    assert_includes(output, "Content text")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AlertDialogContent.new(aria_id: "alert-dialog-123", class: "content-class")
    output = render(component)

    assert_includes(output, "content-class")
    assert_includes(output, "bg-background")
  end
end

class TestAlertDialogHeader < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AlertDialogHeader.new { "Header content" }
    output = render(component)

    assert_includes(output, "flex flex-col gap-2 text-center sm:text-left")
    assert_includes(output, "Header content")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AlertDialogHeader.new(class: "header-class", id: "header-id")
    output = render(component)

    assert_includes(output, "header-class")
    assert_includes(output, 'id="header-id"')
  end
end

class TestAlertDialogTitle < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AlertDialogTitle.new(aria_id: "alert-dialog-123") { "Dialog Title" }
    output = render(component)

    assert_includes(output, 'id="alert-dialog-123-title"')
    assert_includes(output, "text-lg font-semibold")
    assert_includes(output, "Dialog Title")
    assert_match(%r{<h2[^>]*>Dialog Title</h2>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AlertDialogTitle.new(aria_id: "alert-dialog-123", class: "title-class")
    output = render(component)

    assert_includes(output, "title-class")
    assert_includes(output, "text-lg font-semibold")
  end
end

class TestAlertDialogDescription < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AlertDialogDescription.new(aria_id: "alert-dialog-123") { "Description text" }
    output = render(component)

    assert_includes(output, 'id="alert-dialog-123-description"')
    assert_includes(output, "text-sm text-muted-foreground")
    assert_includes(output, "Description text")
    assert_match(%r{<p[^>]*>Description text</p>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AlertDialogDescription.new(aria_id: "alert-dialog-123", class: "description-class")
    output = render(component)

    assert_includes(output, "description-class")
    assert_includes(output, "text-sm text-muted-foreground")
  end
end

class TestAlertDialogFooter < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AlertDialogFooter.new { "Footer content" }
    output = render(component)

    assert_includes(output, "flex flex-col-reverse gap-2 sm:flex-row sm:justify-end")
    assert_includes(output, "Footer content")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AlertDialogFooter.new(class: "footer-class", id: "footer-id")
    output = render(component)

    assert_includes(output, "footer-class")
    assert_includes(output, 'id="footer-id"')
  end
end

class TestAlertDialogCancel < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AlertDialogCancel.new { "Cancel" }
    output = render(component)

    assert_includes(output, 'data-action="click->alert-dialog#close"')
    assert_includes(output, "Cancel")
    # Should render as a Button with outline variant by default
    assert_includes(output, "<button")
  end

  def test_it_should_render_with_custom_variant_and_size
    component = ShadcnPhlexcomponents::AlertDialogCancel.new(variant: :destructive, size: :sm) { "Cancel" }
    output = render(component)

    assert_includes(output, "Cancel")
    assert_includes(output, 'data-action="click->alert-dialog#close"')
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AlertDialogCancel.new(class: "cancel-class", id: "cancel-id")
    output = render(component)

    assert_includes(output, "cancel-class")
    assert_includes(output, 'id="cancel-id"')
  end
end

class TestAlertDialogAction < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AlertDialogAction.new { "Continue" }
    output = render(component)

    assert_includes(output, 'data-action="click->alert-dialog#close"')
    assert_includes(output, "Continue")
    assert_includes(output, "<button")
  end

  def test_it_should_render_with_custom_variant_and_size
    component = ShadcnPhlexcomponents::AlertDialogAction.new(variant: :destructive, size: :lg) { "Delete" }
    output = render(component)

    assert_includes(output, "Delete")
    assert_includes(output, 'data-action="click->alert-dialog#close"')
  end

  def test_it_should_render_with_as_child
    component = ShadcnPhlexcomponents::AlertDialogAction.new(as_child: true) do
      "<a href='/delete' class='custom-link'>Delete Link</a>".html_safe
    end
    output = render(component)

    # Should merge the action attributes with the anchor element
    assert_includes(output, 'data-action="click->alert-dialog#close"')
    assert_includes(output, "Delete Link")
    assert_includes(output, "custom-link")
    assert_includes(output, 'href="/delete"')
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AlertDialogAction.new(class: "action-class", id: "action-id")
    output = render(component)

    assert_includes(output, "action-class")
    assert_includes(output, 'id="action-id"')
  end
end

class TestAlertDialogWithCustomConfiguration < ComponentTest
  def test_alert_dialog_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.alert_dialog = {
      root: {
        base: "custom-root-base",
      },
      content: {
        base: "custom-content-base",
      },
      header: {
        base: "custom-header-base",
      },
      title: {
        base: "custom-title-base",
      },
      description: {
        base: "custom-description-base",
      },
      footer: {
        base: "custom-footer-base",
      },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload the AlertDialog classes to pick up the new configuration
    [
      "AlertDialogFooter",
      "AlertDialogDescription",
      "AlertDialogTitle",
      "AlertDialogHeader",
      "AlertDialogContent",
      "AlertDialog",
    ].each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/alert_dialog.rb", __dir__))

    # Test AlertDialog with custom configuration
    root_component = ShadcnPhlexcomponents::AlertDialog.new
    root_output = render(root_component) { "Root" }
    assert_includes(root_output, "custom-root-base")

    # Test AlertDialogContent with custom configuration
    content_component = ShadcnPhlexcomponents::AlertDialogContent.new(aria_id: "test")
    content_output = render(content_component) { "Content" }
    assert_includes(content_output, "custom-content-base")

    # Test AlertDialogHeader with custom configuration
    header_component = ShadcnPhlexcomponents::AlertDialogHeader.new
    header_output = render(header_component) { "Header" }
    assert_includes(header_output, "custom-header-base")

    # Test AlertDialogTitle with custom configuration
    title_component = ShadcnPhlexcomponents::AlertDialogTitle.new(aria_id: "test")
    title_output = render(title_component) { "Title" }
    assert_includes(title_output, "custom-title-base")

    # Test AlertDialogDescription with custom configuration
    description_component = ShadcnPhlexcomponents::AlertDialogDescription.new(aria_id: "test")
    description_output = render(description_component) { "Description" }
    assert_includes(description_output, "custom-description-base")

    # Test AlertDialogFooter with custom configuration
    footer_component = ShadcnPhlexcomponents::AlertDialogFooter.new
    footer_output = render(footer_component) { "Footer" }
    assert_includes(footer_output, "custom-footer-base")
  ensure
    # Restore and reload classes
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    [
      "AlertDialogActionTo",
      "AlertDialogAction",
      "AlertDialogCancel",
      "AlertDialogFooter",
      "AlertDialogDescription",
      "AlertDialogTitle",
      "AlertDialogHeader",
      "AlertDialogContent",
      "AlertDialogTrigger",
      "AlertDialog",
    ].each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/alert_dialog.rb", __dir__))
  end
end

class TestAlertDialogIntegration < ComponentTest
  def test_complete_alert_dialog_structure
    component = ShadcnPhlexcomponents::AlertDialog.new(open: true) do |dialog|
      dialog.trigger { "Delete Account" }
      dialog.content do
        dialog.header do
          dialog.title { "Are you absolutely sure?" }
          dialog.description { "This action cannot be undone. This will permanently delete your account." }
        end
        dialog.footer do
          dialog.cancel { "Cancel" }
          dialog.action(variant: :destructive) { "Delete Account" }
        end
      end
    end

    output = render(component)

    # Check alert dialog container
    assert_includes(output, 'data-controller="alert-dialog"')
    assert_includes(output, 'data-alert-dialog-is-open-value="true"')

    # Check trigger
    assert_includes(output, "Delete Account")
    assert_includes(output, 'data-alert-dialog-target="trigger"')

    # Check content structure
    assert_includes(output, 'role="alertdialog"')
    assert_includes(output, 'data-alert-dialog-target="content"')

    # Check header content
    assert_includes(output, "Are you absolutely sure?")
    assert_includes(output, "This action cannot be undone")

    # Check footer actions
    assert_includes(output, "Cancel")
    assert_includes(output, 'data-action="click->alert-dialog#close"')

    # Check structural classes
    assert_includes(output, "inline-flex max-w-fit")
    assert_includes(output, "bg-background data-[state=open]:animate-in")
    assert_includes(output, "flex flex-col gap-2 text-center sm:text-left")
    assert_includes(output, "text-lg font-semibold")
    assert_includes(output, "text-sm text-muted-foreground")
    assert_includes(output, "flex flex-col-reverse gap-2 sm:flex-row sm:justify-end")
  end
end
