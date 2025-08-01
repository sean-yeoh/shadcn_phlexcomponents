# frozen_string_literal: true

require "test_helper"

class TestToast < ComponentTest
  def test_it_should_render_basic_toast
    component = ShadcnPhlexcomponents::Toast.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="toast"')
    assert_includes(output, 'data-controller="toast"')
    assert_includes(output, 'role="status"')
    assert_includes(output, 'tabindex="0"')
    assert_includes(output, 'aria-live="off"')
    assert_includes(output, 'aria-atomic="true"')
    assert_includes(output, 'data-duration="5000"')
    assert_includes(output, 'data-state="open"')
    assert_match(%r{<li[^>]*>.*</li>}m, output)
  end

  def test_it_should_render_with_default_variant
    component = ShadcnPhlexcomponents::Toast.new
    output = render(component)

    assert_includes(output, "bg-popover text-popover-foreground")
    assert_includes(output, "p-4 border shadow-lg text-[0.8rem]")
    assert_includes(output, "flex gap-1.5 items-center w-full sm:w-90 rounded-lg")
    assert_includes(output, "duration-200")
  end

  def test_it_should_render_with_destructive_variant
    component = ShadcnPhlexcomponents::Toast.new(variant: :destructive)
    output = render(component)

    assert_includes(output, "bg-card text-destructive")
    assert_includes(output, "[&>svg]:text-current")
    assert_includes(output, "*:data-[shadcn-phlexcomponents=toast-description]:text-destructive/90")
  end

  def test_it_should_render_with_side_variants
    # Test top side
    top_component = ShadcnPhlexcomponents::Toast.new(side: :top)
    top_output = render(top_component)
    assert_includes(top_output, "data-[state=closed]:slide-out-to-top")
    assert_includes(top_output, "data-[state=open]:slide-in-from-top")

    # Test bottom side
    bottom_component = ShadcnPhlexcomponents::Toast.new(side: :bottom)
    bottom_output = render(bottom_component)
    assert_includes(bottom_output, "data-[state=closed]:slide-out-to-bottom")
    assert_includes(bottom_output, "data-[state=open]:slide-in-from-bottom")
  end

  def test_it_should_render_with_custom_duration
    component = ShadcnPhlexcomponents::Toast.new(duration: 3000)
    output = render(component)

    assert_includes(output, 'data-duration="3000"')
  end

  def test_it_should_render_with_custom_attributes
    component = ShadcnPhlexcomponents::Toast.new(
      variant: :destructive,
      side: :bottom,
      duration: 7000,
      class: "custom-toast border-red-500",
      id: "error-toast",
      data: { testid: "notification-toast" },
    )
    output = render(component)

    assert_includes(output, "custom-toast border-red-500")
    assert_includes(output, 'id="error-toast"')
    assert_includes(output, 'data-testid="notification-toast"')
    assert_includes(output, 'data-duration="7000"')
    assert_includes(output, "bg-card text-destructive")
    assert_includes(output, "data-[state=closed]:slide-out-to-bottom")
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::Toast.new
    output = render(component)

    assert_includes(output, "focus->toast#cancelClose")
    assert_includes(output, "blur->toast#close")
    assert_includes(output, "mouseover->toast#cancelClose")
    assert_includes(output, "mouseout->toast#close")
  end

  def test_it_should_handle_custom_stimulus_actions
    component = ShadcnPhlexcomponents::Toast.new(
      data: {
        controller: "toast notification-tracker",
        notification_tracker_target: "toast",
        action: "toast#close click->notification-tracker#markAsRead",
      },
    )
    output = render(component)

    # Should merge controllers
    assert_match(/data-controller="[^"]*toast[^"]*notification-tracker[^"]*"/, output)
    assert_includes(output, 'data-notification-tracker-target="toast"')
    # Should include both default and custom actions
    assert_includes(output, "toast#close")
    assert_includes(output, "notification-tracker#markAsRead")
  end

  def test_it_should_render_with_helper_methods
    component = ShadcnPhlexcomponents::Toast.new do |toast|
      toast.content do
        toast.title { "Success!" }
        toast.description { "Your changes have been saved." }
      end
      toast.action { "Undo" }
    end
    output = render(component)

    # Check that helper methods generate proper content
    assert_includes(output, "Success!")
    assert_includes(output, "Your changes have been saved.")
    assert_includes(output, "Undo")

    # Should have proper component identifiers for sub-components
    assert_includes(output, 'data-shadcn-phlexcomponents="toast-content"')
    assert_includes(output, 'data-shadcn-phlexcomponents="toast-title"')
    assert_includes(output, 'data-shadcn-phlexcomponents="toast-description"')
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::Toast.new
    output = render(component)

    # Base styling
    assert_includes(output, "p-4 border shadow-lg")
    assert_includes(output, "text-[0.8rem]")
    assert_includes(output, "flex gap-1.5 items-center")
    assert_includes(output, "w-full sm:w-90 rounded-lg")
    assert_includes(output, "duration-200")

    # Animation classes
    assert_includes(output, "data-[state=open]:animate-in")
    assert_includes(output, "data-[state=closed]:animate-out")

    # SVG styling
    assert_includes(output, "[&_svg]:size-4")
    assert_includes(output, "[&_svg]:mr-1")
    assert_includes(output, "[&_svg]:self-start")
    assert_includes(output, "[&_svg]:translate-y-0.5")
  end

  def test_it_should_handle_content_with_block
    component = ShadcnPhlexcomponents::Toast.new { "Simple toast message" }
    output = render(component)

    assert_includes(output, "Simple toast message")
    assert_includes(output, 'role="status"')
  end
