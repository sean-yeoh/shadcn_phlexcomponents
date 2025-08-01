# frozen_string_literal: true

require "test_helper"

class TestToastContainer < ComponentTest
  def test_it_should_render_basic_toast_container
    component = ShadcnPhlexcomponents::ToastContainer.new { "" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="toast-container"')
    assert_includes(output, 'data-controller="toast-container"')
    assert_includes(output, 'role="region"')
    assert_includes(output, 'aria-label="Notifications"')
    assert_includes(output, 'tabindex="-1"')
    assert_match(%r{<div[^>]*role="region"[^>]*>.*<ol[^>]*>.*</ol>.*</div>}m, output)
  end

  def test_it_should_render_with_default_side
    component = ShadcnPhlexcomponents::ToastContainer.new { "" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="toast-container"')
    assert_includes(output, "fixed z-50 hidden has-[li]:flex flex-col gap-2")
    assert_includes(output, "top-6 left-1/2 -translate-x-1/2")
  end

  def test_it_should_render_with_custom_side
    sides = [
      { side: :top_left, class: "top-6 left-6" },
      { side: :top_right, class: "top-6 right-6" },
      { side: :bottom_center, class: "bottom-6 left-1/2 -translate-x-1/2" },
      { side: :bottom_left, class: "bottom-6 left-6" },
      { side: :bottom_right, class: "right-6 bottom-6" },
    ]

    sides.each do |config|
      component = ShadcnPhlexcomponents::ToastContainer.new(side: config[:side]) { "" }
      output = render(component)

      assert_includes(output, config[:class])
      assert_includes(output, "fixed z-50 hidden has-[li]:flex flex-col gap-2")
    end
  end

  def test_it_should_render_with_custom_attributes
    component = ShadcnPhlexcomponents::ToastContainer.new(
      side: :top_right,
      class: "custom-toast-container max-w-md",
      id: "notification-area",
      data: { testid: "toast-notifications" },
    ) { "" }
    output = render(component)

    assert_includes(output, "custom-toast-container max-w-md")
    assert_includes(output, 'id="notification-area"')
    assert_includes(output, 'data-testid="toast-notifications"')
    assert_includes(output, "top-6 right-6")
  end

  def test_it_should_include_default_templates
    component = ShadcnPhlexcomponents::ToastContainer.new { "" }
    output = render(component)

    # Check for default variant template
    assert_includes(output, 'data-variant="default"')
    # Check for destructive variant template
    assert_includes(output, 'data-variant="destructive"')
    # Should include template tags
    assert_includes(output, "<template")
  end

  def test_it_should_include_stimulus_controller
    component = ShadcnPhlexcomponents::ToastContainer.new(
      data: {
        controller: "toast-container notification-manager",
        notification_manager_target: "container",
      },
    ) { "" }
    output = render(component)

    # Should merge controllers
    assert_match(/data-controller="[^"]*toast-container[^"]*notification-manager[^"]*"/, output)
    assert_includes(output, 'data-notification-manager-target="container"')
  end

  def test_it_should_handle_aria_attributes
    component = ShadcnPhlexcomponents::ToastContainer.new(
      aria: {
        label: "System notifications",
        live: "polite",
        atomic: "true",
      },
    ) { "" }
    output = render(component)

    # Should override default aria-label
    assert_includes(output, 'aria-label="System notifications"')
    assert_includes(output, 'aria-live="polite"')
    assert_includes(output, 'aria-atomic="true"')
  end

  def test_it_should_render_with_content
    component = ShadcnPhlexcomponents::ToastContainer.new do
      "Custom toast container content"
    end
    output = render(component)

    assert_includes(output, "Custom toast container content")
    assert_includes(output, 'role="region"')
    assert_includes(output, 'aria-label="Notifications"')
  end

  def test_it_should_have_correct_structure
    component = ShadcnPhlexcomponents::ToastContainer.new { "" }
    output = render(component)

    # Should have outer div with region role
    assert_match(/<div[^>]*role="region"[^>]*tabindex="-1"[^>]*aria-label="Notifications"[^>]*>/, output)
    # Should have inner ol with toast-container attributes
    assert_includes(output, 'data-shadcn-phlexcomponents="toast-container"')
    assert_includes(output, 'data-controller="toast-container"')
    # Should include both templates inside ol (templates contain actual toast content)
    assert_includes(output, 'data-variant="default"')
    assert_includes(output, 'data-variant="destructive"')
    assert_match(%r{<template[^>]*>.*</template>}m, output)
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::ToastContainer.new(side: :bottom_right) { "" }
    output = render(component)

    assert_includes(output, "fixed")
    assert_includes(output, "z-50")
    assert_includes(output, "hidden")
    assert_includes(output, "has-[li]:flex")
    assert_includes(output, "flex-col")
    assert_includes(output, "gap-2")
    assert_includes(output, "right-6 bottom-6")
  end

  def test_toast_helper_method
    component = ShadcnPhlexcomponents::ToastContainer.new { "Custom content" }

    # Test that the private toast method generates proper toast structure
    # We can't directly test the private method, but we can verify the templates exist
    output = render(component)

    # The toast helper method should generate templates with Toast components
    assert_includes(output, 'data-variant="default"')
    assert_includes(output, 'data-variant="destructive"')

    # Templates should contain toast components (though the exact structure depends on Toast component)
    assert_match(%r{<template[^>]*data-variant="default"[^>]*>.*</template>}m, output)
    assert_match(%r{<template[^>]*data-variant="destructive"[^>]*>.*</template>}m, output)

    # Should also include custom content
    assert_includes(output, "Custom content")
  end
end

class TestToastContainerWithCustomConfiguration < ComponentTest
  def test_toast_container_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.toast_container = {
      base: "custom-container-base fixed z-40 p-4",
      variants: {
        side: {
          top_center: "custom-top-center top-4 left-1/2 transform -translate-x-1/2",
          bottom_right: "custom-bottom-right bottom-4 right-4",
        },
      },
      defaults: {
        side: :bottom_right,
      },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload class
    ShadcnPhlexcomponents.send(:remove_const, :ToastContainer) if ShadcnPhlexcomponents.const_defined?(:ToastContainer)
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/toast_container.rb", __dir__))

    # Test component with custom configuration
    container = ShadcnPhlexcomponents::ToastContainer.new { "" }
    container_output = render(container)
    assert_includes(container_output, "custom-container-base")
    assert_includes(container_output, "fixed")
    assert_includes(container_output, "z-40")
    assert_includes(container_output, "p-4")
    # Default side is top_center, but custom config defaults to bottom_right
    assert_includes(container_output, "custom-top-center")
    assert_includes(container_output, "top-4")
    assert_includes(container_output, "left-1/2")
    assert_includes(container_output, "transform")
    assert_includes(container_output, "-translate-x-1/2")

    # Test with different side
    top_container = ShadcnPhlexcomponents::ToastContainer.new(side: :top_center) { "" }
    top_output = render(top_container)
    assert_includes(top_output, "custom-top-center")
    assert_includes(top_output, "top-4 left-1/2 transform -translate-x-1/2")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    ShadcnPhlexcomponents.send(:remove_const, :ToastContainer) if ShadcnPhlexcomponents.const_defined?(:ToastContainer)
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/toast_container.rb", __dir__))
  end
end

class TestToastContainerIntegration < ComponentTest
  def test_notification_system_integration
    component = ShadcnPhlexcomponents::ToastContainer.new(
      side: :top_right,
      class: "notification-system max-w-sm",
      aria: {
        label: "Application notifications",
        live: "assertive",
      },
      data: {
        controller: "toast-container notification-manager analytics",
        notification_manager_target: "toastContainer",
        notification_manager_max_toasts: "5",
        analytics_category: "notifications",
      },
    ) { "Loading notifications..." }
    output = render(component)

    # Check notification system structure
    assert_includes(output, "notification-system max-w-sm")
    assert_includes(output, "top-6 right-6")
    assert_includes(output, 'aria-label="Application notifications"')
    assert_includes(output, 'aria-live="assertive"')

    # Check multiple controllers
    assert_match(/data-controller="[^"]*toast-container[^"]*notification-manager[^"]*analytics[^"]*"/, output)
    assert_includes(output, 'data-notification-manager-target="toastContainer"')
    assert_includes(output, 'data-notification-manager-max-toasts="5"')
    assert_includes(output, 'data-analytics-category="notifications"')

    # Check content
    assert_includes(output, "Loading notifications...")
  end

  def test_error_notification_container
    component = ShadcnPhlexcomponents::ToastContainer.new(
      side: :bottom_center,
      class: "error-notifications",
      data: {
        controller: "toast-container error-handler",
        error_handler_target: "errorContainer",
        error_handler_auto_dismiss: "false",
      },
    ) { "" }
    output = render(component)

    # Check error notification setup
    assert_includes(output, "error-notifications")
    assert_includes(output, "bottom-6 left-1/2 -translate-x-1/2")

    # Check error handling integration
    assert_match(/data-controller="[^"]*toast-container[^"]*error-handler[^"]*"/, output)
    assert_includes(output, 'data-error-handler-target="errorContainer"')
    assert_includes(output, 'data-error-handler-auto-dismiss="false"')

    # Should still have templates
    assert_includes(output, 'data-variant="default"')
    assert_includes(output, 'data-variant="destructive"')
  end

  def test_mobile_responsive_container
    component = ShadcnPhlexcomponents::ToastContainer.new(
      side: :top_center,
      class: "mobile-notifications w-full max-w-xs sm:max-w-md px-4 sm:px-0",
      data: {
        controller: "toast-container responsive-notifications",
        responsive_notifications_mobile_side: "top_center",
        responsive_notifications_desktop_side: "top_right",
      },
    ) { "" }
    output = render(component)

    # Check responsive structure
    assert_includes(output, "mobile-notifications")
    assert_includes(output, "w-full max-w-xs sm:max-w-md px-4 sm:px-0")
    assert_includes(output, "top-6 left-1/2 -translate-x-1/2")

    # Check responsive controller
    assert_match(/data-controller="[^"]*toast-container[^"]*responsive-notifications[^"]*"/, output)
    assert_includes(output, 'data-responsive-notifications-mobile-side="top_center"')
    assert_includes(output, 'data-responsive-notifications-desktop-side="top_right"')
  end

  def test_toast_container_with_custom_templates
    component = ShadcnPhlexcomponents::ToastContainer.new(
      class: "custom-template-container",
    ) do
      # Custom toast items would go here in real usage
      "<li class=\"custom-toast-item\">Custom notification</li>"
    end
    output = render(component)

    # Check custom content
    assert_includes(output, "custom-template-container")
    assert_includes(output, "custom-toast-item")
    assert_includes(output, "Custom notification")

    # Should still have default templates
    assert_includes(output, 'data-variant="default"')
    assert_includes(output, 'data-variant="destructive"')
  end

  def test_accessibility_enhanced_container
    component = ShadcnPhlexcomponents::ToastContainer.new(
      side: :bottom_left,
      class: "a11y-notifications",
      tabindex: "0",
      aria: {
        label: "System notifications and alerts",
        live: "polite",
        atomic: "false",
        relevant: "additions removals",
      },
      data: {
        controller: "toast-container accessibility-announcer",
        accessibility_announcer_target: "notificationRegion",
        accessibility_announcer_announce_new: "true",
      },
    ) { "" }
    output = render(component)

    # Check accessibility enhancements
    assert_includes(output, "a11y-notifications")
    assert_includes(output, "bottom-6 left-6")
    assert_includes(output, 'tabindex="0"')
    assert_includes(output, 'aria-label="System notifications and alerts"')
    assert_includes(output, 'aria-live="polite"')
    assert_includes(output, 'aria-atomic="false"')
    assert_includes(output, 'aria-relevant="additions removals"')

    # Check accessibility controller
    assert_match(/data-controller="[^"]*toast-container[^"]*accessibility-announcer[^"]*"/, output)
    assert_includes(output, 'data-accessibility-announcer-target="notificationRegion"')
    assert_includes(output, 'data-accessibility-announcer-announce-new="true"')
  end

  def test_toast_container_with_positioning
    component = ShadcnPhlexcomponents::ToastContainer.new(
      side: :top_left,
      class: "positioned-notifications",
      style: "z-index: 9999; pointer-events: none;",
      data: {
        controller: "toast-container position-manager",
        position_manager_target: "container",
        position_manager_offset_x: "20",
        position_manager_offset_y: "20",
      },
    ) { "" }
    output = render(component)

    # Check positioning
    assert_includes(output, "positioned-notifications")
    assert_includes(output, "top-6 left-6")
    assert_includes(output, 'style="z-index: 9999; pointer-events: none;"')

    # Check position manager
    assert_match(/data-controller="[^"]*toast-container[^"]*position-manager[^"]*"/, output)
    assert_includes(output, 'data-position-manager-target="container"')
    assert_includes(output, 'data-position-manager-offset-x="20"')
    assert_includes(output, 'data-position-manager-offset-y="20"')
  end

  def test_toast_container_with_animation_settings
    component = ShadcnPhlexcomponents::ToastContainer.new(
      side: :bottom_right,
      class: "animated-notifications",
      data: {
        controller: "toast-container animation-manager",
        animation_manager_duration: "300",
        animation_manager_easing: "ease-out",
        animation_manager_stagger: "100",
      },
    ) { "" }
    output = render(component)

    # Check animation setup
    assert_includes(output, "animated-notifications")
    assert_includes(output, "right-6 bottom-6")

    # Check animation controller
    assert_match(/data-controller="[^"]*toast-container[^"]*animation-manager[^"]*"/, output)
    assert_includes(output, 'data-animation-manager-duration="300"')
    assert_includes(output, 'data-animation-manager-easing="ease-out"')
    assert_includes(output, 'data-animation-manager-stagger="100"')
  end

  def test_toast_container_with_theming
    component = ShadcnPhlexcomponents::ToastContainer.new(
      class: "themed-notifications",
      data: {
        controller: "toast-container theme-aware",
        theme_aware_target: "container",
        theme_aware_light_position: "top_right",
        theme_aware_dark_position: "bottom_right",
      },
    ) { "" }
    output = render(component)

    # Check theming setup
    assert_includes(output, "themed-notifications")

    # Check theme controller
    assert_match(/data-controller="[^"]*toast-container[^"]*theme-aware[^"]*"/, output)
    assert_includes(output, 'data-theme-aware-target="container"')
    assert_includes(output, 'data-theme-aware-light-position="top_right"')
    assert_includes(output, 'data-theme-aware-dark-position="bottom_right"')
  end
end
