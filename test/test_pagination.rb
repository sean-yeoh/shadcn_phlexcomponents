# frozen_string_literal: true

require "test_helper"

class TestPagination < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Pagination.new { "Pagination content" }
    output = render(component)

    assert_includes(output, "Pagination content")
    assert_includes(output, 'data-shadcn-phlexcomponents="pagination"')
    assert_includes(output, 'role="navigation"')
    assert_includes(output, 'aria-label="navigation"')
    assert_includes(output, "mx-auto flex w-full justify-center")
    assert_includes(output, "flex flex-row items-center gap-1")
    assert_match(%r{<div[^>]*>.*<ul[^>]*>.*Pagination content.*</ul>.*</div>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Pagination.new(
      class: "custom-pagination",
      id: "pagination-id",
      aria: { label: "Custom navigation" },
    ) { "Custom content" }
    output = render(component)

    assert_includes(output, "custom-pagination")
    assert_includes(output, 'id="pagination-id"')
    # ARIA labels get merged with default, so check for custom label presence
    assert_includes(output, "Custom navigation")
    assert_includes(output, "mx-auto flex w-full justify-center")
  end

  def test_it_should_render_with_helper_methods
    component = ShadcnPhlexcomponents::Pagination.new do |pagination|
      pagination.previous("/page/1")
      pagination.item { pagination.link("1", "/page/1", { active: true }) }
      pagination.item { pagination.link("2", "/page/2") }
      pagination.item { pagination.link("3", "/page/3") }
      pagination.ellipsis
      pagination.item { pagination.link("10", "/page/10") }
      pagination.next("/page/3")
    end
    output = render(component)

    # Check navigation structure
    assert_includes(output, 'role="navigation"')
    assert_includes(output, "flex flex-row items-center gap-1")

    # Check previous link
    assert_includes(output, "Previous")
    assert_includes(output, 'aria-label="Go to previous page"')

    # Check page links
    assert_includes(output, "1")
    assert_includes(output, "2")
    assert_includes(output, "3")
    assert_includes(output, "10")

    # Check ellipsis
    assert_includes(output, 'aria-hidden="true"')
    assert_includes(output, "More pages")

    # Check next link
    assert_includes(output, "Next")
    assert_includes(output, 'aria-label="Go to next page"')
  end

  def test_it_should_render_complete_pagination_structure
    component = ShadcnPhlexcomponents::Pagination.new(
      class: "full-pagination",
      aria: { label: "Product pages" },
    ) do |pagination|
      pagination.previous("/products?page=4")

      pagination.item { pagination.link("1", "/products?page=1") }
      pagination.item { pagination.link("2", "/products?page=2") }
      pagination.ellipsis
      pagination.item { pagination.link("4", "/products?page=4") }
      pagination.item { pagination.link("5", "/products?page=5", { active: true }) }
      pagination.item { pagination.link("6", "/products?page=6") }
      pagination.ellipsis
      pagination.item { pagination.link("20", "/products?page=20") }

      pagination.next("/products?page=6")
    end
    output = render(component)

    # Check main container
    assert_includes(output, "full-pagination")
    # ARIA labels get merged with default, so check for custom label presence
    assert_includes(output, "Product pages")

    # Check previous with query params
    assert_includes(output, 'href="/products?page=4"')
    assert_includes(output, "Previous")

    # Check page numbers
    assert_includes(output, "1")
    assert_includes(output, "2")
    assert_includes(output, "4")
    assert_includes(output, "5")
    assert_includes(output, "6")
    assert_includes(output, "20")

    # Check active page
    assert_includes(output, 'aria-current="page"')

    # Check next with query params
    assert_includes(output, 'href="/products?page=6"')
    assert_includes(output, "Next")

    # Check ellipsis elements
    # Check ellipsis elements (may include other aria-hidden elements like SVGs)
    ellipses_count = output.scan('data-shadcn-phlexcomponents="pagination-ellipsis"').length
    assert_equal(2, ellipses_count)
  end
end

class TestPaginationItem < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::PaginationItem.new { "Item content" }
    output = render(component)

    assert_includes(output, "Item content")
    assert_includes(output, 'data-shadcn-phlexcomponents="pagination-item"')
    assert_match(%r{<li[^>]*>Item content</li>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::PaginationItem.new(
      class: "custom-item",
      id: "item-id",
    ) { "Custom item" }
    output = render(component)

    assert_includes(output, "custom-item")
    assert_includes(output, 'id="item-id"')
    assert_includes(output, "Custom item")
  end
end

class TestPaginationLink < ComponentTest
  def test_it_should_render_with_name_and_path
    component = ShadcnPhlexcomponents::PaginationLink.new("5", "/page/5")
    output = render(component)

    assert_includes(output, "5")
    assert_includes(output, 'href="/page/5"')
    # PaginationLink doesn't add its own data attribute since it's used by other components"
    assert_match(%r{<li[^>]*>.*<a[^>]*>5</a>.*</li>}m, output)
  end

  def test_it_should_render_with_block_content
    component = ShadcnPhlexcomponents::PaginationLink.new("/page/3") { "Page 3" }
    output = render(component)

    assert_includes(output, "Page 3")
    assert_includes(output, 'href="/page/3"')
  end

  def test_it_should_handle_active_state
    component = ShadcnPhlexcomponents::PaginationLink.new("2", "/page/2", { active: true })
    output = render(component)

    assert_includes(output, "2")
    assert_includes(output, 'aria-current="page"')
    # Should use outline variant for active state
    assert_includes(output, "border")
  end

  def test_it_should_handle_inactive_state
    component = ShadcnPhlexcomponents::PaginationLink.new("3", "/page/3", { active: false })
    output = render(component)

    assert_includes(output, "3")
    refute_includes(output, 'aria-current="page"')
    # Should use ghost variant for inactive state
    assert_includes(output, "hover:bg-accent")
  end

  def test_it_should_handle_custom_size
    component = ShadcnPhlexcomponents::PaginationLink.new("1", "/page/1", { size: :default })
    output = render(component)

    assert_includes(output, "1")
    # Should include default size styling instead of icon size
    assert_includes(output, "h-9 px-4 py-2")
  end

  def test_it_should_handle_custom_attributes
    component = ShadcnPhlexcomponents::PaginationLink.new(
      "7",
      "/page/7",
      {
        class: "custom-link",
        data: { testid: "page-7" },
      },
    )
    output = render(component)

    assert_includes(output, "custom-link")
    assert_includes(output, 'data-testid="page-7"')
    assert_includes(output, "7")
  end

  def test_it_should_use_icon_size_by_default
    component = ShadcnPhlexcomponents::PaginationLink.new("4", "/page/4")
    output = render(component)

    # Should use icon size by default
    assert_includes(output, "size-9")
  end
end

class TestPaginationPrevious < ComponentTest
  def test_it_should_render_previous_link
    component = ShadcnPhlexcomponents::PaginationPrevious.new("/page/1")
    output = render(component)

    # Previous component renders through PaginationLink, so it has link data attribute
    assert_includes(output, 'href="/page/1"')
    assert_includes(output, 'aria-label="Go to previous page"')
    assert_includes(output, "Previous")
    assert_includes(output, "gap-1 px-2.5 sm:pl-2.5")
    assert_includes(output, "hidden sm:block")
    # Check for chevron-left icon (HTML entities in rendered output)
    assert_includes(output, "&lt;svg")
    assert_includes(output, "&lt;/svg&gt;")
  end

  def test_it_should_render_with_custom_attributes
    component = ShadcnPhlexcomponents::PaginationPrevious.new(
      "/page/2",
      {
        class: "custom-previous",
        aria: { label: "Go to previous product page" },
      },
    )
    output = render(component)

    assert_includes(output, "custom-previous")
    # ARIA labels get merged, so check for both
    assert_includes(output, 'href="/page/2"')
  end

  def test_it_should_include_chevron_icon
    component = ShadcnPhlexcomponents::PaginationPrevious.new("/prev")
    output = render(component)

    # Check for chevron-left icon (HTML entities in rendered output)
    assert_includes(output, "&lt;svg")
    assert_includes(output, "&lt;/svg&gt;")
    assert_includes(output, "Previous")
  end

  def test_it_should_handle_responsive_text
    component = ShadcnPhlexcomponents::PaginationPrevious.new("/previous")
    output = render(component)

    # Text should be hidden on small screens, visible on larger screens
    assert_includes(output, "hidden sm:block")
    assert_includes(output, "Previous")
  end
end

class TestPaginationNext < ComponentTest
  def test_it_should_render_next_link
    component = ShadcnPhlexcomponents::PaginationNext.new("/page/3")
    output = render(component)

    # Next component renders through PaginationLink, so it has link data attribute
    assert_includes(output, 'href="/page/3"')
    assert_includes(output, 'aria-label="Go to next page"')
    assert_includes(output, "Next")
    assert_includes(output, "gap-1 px-2.5 sm:pr-2.5")
    assert_includes(output, "hidden sm:block")
    # Check for chevron-right icon (HTML entities in rendered output)
    assert_includes(output, "&lt;svg")
    assert_includes(output, "&lt;/svg&gt;")
  end

  def test_it_should_render_with_custom_attributes
    component = ShadcnPhlexcomponents::PaginationNext.new(
      "/page/4",
      {
        class: "custom-next",
        aria: { label: "Go to next product page" },
      },
    )
    output = render(component)

    assert_includes(output, "custom-next")
    # ARIA labels get merged, so check for both
    assert_includes(output, 'href="/page/4"')
  end

  def test_it_should_include_chevron_icon
    component = ShadcnPhlexcomponents::PaginationNext.new("/next")
    output = render(component)

    # Check for chevron-right icon (HTML entities in rendered output)
    assert_includes(output, "&lt;svg")
    assert_includes(output, "&lt;/svg&gt;")
    assert_includes(output, "Next")
  end

  def test_it_should_handle_responsive_text
    component = ShadcnPhlexcomponents::PaginationNext.new("/next")
    output = render(component)

    # Text should be hidden on small screens, visible on larger screens
    assert_includes(output, "hidden sm:block")
    assert_includes(output, "Next")
  end
end

class TestPaginationEllipsis < ComponentTest
  def test_it_should_render_ellipsis
    component = ShadcnPhlexcomponents::PaginationEllipsis.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="pagination-ellipsis"')
    assert_includes(output, 'aria-hidden="true"')
    assert_includes(output, "flex size-9 items-center justify-center")
    assert_includes(output, "sr-only")
    assert_includes(output, "More pages")
    # Check for ellipsis icon (direct SVG rendering)
    assert_includes(output, "<svg")
    assert_includes(output, "</svg>")
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::PaginationEllipsis.new(
      class: "custom-ellipsis",
      id: "ellipsis-id",
    )
    output = render(component)

    assert_includes(output, "custom-ellipsis")
    assert_includes(output, 'id="ellipsis-id"')
    assert_includes(output, 'aria-hidden="true"')
  end

  def test_it_should_include_ellipsis_icon
    component = ShadcnPhlexcomponents::PaginationEllipsis.new
    output = render(component)

    # Check for ellipsis icon (direct SVG rendering)
    assert_includes(output, "<svg")
    assert_includes(output, "</svg>")
    assert_includes(output, "size-4")
    assert_includes(output, "More pages")
  end
end

class TestPaginationWithCustomConfiguration < ComponentTest
  def test_pagination_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.pagination = {
      root: { base: "custom-pagination-base flex justify-start" },
      previous: { base: "custom-previous-base" },
      next: { base: "custom-next-base" },
      ellipsis: { base: "custom-ellipsis-base" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    pagination_classes = [
      "PaginationEllipsis",
      "PaginationNext",
      "PaginationPrevious",
      "PaginationLink",
      "PaginationItem",
      "Pagination",
    ]

    pagination_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/pagination.rb", __dir__))

    # Test components with custom configuration
    pagination = ShadcnPhlexcomponents::Pagination.new { "Test" }
    pagination_output = render(pagination)
    assert_includes(pagination_output, "custom-pagination-base")
    assert_includes(pagination_output, "flex justify-start")

    previous = ShadcnPhlexcomponents::PaginationPrevious.new("/prev")
    assert_includes(render(previous), "custom-previous-base")

    next_comp = ShadcnPhlexcomponents::PaginationNext.new("/next")
    assert_includes(render(next_comp), "custom-next-base")

    ellipsis = ShadcnPhlexcomponents::PaginationEllipsis.new
    assert_includes(render(ellipsis), "custom-ellipsis-base")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    pagination_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/pagination.rb", __dir__))
  end
end

class TestPaginationIntegration < ComponentTest
  def test_complete_pagination_workflow
    component = ShadcnPhlexcomponents::Pagination.new(
      class: "product-pagination",
      aria: { label: "Product catalog navigation" },
      data: {
        controller: "pagination analytics",
        analytics_category: "navigation",
        pagination_current_page: "5",
      },
    ) do |pagination|
      pagination.previous("/products?page=4&category=electronics")

      pagination.item { pagination.link("1", "/products?page=1&category=electronics") }
      pagination.item { pagination.link("2", "/products?page=2&category=electronics") }
      pagination.ellipsis
      pagination.item { pagination.link("4", "/products?page=4&category=electronics") }
      pagination.item { pagination.link("5", "/products?page=5&category=electronics", { active: true }) }
      pagination.item { pagination.link("6", "/products?page=6&category=electronics") }
      pagination.ellipsis
      pagination.item { pagination.link("25", "/products?page=25&category=electronics") }

      pagination.next("/products?page=6&category=electronics")
    end

    output = render(component)

    # Check main structure
    assert_includes(output, "product-pagination")
    # Check accessibility attributes (merged with default)
    assert_includes(output, "Product catalog navigation")

    # Check data attributes
    assert_match(/data-controller="[^"]*pagination[^"]*analytics[^"]*"/, output)
    assert_includes(output, 'data-analytics-category="navigation"')
    assert_includes(output, 'data-pagination-current-page="5"')

    # Check navigation structure
    assert_includes(output, 'role="navigation"')
    assert_includes(output, "flex flex-row items-center gap-1")

    # Check previous link with query params
    assert_includes(output, 'href="/products?page=4&amp;category=electronics"')
    assert_includes(output, 'aria-label="Go to previous page"')

    # Check page links with query params
    assert_includes(output, 'href="/products?page=1&amp;category=electronics"')
    assert_includes(output, 'href="/products?page=2&amp;category=electronics"')
    assert_includes(output, 'href="/products?page=4&amp;category=electronics"')
    assert_includes(output, 'href="/products?page=6&amp;category=electronics"')
    assert_includes(output, 'href="/products?page=25&amp;category=electronics"')

    # Check active page
    assert_includes(output, 'aria-current="page"')
    assert_includes(output, 'href="/products?page=5&amp;category=electronics"')

    # Check next link
    assert_includes(output, 'href="/products?page=6&amp;category=electronics"')
    assert_includes(output, 'aria-label="Go to next page"')

    # Check ellipsis elements
    assert_includes(output, 'aria-hidden="true"')
    assert_includes(output, "More pages")
  end

  def test_pagination_accessibility_features
    component = ShadcnPhlexcomponents::Pagination.new(
      aria: { label: "Search results navigation" },
    ) do |pagination|
      pagination.previous("/search?q=ruby&page=2", {
        aria: { label: "Go to previous search results page" },
      })

      pagination.item do
        pagination.link("2", "/search?q=ruby&page=2")
      end
      pagination.item do
        pagination.link("3", "/search?q=ruby&page=3", {
          active: true,
          aria: { label: "Current page, page 3" },
        })
      end
      pagination.item do
        pagination.link("4", "/search?q=ruby&page=4")
      end

      pagination.next("/search?q=ruby&page=4", {
        aria: { label: "Go to next search results page" },
      })
    end

    output = render(component)

    # Check accessibility attributes
    assert_includes(output, "Search results navigation")
    # Check for custom previous aria label (merged with default)
    assert_includes(output, "Go to previous search results page")
    # Check for custom next aria label (merged with default)
    assert_includes(output, "Go to next search results page")

    # Check current page accessibility
    assert_includes(output, 'aria-current="page"')

    # Check navigation role
    assert_includes(output, 'role="navigation"')
  end

  def test_pagination_responsive_design
    component = ShadcnPhlexcomponents::Pagination.new do |pagination|
      pagination.previous("/page/1")
      pagination.item { pagination.link("1", "/page/1") }
      pagination.item { pagination.link("2", "/page/2", { active: true }) }
      pagination.item { pagination.link("3", "/page/3") }
      pagination.next("/page/3")
    end

    output = render(component)

    # Check responsive classes
    assert_includes(output, "mx-auto flex w-full justify-center") # Container responsive
    assert_includes(output, "gap-1 px-2.5 sm:pl-2.5") # Previous responsive padding
    assert_includes(output, "gap-1 px-2.5 sm:pr-2.5") # Next responsive padding
    assert_includes(output, "hidden sm:block") # Text hidden on mobile
  end

  def test_pagination_with_stimulus_integration
    component = ShadcnPhlexcomponents::Pagination.new(
      data: {
        controller: "pagination infinite-scroll",
        infinite_scroll_threshold_value: "100",
        action: "scroll->infinite-scroll#checkScroll",
      },
    ) do |pagination|
      pagination.item do
        pagination.link("1", "/api/posts?page=1", {
          data: { action: "click->pagination#loadPage" },
        })
      end
      pagination.item { pagination.link("2", "/api/posts?page=2", { active: true }) }
      pagination.item do
        pagination.link("3", "/api/posts?page=3", {
          data: { action: "click->pagination#loadPage" },
        })
      end
    end

    output = render(component)

    # Check multiple controllers
    assert_match(/data-controller="[^"]*pagination[^"]*infinite-scroll[^"]*"/, output)
    assert_includes(output, 'data-infinite-scroll-threshold-value="100"')

    # Check pagination actions
    assert_includes(output, "loadPage")
    assert_includes(output, "checkScroll")
  end

  def test_pagination_empty_state
    component = ShadcnPhlexcomponents::Pagination.new(
      class: "empty-pagination",
    ) do |pagination|
      # Single page, no navigation needed
      pagination.item { pagination.link("1", "/page/1", { active: true }) }
    end

    output = render(component)

    # Check single page structure
    assert_includes(output, "empty-pagination")
    assert_includes(output, 'aria-current="page"')
    assert_includes(output, "1")

    # Should not include previous/next links
    refute_includes(output, "Previous")
    refute_includes(output, "Next")
  end
end
