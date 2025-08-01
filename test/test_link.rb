# frozen_string_literal: true

require "test_helper"

class TestLink < ComponentTest
  def test_it_should_render_content_and_attributes_with_name_and_path
    component = ShadcnPhlexcomponents::Link.new("Home", "/")
    output = render(component)

    assert_includes(output, "Home")
    assert_includes(output, 'href="/"')
    assert_includes(output, "font-medium underline underline-offset-4")
    assert_match(%r{<a[^>]*>Home</a>}, output)
  end

  def test_it_should_render_with_block_content
    component = ShadcnPhlexcomponents::Link.new("/about") { "About Us" }
    output = render(component)

    assert_includes(output, "About Us")
    assert_includes(output, 'href="/about"')
    assert_includes(output, "font-medium underline underline-offset-4")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Link.new(
      "Contact",
      "/contact",
      {
        class: "custom-link",
        id: "contact-link",
        target: "_blank",
        rel: "noopener",
      },
    )
    output = render(component)

    assert_includes(output, "custom-link")
    assert_includes(output, 'id="contact-link"')
    assert_includes(output, 'target="_blank"')
    assert_includes(output, 'rel="noopener"')
    assert_includes(output, "Contact")
    assert_includes(output, 'href="/contact"')
  end

  def test_it_should_render_with_block_and_custom_attributes
    component = ShadcnPhlexcomponents::Link.new(
      "/services",
      {
        class: "services-link",
        data: { testid: "services" },
      },
    ) { "Our Services" }
    output = render(component)

    assert_includes(output, "services-link")
    assert_includes(output, 'data-testid="services"')
    assert_includes(output, "Our Services")
    assert_includes(output, 'href="/services"')
  end

  def test_it_should_handle_variant_attribute_with_button_styling
    component = ShadcnPhlexcomponents::Link.new(
      "Button Link",
      "/button",
      { variant: :default },
    )
    output = render(component)

    assert_includes(output, "Button Link")
    assert_includes(output, 'href="/button"')
    # Should include button styling classes instead of default link classes
    refute_includes(output, "font-medium underline underline-offset-4")
  end

  def test_it_should_handle_variant_and_size_attributes
    component = ShadcnPhlexcomponents::Link.new(
      "Large Button",
      "/large",
      { variant: :outline, size: :lg },
    )
    output = render(component)

    assert_includes(output, "Large Button")
    assert_includes(output, 'href="/large"')
    # Should not include default link styling when variant is specified
    refute_includes(output, "font-medium underline underline-offset-4")
  end

  def test_it_should_handle_data_attributes
    component = ShadcnPhlexcomponents::Link.new(
      "Analytics Link",
      "/analytics",
      {
        data: {
          controller: "analytics",
          action: "click->analytics#track",
          analytics_event: "link_click",
        },
      },
    )
    output = render(component)

    assert_includes(output, 'data-controller="analytics"')
    assert_includes(output, "analytics#track")
    assert_includes(output, 'data-analytics-event="link_click"')
  end

  def test_it_should_handle_aria_attributes
    component = ShadcnPhlexcomponents::Link.new(
      "Accessible Link",
      "/accessible",
      {
        aria: {
          label: "Navigate to accessible page",
          describedby: "link-help",
        },
      },
    )
    output = render(component)

    assert_includes(output, 'aria-label="Navigate to accessible page"')
    assert_includes(output, 'aria-describedby="link-help"')
  end

  def test_it_should_handle_external_link_attributes
    component = ShadcnPhlexcomponents::Link.new(
      "External Site",
      "https://example.com",
      {
        target: "_blank",
        rel: "noopener noreferrer",
        class: "external-link",
      },
    )
    output = render(component)

    assert_includes(output, "External Site")
    assert_includes(output, 'href="https://example.com"')
    assert_includes(output, 'target="_blank"')
    assert_includes(output, 'rel="noopener noreferrer"')
    assert_includes(output, "external-link")
  end

  def test_it_should_handle_mailto_links
    component = ShadcnPhlexcomponents::Link.new(
      "📧 Email Us",
      "mailto:contact@example.com",
      {
        class: "email-link",
      },
    )
    output = render(component)

    assert_includes(output, "📧 Email Us")
    assert_includes(output, 'href="mailto:contact@example.com"')
    assert_includes(output, "email-link")
    assert_includes(output, "font-medium underline underline-offset-4")
  end

  def test_it_should_handle_tel_links
    component = ShadcnPhlexcomponents::Link.new(
      "📞 Call Us",
      "tel:+1555123456",
    )
    output = render(component)

    assert_includes(output, "📞 Call Us")
    assert_includes(output, 'href="tel:+1555123456"')
  end

  def test_it_should_handle_download_attribute
    component = ShadcnPhlexcomponents::Link.new(
      "📁 Download File",
      "/files/document.pdf",
      { download: "document.pdf" },
    )
    output = render(component)

    assert_includes(output, "📁 Download File")
    assert_includes(output, 'href="/files/document.pdf"')
    assert_includes(output, 'download="document.pdf"')
  end

  def test_it_should_handle_hash_links
    component = ShadcnPhlexcomponents::Link.new(
      "🔗 Jump to Section",
      "#section-2",
    )
    output = render(component)

    assert_includes(output, "🔗 Jump to Section")
    assert_includes(output, 'href="#section-2"')
  end

  def test_it_should_include_default_styling_classes
    component = ShadcnPhlexcomponents::Link.new("Default Link", "/default")
    output = render(component)

    assert_includes(output, "font-medium")
    assert_includes(output, "underline")
    assert_includes(output, "underline-offset-4")
  end

  def test_it_should_merge_custom_classes_with_default
    component = ShadcnPhlexcomponents::Link.new(
      "Custom Styled Link",
      "/custom",
      { class: "text-blue-600 hover:text-blue-800" },
    )
    output = render(component)

    assert_includes(output, "text-blue-600")
    assert_includes(output, "hover:text-blue-800")
    assert_includes(output, "font-medium underline underline-offset-4")
  end

  def test_it_should_handle_title_attribute
    component = ShadcnPhlexcomponents::Link.new(
      "Tooltip Link",
      "/tooltip",
      { title: "This link has a helpful tooltip" },
    )
    output = render(component)

    assert_includes(output, 'title="This link has a helpful tooltip"')
  end
