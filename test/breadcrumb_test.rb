# frozen_string_literal: true

require "test_helper"

class BreadcrumbTest < ComponentTest
  def test_it_should_render_breadcrumb
    output = render(Breadcrumb.new)
    assert_match(%r{<nav.+<ol.+</ol></nav>}, output)
    assert_match(%r{<nav aria-label="breadcrumb".+</nav>}, output)
  end

  def test_it_should_render_base_styles
    output = render(Breadcrumb.new)
    assert_includes(output, Breadcrumb::STYLES.split("\n").join(" "))
  end

  def test_it_should_render_item
    breadcrumb = Breadcrumb.new do |b|
      b.item { "Breadcrumb item" }
    end

    output = render(breadcrumb)
    assert_match(/Breadcrumb item/, output)
  end

  def test_it_should_render_link
    breadcrumb = Breadcrumb.new do |b|
      b.link("My posts", Rails.application.routes.url_helpers.posts_path)
    end

    output = render(breadcrumb)
    assert_match(/My posts/, output)
  end

  def test_it_should_render_separator
    output = render(Breadcrumb.new(&:separator))
    assert_match(%r{<svg.+</svg>}, output)
  end

  def test_it_should_render_page
    breadcrumb = Breadcrumb.new do |b|
      b.page { "Breadcrumb page" }
    end

    output = render(breadcrumb)
    assert_match(/Breadcrumb page/, output)
  end

  def test_it_should_render_ellipsis
    output = render(Breadcrumb.new(&:ellipsis))
    assert_match(%r{<svg.+</svg>}, output)
  end

  def test_it_should_render_links
    breadcrumb = Breadcrumb.new do |b|
      b.links([
        {
          name: "First link",
          path: "/first_link",
        },
        {
          name: "Second link",
          path: "/second_link",
        },
      ])
    end

    output = render(breadcrumb)

    assert_equal(
      output,
      <<~HEREDOC.split("\n").map(&:strip).join(""),
        <nav aria-label="breadcrumb">
          <ol class="flex flex-wrap items-center gap-1.5 break-words text-sm text-muted-foreground sm:gap-2.5">
            <li class="inline-flex items-center gap-1.5">
              <a class="transition-colors hover:text-foreground" href="/first_link">
                First link
              </a>
            </li>
            <li role="presentation" aria-hidden="true" class="[&>svg]:w-3.5 [&>svg]:h-3.5">
              <svg aria-hidden="true" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="m9 18 6-6-6-6"></path>
              </svg>
            </li>
            <li class="inline-flex items-center gap-1.5">
              <span role="link" aria-disabled="true" aria-current="page" class="font-normal text-foreground">
                Second link
              </span>
            </li>
          </ol>
        </nav>
      HEREDOC
    )
  end

  def test_it_should_accept_custom_attributes
    output = render(Breadcrumb.new(
      class: "test-class",
      data: { action: "test-action" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
  end
end
