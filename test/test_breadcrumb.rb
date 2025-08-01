# frozen_string_literal: true

require "test_helper"

class TestBreadcrumb < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Breadcrumb.new { "Breadcrumb content" }
    output = render(component)

    assert_includes(output, "text-muted-foreground flex flex-wrap items-center gap-1.5 text-sm")
    assert_includes(output, "Breadcrumb content")
    assert_includes(output, 'aria-label="breadcrumb"')
    assert_match(%r{<nav[^>]*aria-label="breadcrumb"[^>]*>.*<ol[^>]*>.*Breadcrumb content.*</ol>.*</nav>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Breadcrumb.new(class: "breadcrumb-class", id: "breadcrumb-id")
    output = render(component)

    assert_includes(output, "breadcrumb-class")
    assert_includes(output, 'id="breadcrumb-id"')
    assert_includes(output, "text-muted-foreground flex flex-wrap")
  end

  def test_it_should_render_items
    component = ShadcnPhlexcomponents::Breadcrumb.new do |breadcrumb|
      breadcrumb.item { "Home" }
      breadcrumb.item { "Category" }
    end
    output = render(component)

    assert_includes(output, "Home")
    assert_includes(output, "Category")
    assert_includes(output, "inline-flex items-center gap-1.5")
  end

  def test_it_should_render_links_collection
    links = [
      { name: "Home", path: "/" },
      { name: "Products", path: "/products" },
      { name: "Current Page", path: nil },
    ]

    component = ShadcnPhlexcomponents::Breadcrumb.new do |breadcrumb|
      breadcrumb.links(links)
    end
    output = render(component)

    # Should render first two as links
    assert_includes(output, 'href="/"')
    assert_includes(output, 'href="/products"')
    assert_includes(output, "Home")
    assert_includes(output, "Products")

    # Last item should be rendered as page (not link)
    assert_includes(output, "Current Page")
    assert_includes(output, 'aria-current="page"')

    # Should have separators between items (look for the chevron path)
    assert_includes(output, 'path d="m9 18 6-6-6-6"')
  end

  def test_it_should_render_complete_breadcrumb_structure
    component = ShadcnPhlexcomponents::Breadcrumb.new do |breadcrumb|
      breadcrumb.item do
        breadcrumb.link("Home", "/")
      end
      breadcrumb.separator
      breadcrumb.item do
        breadcrumb.link("Products", "/products")
      end
      breadcrumb.separator
      breadcrumb.item do
        breadcrumb.page { "Current Product" }
      end
    end
    output = render(component)

    # Check links
    assert_includes(output, 'href="/"')
    assert_includes(output, 'href="/products"')
    assert_includes(output, "transition-colors hover:text-foreground")

    # Check separators
    assert_includes(output, 'path d="m9 18 6-6-6-6"')
    assert_includes(output, 'role="presentation"')
    assert_includes(output, 'aria-hidden="true"')

    # Check current page
    assert_includes(output, "Current Product")
    assert_includes(output, 'role="link"')
    assert_includes(output, 'aria-disabled="true"')
    assert_includes(output, 'aria-current="page"')
  end
end

class TestBreadcrumbItem < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::BreadcrumbItem.new { "Item content" }
    output = render(component)

    assert_includes(output, "inline-flex items-center gap-1.5")
    assert_includes(output, "Item content")
    assert_match(%r{<li[^>]*>Item content</li>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::BreadcrumbItem.new(class: "item-class", id: "item-id")
    output = render(component)

    assert_includes(output, "item-class")
    assert_includes(output, 'id="item-id"')
    assert_includes(output, "inline-flex items-center gap-1.5")
  end
end

class TestBreadcrumbLink < ComponentTest
  def test_it_should_render_link_with_name_and_path
    component = ShadcnPhlexcomponents::BreadcrumbLink.new("Home", "/")
    output = render(component)

    assert_includes(output, 'href="/"')
    assert_includes(output, "Home")
    assert_includes(output, "transition-colors hover:text-foreground")
    assert_match(%r{<a[^>]*href="/"[^>]*>Home</a>}, output)
  end

  def test_it_should_render_link_with_block
    component = ShadcnPhlexcomponents::BreadcrumbLink.new("/products") { "Products" }
    output = render(component)

    assert_includes(output, 'href="/products"')
    assert_includes(output, "Products")
    assert_includes(output, "transition-colors hover:text-foreground")
  end

  def test_it_should_render_link_with_custom_attributes
    component = ShadcnPhlexcomponents::BreadcrumbLink.new("About", "/about", class: "custom-link")
    output = render(component)

    assert_includes(output, "custom-link")
    assert_includes(output, "transition-colors hover:text-foreground")
    assert_includes(output, 'href="/about"')
    assert_includes(output, "About")
  end

  def test_it_should_handle_rails_link_options
    component = ShadcnPhlexcomponents::BreadcrumbLink.new(
      "External",
      "https://example.com",
      target: "_blank",
      rel: "noopener",
    )
    output = render(component)

    assert_includes(output, 'href="https://example.com"')
    assert_includes(output, 'target="_blank"')
    assert_includes(output, 'rel="noopener"')
    assert_includes(output, "External")
  end
end

class TestBreadcrumbSeparator < ComponentTest
  def test_it_should_render_default_separator
    component = ShadcnPhlexcomponents::BreadcrumbSeparator.new
    output = render(component)

    assert_includes(output, 'role="presentation"')
    assert_includes(output, 'aria-hidden="true"')
    assert_includes(output, "[&>svg]:size-3.5")
    assert_includes(output, 'path d="m9 18 6-6-6-6"')
    assert_match(%r{<li[^>]*>.*<svg[^>]*>.*</svg>.*</li>}m, output)
  end

  def test_it_should_render_custom_separator
    component = ShadcnPhlexcomponents::BreadcrumbSeparator.new { "/" }
    output = render(component)

    assert_includes(output, 'role="presentation"')
    assert_includes(output, 'aria-hidden="true"')
    assert_includes(output, "/")
    refute_includes(output, 'path d="m9 18 6-6-6-6"')
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::BreadcrumbSeparator.new(class: "separator-class")
    output = render(component)

    assert_includes(output, "separator-class")
    assert_includes(output, "[&>svg]:size-3.5")
    assert_includes(output, 'role="presentation"')
  end
end

class TestBreadcrumbPage < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::BreadcrumbPage.new { "Current Page" }
    output = render(component)

    assert_includes(output, "Current Page")
    assert_includes(output, "font-normal text-foreground")
    assert_includes(output, 'role="link"')
    assert_includes(output, 'aria-disabled="true"')
    assert_includes(output, 'aria-current="page"')
    assert_match(%r{<span[^>]*>Current Page</span>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::BreadcrumbPage.new(class: "page-class", id: "current-page")
    output = render(component)

    assert_includes(output, "page-class")
    assert_includes(output, 'id="current-page"')
    assert_includes(output, "font-normal text-foreground")
    assert_includes(output, 'aria-current="page"')
  end
end

class TestBreadcrumbEllipsis < ComponentTest
  def test_it_should_render_ellipsis
    component = ShadcnPhlexcomponents::BreadcrumbEllipsis.new
    output = render(component)

    assert_includes(output, "flex size-9 items-center justify-center")
    assert_includes(output, 'role="presentation"')
    assert_includes(output, 'aria-hidden="true"')
    assert_includes(output, '<circle cx="12" cy="12" r="1">')
    assert_includes(output, 'class="sr-only"')
    assert_includes(output, "More")
    assert_match(%r{<span[^>]*>.*<svg[^>]*>.*</svg>.*<span[^>]*class="sr-only"[^>]*>More</span>.*</span>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::BreadcrumbEllipsis.new(class: "ellipsis-class")
    output = render(component)

    assert_includes(output, "ellipsis-class")
    assert_includes(output, "flex size-9 items-center justify-center")
    assert_includes(output, 'role="presentation"')
  end
end

class TestBreadcrumbWithCustomConfiguration < ComponentTest
  def test_breadcrumb_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.breadcrumb = {
      root: {
        base: "custom-breadcrumb-base",
      },
      item: {
        base: "custom-item-base",
      },
      link: {
        base: "custom-link-base",
      },
      separator: {
        base: "custom-separator-base",
      },
      page: {
        base: "custom-page-base",
      },
      ellipsis: {
        base: "custom-ellipsis-base",
      },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload the Breadcrumb classes to pick up the new configuration
    [
      "BreadcrumbEllipsis",
      "BreadcrumbPage",
      "BreadcrumbSeparator",
      "BreadcrumbLink",
      "BreadcrumbItem",
      "Breadcrumb",
    ].each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/breadcrumb.rb", __dir__))

    # Test Breadcrumb with custom configuration
    breadcrumb_component = ShadcnPhlexcomponents::Breadcrumb.new { "Test" }
    breadcrumb_output = render(breadcrumb_component)
    assert_includes(breadcrumb_output, "custom-breadcrumb-base")

    # Test BreadcrumbItem with custom configuration
    item_component = ShadcnPhlexcomponents::BreadcrumbItem.new { "Item" }
    item_output = render(item_component)
    assert_includes(item_output, "custom-item-base")

    # Test BreadcrumbLink with custom configuration
    link_component = ShadcnPhlexcomponents::BreadcrumbLink.new("Link", "/test")
    link_output = render(link_component)
    assert_includes(link_output, "custom-link-base")

    # Test BreadcrumbSeparator with custom configuration
    separator_component = ShadcnPhlexcomponents::BreadcrumbSeparator.new
    separator_output = render(separator_component)
    assert_includes(separator_output, "custom-separator-base")

    # Test BreadcrumbPage with custom configuration
    page_component = ShadcnPhlexcomponents::BreadcrumbPage.new { "Page" }
    page_output = render(page_component)
    assert_includes(page_output, "custom-page-base")

    # Test BreadcrumbEllipsis with custom configuration
    ellipsis_component = ShadcnPhlexcomponents::BreadcrumbEllipsis.new
    ellipsis_output = render(ellipsis_component)
    assert_includes(ellipsis_output, "custom-ellipsis-base")
  ensure
    # Restore and reload classes
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    [
      "BreadcrumbEllipsis",
      "BreadcrumbPage",
      "BreadcrumbSeparator",
      "BreadcrumbLink",
      "BreadcrumbItem",
      "Breadcrumb",
    ].each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/breadcrumb.rb", __dir__))
  end
end

class TestBreadcrumbIntegration < ComponentTest
  def test_complete_breadcrumb_navigation
    component = ShadcnPhlexcomponents::Breadcrumb.new do |breadcrumb|
      breadcrumb.item do
        breadcrumb.link("🏠 Home", "/")
      end
      breadcrumb.separator
      breadcrumb.item do
        breadcrumb.link("📦 Products", "/products")
      end
      breadcrumb.separator
      breadcrumb.item do
        breadcrumb.link("💻 Electronics", "/products/electronics")
      end
      breadcrumb.separator
      breadcrumb.ellipsis
      breadcrumb.separator
      breadcrumb.item do
        breadcrumb.page { "MacBook Pro 16-inch" }
      end
    end

    output = render(component)

    # Check navigation structure
    assert_includes(output, 'aria-label="breadcrumb"')
    assert_match(/<nav[^>]*>.*<ol[^>]*>/m, output)

    # Check all breadcrumb items
    assert_includes(output, "🏠 Home")
    assert_includes(output, "📦 Products")
    assert_includes(output, "💻 Electronics")
    assert_includes(output, "MacBook Pro 16-inch")

    # Check links
    assert_includes(output, 'href="/"')
    assert_includes(output, 'href="/products"')
    assert_includes(output, 'href="/products/electronics"')

    # Check separators
    assert_includes(output, 'path d="m9 18 6-6-6-6"')

    # Check ellipsis
    assert_includes(output, '<circle cx="12" cy="12" r="1">')
    assert_includes(output, "More")

    # Check current page
    assert_includes(output, 'aria-current="page"')
    assert_includes(output, 'aria-disabled="true"')

    # Check proper structure nesting
    assert_match(%r{<nav[^>]*aria-label="breadcrumb"[^>]*>.*<ol[^>]*>.*<li[^>]*>.*<a[^>]*>🏠 Home</a>.*</li>.*</ol>.*</nav>}m, output)
  end

  def test_breadcrumb_with_links_helper
    links = [
      { name: "Dashboard", path: "/dashboard" },
      { name: "Settings", path: "/dashboard/settings" },
      { name: "Profile", path: "/dashboard/settings/profile" },
      { name: "Edit Profile" }, # No path means current page
    ]

    component = ShadcnPhlexcomponents::Breadcrumb.new do |breadcrumb|
      breadcrumb.links(links)
    end

    output = render(component)

    # Check that first three are links
    assert_includes(output, 'href="/dashboard"')
    assert_includes(output, 'href="/dashboard/settings"')
    assert_includes(output, 'href="/dashboard/settings/profile"')

    # Check that last one is current page
    assert_includes(output, "Edit Profile")
    assert_includes(output, 'aria-current="page"')

    # Check separators are automatically added
    assert_includes(output, 'path d="m9 18 6-6-6-6"')

    # Should have proper accessibility
    assert_includes(output, 'aria-label="breadcrumb"')
  end

  def test_breadcrumb_responsive_behavior
    component = ShadcnPhlexcomponents::Breadcrumb.new(class: "max-w-sm") do |breadcrumb|
      breadcrumb.item do
        breadcrumb.link("Very Long Category Name", "/category")
      end
      breadcrumb.separator
      breadcrumb.ellipsis
      breadcrumb.separator
      breadcrumb.item do
        breadcrumb.page { "Very Long Product Name That Might Wrap" }
      end
    end

    output = render(component)

    # Check responsive classes
    assert_includes(output, "flex flex-wrap")
    assert_includes(output, "break-words")
    assert_includes(output, "gap-1.5")
    assert_includes(output, "sm:gap-2.5")
    assert_includes(output, "max-w-sm")

    # Check ellipsis for collapsed items
    assert_includes(output, '<circle cx="12" cy="12" r="1">')
    assert_includes(output, "flex size-9 items-center justify-center")
  end
end