end

class TestLinkWithCustomConfiguration < ComponentTest
  def test_link_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.link = {
      base: "custom-link-base text-lg no-underline hover:underline",
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    link_classes = ["Link"]

    link_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/link.rb", __dir__))

    # Test components with custom configuration
    link = ShadcnPhlexcomponents::Link.new("Test Link", "/test")
    output = render(link)
    assert_includes(output, "custom-link-base")
    assert_includes(output, "text-lg no-underline hover:underline")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    link_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/link.rb", __dir__))
  end
end

class TestLinkIntegration < ComponentTest
  def test_complete_link_workflow
    component = ShadcnPhlexcomponents::Link.new(
      "🚀 Launch Dashboard",
      "/dashboard",
      {
        class: "dashboard-link primary-action",
        id: "dashboard-nav",
        target: "_self",
        aria: {
          label: "Navigate to user dashboard",
          describedby: "dashboard-help",
        },
        data: {
          controller: "navigation analytics",
          navigation_target: "link",
          analytics_category: "navigation",
          analytics_action: "dashboard_click",
          action: "click->navigation#navigate click->analytics#track",
        },
      },
    )

    output = render(component)

    # Check main structure
    assert_includes(output, "dashboard-link primary-action")
    assert_includes(output, 'id="dashboard-nav"')
    assert_includes(output, 'href="/dashboard"')
    assert_includes(output, 'target="_self"')

    # Check content with emoji
    assert_includes(output, "🚀 Launch Dashboard")

    # Check accessibility
    assert_includes(output, 'aria-label="Navigate to user dashboard"')
    assert_includes(output, 'aria-describedby="dashboard-help"')

    # Check stimulus integration
    assert_match(/data-controller="[^"]*navigation[^"]*analytics[^"]*"/, output)
    assert_includes(output, 'data-navigation-target="link"')
    assert_includes(output, 'data-analytics-category="navigation"')
    assert_includes(output, 'data-analytics-action="dashboard_click"')
    assert_includes(output, "navigation#navigate")
    assert_includes(output, "analytics#track")

    # Check default styling
    assert_includes(output, "font-medium underline underline-offset-4")
  end

  def test_link_accessibility_features
    component = ShadcnPhlexcomponents::Link.new(
      "Download Report",
      "/reports/annual-2024.pdf",
      {
        download: "annual-report-2024.pdf",
        aria: {
          label: "Download annual report for 2024 as PDF",
          describedby: "download-help",
        },
        title: "Annual Report 2024 (PDF, 2.5MB)",
      },
    )

    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'aria-label="Download annual report for 2024 as PDF"')
    assert_includes(output, 'aria-describedby="download-help"')
    assert_includes(output, 'title="Annual Report 2024 (PDF, 2.5MB)"')
    assert_includes(output, 'download="annual-report-2024.pdf"')

    # Check content and href
    assert_includes(output, "Download Report")
    assert_includes(output, 'href="/reports/annual-2024.pdf"')
  end

  def test_link_external_integration
    component = ShadcnPhlexcomponents::Link.new(
      "🌐 Visit Our Blog",
      "https://blog.example.com",
      {
        target: "_blank",
        rel: "noopener noreferrer",
        class: "external-link",
        data: {
          controller: "external-links",
          action: "click->external-links#trackOutbound",
        },
      },
    )

    output = render(component)

    # Check external link attributes
    assert_includes(output, 'href="https://blog.example.com"')
    assert_includes(output, 'target="_blank"')
    assert_includes(output, 'rel="noopener noreferrer"')
    assert_includes(output, "external-link")

    # Check content with emoji
    assert_includes(output, "🌐 Visit Our Blog")

    # Check stimulus integration for external links
    assert_includes(output, 'data-controller="external-links"')
    assert_includes(output, "external-links#trackOutbound")
  end

  def test_link_button_variant_integration
    component = ShadcnPhlexcomponents::Link.new(
      "🎯 Call to Action",
      "/signup",
      {
        variant: :default,
        size: :lg,
        class: "cta-button",
        data: {
          controller: "button-animation",
          action: "click->button-animation#pulse",
        },
      },
    )

    output = render(component)

    # Check that variant removes default link styling
    refute_includes(output, "font-medium underline underline-offset-4")

    # Check custom class is still applied
    assert_includes(output, "cta-button")

    # Check content and href
    assert_includes(output, "🎯 Call to Action")
    assert_includes(output, 'href="/signup"')

    # Check stimulus integration
    assert_includes(output, 'data-controller="button-animation"')
    assert_includes(output, "button-animation#pulse")
  end

  def test_link_stimulus_integration
    component = ShadcnPhlexcomponents::Link.new(
      "Interactive Link",
      "/interactive",
      {
        data: {
          controller: "link-animation tooltip",
          tooltip_content_value: "Click to navigate to interactive page",
          action: "mouseenter->tooltip#show mouseleave->tooltip#hide click->link-animation#flash",
        },
      },
    )

    output = render(component)

    # Check multiple controllers
    assert_match(/data-controller="[^"]*link-animation[^"]*tooltip[^"]*"/, output)
    assert_includes(output, 'data-tooltip-content-value="Click to navigate to interactive page"')

    # Check actions
    assert_includes(output, "tooltip#show")
    assert_includes(output, "tooltip#hide")
    assert_includes(output, "link-animation#flash")

    # Check content
    assert_includes(output, "Interactive Link")
    assert_includes(output, 'href="/interactive"')
  end

  def test_link_with_block_content_integration
    component = ShadcnPhlexcomponents::Link.new(
      "/profile",
      {
        class: "profile-link",
        aria: { label: "View user profile" },
      },
    ) do
      "👤 My Profile"
    end

    output = render(component)

    # Check block content handling
    assert_includes(output, "👤 My Profile")
    assert_includes(output, 'href="/profile"')
    assert_includes(output, "profile-link")
    assert_includes(output, 'aria-label="View user profile"')

    # Check default styling
    assert_includes(output, "font-medium underline underline-offset-4")
  end

  def test_link_contact_methods_integration
    # Test email link
    email_component = ShadcnPhlexcomponents::Link.new(
      "📧 support@example.com",
      "mailto:support@example.com?subject=Support Request",
    )
    email_output = render(email_component)

    assert_includes(email_output, "📧 support@example.com")
    assert_includes(email_output, 'href="mailto:support@example.com?subject=Support Request"')

    # Test phone link
    phone_component = ShadcnPhlexcomponents::Link.new(
      "📞 (555) 123-4567",
      "tel:+15551234567",
    )
    phone_output = render(phone_component)

    assert_includes(phone_output, "📞 (555) 123-4567")
    assert_includes(phone_output, 'href="tel:+15551234567"')
  end
end