end

class TestToastSubComponents < ComponentTest
  def test_toast_content_should_render
    component = ShadcnPhlexcomponents::ToastContent.new { "Content area" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="toast-content"')
    assert_includes(output, "flex flex-col gap-0.5")
    assert_includes(output, "Content area")
    assert_match(%r{<div[^>]*>.*Content area.*</div>}m, output)
  end

  def test_toast_title_should_render
    component = ShadcnPhlexcomponents::ToastTitle.new { "Toast Title" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="toast-title"')
    assert_includes(output, "font-medium leading-[1.5]")
    assert_includes(output, "Toast Title")
    assert_match(%r{<div[^>]*>.*Toast Title.*</div>}m, output)
  end

  def test_toast_description_should_render
    component = ShadcnPhlexcomponents::ToastDescription.new { "Toast description text" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="toast-description"')
    assert_includes(output, "leading-[1.4] opacity-90")
    assert_includes(output, "Toast description text")
    assert_match(%r{<div[^>]*>.*Toast description text.*</div>}m, output)
  end

  def test_toast_action_should_render
    component = ShadcnPhlexcomponents::ToastAction.new { "Action Button" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="toast-action"')
    assert_includes(output, "Action Button")
    # Should render as button by default
    assert_match(%r{<button[^>]*>.*Action Button.*</button>}m, output)
    # Should include button styling
    assert_includes(output, "text-xs h-6 py-0 px-2 rounded-sm ml-auto")
  end

  def test_toast_action_basic_button
    component = ShadcnPhlexcomponents::ToastAction.new { "Action Button" }
    output = render(component)

    # Should render as regular button
    assert_includes(output, "Action Button")
    assert_match(%r{<button[^>]*>.*Action Button.*</button>}m, output)
  end

  def test_toast_action_to_should_render
    component = ShadcnPhlexcomponents::ToastActionTo.new("Undo", "/undo")
    output = render(component)

    # Should render as button_to form with input submit
    assert_includes(output, 'action="/undo"')
    assert_includes(output, 'value="Undo"')
    assert_includes(output, "inline-flex ml-auto")
    assert_match(%r{<form[^>]*>.*<input[^>]*type="submit"[^>]*>.*</form>}m, output)
  end

  def test_toast_action_to_with_block
    component = ShadcnPhlexcomponents::ToastActionTo.new("/undo") { "Custom Undo" }
    output = render(component)

    assert_includes(output, 'action="/undo"')
    assert_includes(output, "Custom Undo")
    assert_includes(output, "inline-flex ml-auto")
  end

  def test_sub_components_with_custom_attributes
    components = [
      {
        component: ShadcnPhlexcomponents::ToastContent.new(
          class: "custom-content",
          id: "toast-content",
        ) { "Content" },
        expected_class: "custom-content",
        expected_id: "toast-content",
      },
      {
        component: ShadcnPhlexcomponents::ToastTitle.new(
          class: "custom-title",
          id: "toast-title",
        ) { "Title" },
        expected_class: "custom-title",
        expected_id: "toast-title",
      },
      {
        component: ShadcnPhlexcomponents::ToastDescription.new(
          class: "custom-description",
          id: "toast-description",
        ) { "Description" },
        expected_class: "custom-description",
        expected_id: "toast-description",
      },
    ]

    components.each do |config|
      output = render(config[:component])
      assert_includes(output, config[:expected_class])
      assert_includes(output, "id=\"#{config[:expected_id]}\"")
    end
  end
end

class TestToastWithCustomConfiguration < ComponentTest
  def test_toast_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.toast = {
      root: {
        base: "custom-toast-base p-6 rounded-xl shadow-2xl",
        variants: {
          variant: {
            default: "custom-default bg-white text-black",
            destructive: "custom-destructive bg-red-600 text-white",
          },
        },
      },
      content: { base: "custom-content-base gap-2" },
      title: { base: "custom-title-base text-lg font-bold" },
      description: { base: "custom-description-base text-sm opacity-75" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    toast_classes = ["ToastAction", "ToastActionTo", "ToastDescription", "ToastTitle", "ToastContent", "Toast"]

    toast_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/toast.rb", __dir__))

    # Test components with custom configuration
    toast = ShadcnPhlexcomponents::Toast.new
    toast_output = render(toast)
    assert_includes(toast_output, "custom-toast-base")
    assert_includes(toast_output, "p-6 rounded-xl shadow-2xl")
    assert_includes(toast_output, "custom-default bg-white text-black")

    destructive_toast = ShadcnPhlexcomponents::Toast.new(variant: :destructive)
    destructive_output = render(destructive_toast)
    assert_includes(destructive_output, "custom-destructive bg-red-600 text-white")

    content = ShadcnPhlexcomponents::ToastContent.new { "Test" }
    content_output = render(content)
    assert_includes(content_output, "custom-content-base gap-2")

    title = ShadcnPhlexcomponents::ToastTitle.new { "Test" }
    title_output = render(title)
    assert_includes(title_output, "custom-title-base text-lg font-bold")

    description = ShadcnPhlexcomponents::ToastDescription.new { "Test" }
    description_output = render(description)
    assert_includes(description_output, "custom-description-base text-sm opacity-75")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    toast_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/toast.rb", __dir__))
  end
end

class TestToastIntegration < ComponentTest
  def test_success_notification_toast
    component = ShadcnPhlexcomponents::Toast.new(
      variant: :default,
      duration: 4000,
      class: "success-toast border-green-500",
      data: {
        controller: "toast notification-tracker analytics",
        notification_tracker_target: "successToast",
        analytics_category: "notifications",
        analytics_label: "success",
      },
    ) do |toast|
      toast.content do
        toast.title { "✅ Success!" }
        toast.description { "Your profile has been updated successfully." }
      end
      toast.action { "View Profile" }
    end
    output = render(component)

    # Check success toast structure
    assert_includes(output, "success-toast border-green-500")
    assert_includes(output, 'data-duration="4000"')
    assert_includes(output, "bg-popover text-popover-foreground")

    # Check multiple controllers
    assert_match(/data-controller="[^"]*toast[^"]*notification-tracker[^"]*analytics[^"]*"/, output)
    assert_includes(output, 'data-notification-tracker-target="successToast"')
    assert_includes(output, 'data-analytics-category="notifications"')
    assert_includes(output, 'data-analytics-label="success"')

    # Check content
    assert_includes(output, "✅ Success!")
    assert_includes(output, "Your profile has been updated successfully.")
    assert_includes(output, "View Profile")

    # Check accessibility
    assert_includes(output, 'role="status"')
    assert_includes(output, 'aria-live="off"')
  end

  def test_error_notification_toast
    component = ShadcnPhlexcomponents::Toast.new(
      variant: :destructive,
      side: :bottom,
      duration: 8000,
      class: "error-toast",
      data: {
        controller: "toast error-handler",
        error_handler_target: "errorToast",
        error_handler_retry_available: "true",
      },
    ) do |toast|
      toast.content do
        toast.title { "❌ Error" }
        toast.description { "Failed to save your changes. Please try again." }
      end
      toast.action { "Retry" }
    end
    output = render(component)

    # Check error toast structure
    assert_includes(output, "error-toast")
    assert_includes(output, 'data-duration="8000"')
    assert_includes(output, "bg-card text-destructive")
    assert_includes(output, "data-[state=closed]:slide-out-to-bottom")

    # Check error handling
    assert_match(/data-controller="[^"]*toast[^"]*error-handler[^"]*"/, output)
    assert_includes(output, 'data-error-handler-target="errorToast"')
    assert_includes(output, 'data-error-handler-retry-available="true"')

    # Check content
    assert_includes(output, "❌ Error")
    assert_includes(output, "Failed to save your changes. Please try again.")
    assert_includes(output, "Retry")
  end

  def test_info_toast_with_link_action
    component = ShadcnPhlexcomponents::Toast.new(
      duration: 6000,
      class: "info-toast",
      data: {
        controller: "toast link-tracker",
        link_tracker_target: "infoToast",
      },
    ) do |toast|
      toast.content do
        toast.title { "ℹ️ New Feature Available" }
        toast.description { "Check out our new dashboard analytics feature." }
      end
      toast.action_to("Learn More", "/features/analytics", class: "info-action")
    end
    output = render(component)

    # Check info toast structure
    assert_includes(output, "info-toast")
    assert_includes(output, 'data-duration="6000"')

    # Check link tracking
    assert_match(/data-controller="[^"]*toast[^"]*link-tracker[^"]*"/, output)
    assert_includes(output, 'data-link-tracker-target="infoToast"')

    # Check content
    assert_includes(output, "ℹ️ New Feature Available")
    assert_includes(output, "Check out our new dashboard analytics feature.")

    # Check action_to button
    assert_includes(output, 'action="/features/analytics"')
    assert_includes(output, 'value="Learn More"')
    assert_includes(output, "info-action")
    assert_includes(output, "inline-flex ml-auto")
  end

  def test_progress_toast_with_updates
    component = ShadcnPhlexcomponents::Toast.new(
      duration: 0, # Persistent until dismissed
      class: "progress-toast",
      data: {
        controller: "toast progress-tracker",
        progress_tracker_target: "progressToast",
        progress_tracker_current: "25",
        progress_tracker_total: "100",
      },
    ) do |toast|
      toast.content(class: "progress-content") do
        toast.title { "📤 Uploading Files..." }
        toast.description { "25 of 100 files uploaded" }
      end
      toast.action { "Cancel" }
    end
    output = render(component)

    # Check progress toast structure
    assert_includes(output, "progress-toast")
    assert_includes(output, 'data-duration="0"')

    # Check progress tracking
    assert_match(/data-controller="[^"]*toast[^"]*progress-tracker[^"]*"/, output)
    assert_includes(output, 'data-progress-tracker-target="progressToast"')
    assert_includes(output, 'data-progress-tracker-current="25"')
    assert_includes(output, 'data-progress-tracker-total="100"')

    # Check content with custom class
    assert_includes(output, "progress-content")
    assert_includes(output, "📤 Uploading Files...")
    assert_includes(output, "25 of 100 files uploaded")
    assert_includes(output, "Cancel")
  end

  def test_toast_with_custom_action_element
    component = ShadcnPhlexcomponents::Toast.new(
      class: "custom-action-toast",
    ) do |toast|
      toast.content do
        toast.title { "Confirmation Required" }
        toast.description { "This action cannot be undone." }
      end

      toast.action do
        "Confirm"
      end
    end
    output = render(component)

    # Check custom action structure
    assert_includes(output, "custom-action-toast")
    assert_includes(output, "Confirmation Required")
    assert_includes(output, "This action cannot be undone.")

    # Check regular action
    assert_includes(output, "Confirm")
    assert_match(%r{<button[^>]*>.*Confirm.*</button>}m, output)
  end

  def test_toast_accessibility_features
    component = ShadcnPhlexcomponents::Toast.new(
      duration: 10000,
      class: "accessible-toast",
      role: "alert", # Override default status
      aria: {
        live: "assertive",
        atomic: "true",
        describedby: "toast-description",
      },
      data: {
        controller: "toast accessibility-enhancer",
        accessibility_enhancer_target: "accessibleToast",
        accessibility_enhancer_announce: "true",
      },
    ) do |toast|
      toast.content do
        toast.title { "System Alert" }
        toast.description(id: "toast-description") { "Your session will expire in 5 minutes." }
      end
      toast.action { "Extend Session" }
    end
    output = render(component)

    # Check accessibility enhancements
    assert_includes(output, "accessible-toast")
    # Role should be combined (status alert)
    assert_match(/role="[^"]*alert[^"]*"/, output)
    assert_match(/aria-live="[^"]*assertive[^"]*"/, output)
    assert_match(/aria-atomic="[^"]*true[^"]*"/, output)
    assert_includes(output, 'aria-describedby="toast-description"')

    # Check accessibility controller
    assert_match(/data-controller="[^"]*toast[^"]*accessibility-enhancer[^"]*"/, output)
    assert_includes(output, 'data-accessibility-enhancer-target="accessibleToast"')
    assert_includes(output, 'data-accessibility-enhancer-announce="true"')

    # Check content with ID
    assert_includes(output, 'id="toast-description"')
    assert_includes(output, "Your session will expire in 5 minutes.")
  end

  def test_toast_with_icon_and_styling
    component = ShadcnPhlexcomponents::Toast.new(
      variant: :default,
      class: "icon-toast flex items-start gap-3",
    ) do |toast|
      # Icon would typically be added as content
      toast.content(class: "icon-content flex items-start gap-2") do
        toast.title(class: "flex items-center gap-2") { "🔔 Notification" }
        toast.description { "You have a new message from John Doe." }
      end
      toast.action(class: "action-btn") { "Reply" }
    end
    output = render(component)

    # Check icon toast structure
    assert_includes(output, "icon-toast flex items-start gap-3")
    assert_includes(output, "icon-content flex items-start gap-2")
    assert_includes(output, "flex items-center gap-2")
    assert_includes(output, "action-btn")

    # Check content
    assert_includes(output, "🔔 Notification")
    assert_includes(output, "You have a new message from John Doe.")
    assert_includes(output, "Reply")

    # Should still have SVG styling classes from base
    assert_includes(output, "[&_svg]:size-4")
  end
end
