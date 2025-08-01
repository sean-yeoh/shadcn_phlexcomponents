# frozen_string_literal: true

require "test_helper"

class TestSkeleton < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Skeleton.new { "Loading content..." }
    output = render(component)

    assert_includes(output, "Loading content...")
    assert_includes(output, 'data-shadcn-phlexcomponents="skeleton"')
    assert_includes(output, "bg-accent animate-pulse rounded-md")
    assert_match(%r{<div[^>]*>.*Loading content.*</div>}m, output)
  end

  def test_it_should_render_with_default_values
    component = ShadcnPhlexcomponents::Skeleton.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="skeleton"')
    assert_includes(output, "bg-accent animate-pulse rounded-md")
    assert_match(%r{<div[^>]*></div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Skeleton.new(
      class: "custom-skeleton h-4 w-32",
      id: "skeleton-id",
      data: { testid: "loading-skeleton" },
    )
    output = render(component)

    assert_includes(output, "custom-skeleton h-4 w-32")
    assert_includes(output, 'id="skeleton-id"')
    assert_includes(output, 'data-testid="loading-skeleton"')
    assert_includes(output, "bg-accent animate-pulse rounded-md")
  end

  def test_it_should_render_with_aria_attributes
    component = ShadcnPhlexcomponents::Skeleton.new(
      aria: {
        label: "Loading content",
        busy: "true",
        live: "polite",
      },
    )
    output = render(component)

    assert_includes(output, 'aria-label="Loading content"')
    assert_includes(output, 'aria-busy="true"')
    assert_includes(output, 'aria-live="polite"')
  end

  def test_it_should_handle_different_sizes
    sizes = [
      { class: "h-4 w-full", description: "text line" },
      { class: "h-12 w-12 rounded-full", description: "avatar" },
      { class: "h-32 w-full rounded-lg", description: "card" },
      { class: "h-6 w-24", description: "button" },
    ]

    sizes.each do |size_config|
      component = ShadcnPhlexcomponents::Skeleton.new(
        class: size_config[:class],
        aria: { label: "Loading #{size_config[:description]}" },
      )
      output = render(component)

      assert_includes(output, size_config[:class])
      assert_includes(output, "Loading #{size_config[:description]}")
      assert_includes(output, "bg-accent animate-pulse rounded-md")
    end
  end

  def test_it_should_support_custom_styling
    component = ShadcnPhlexcomponents::Skeleton.new(
      class: "bg-muted opacity-60 duration-1000",
      style: "animation-delay: 200ms;",
    )
    output = render(component)

    assert_includes(output, "bg-muted opacity-60 duration-1000")
    assert_includes(output, 'style="animation-delay: 200ms;"')
    assert_includes(output, "bg-accent animate-pulse rounded-md")
  end

  def test_it_should_handle_data_attributes
    component = ShadcnPhlexcomponents::Skeleton.new(
      data: {
        controller: "loading",
        loading_target: "skeleton",
        action: "loading:complete->loading#hide",
      },
    )
    output = render(component)

    assert_includes(output, 'data-controller="loading"')
    assert_includes(output, 'data-loading-target="skeleton"')
    assert_includes(output, "loading#hide")
  end

  def test_it_should_render_with_role_attributes
    component = ShadcnPhlexcomponents::Skeleton.new(
      role: "status",
      aria: { label: "Loading..." },
    )
    output = render(component)

    assert_includes(output, 'role="status"')
    assert_includes(output, 'aria-label="Loading..."')
  end
end

class TestSkeletonWithCustomConfiguration < ComponentTest
  def test_skeleton_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.skeleton = {
      base: "custom-skeleton-base bg-gray-300 animate-bounce rounded-lg",
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload class
    ShadcnPhlexcomponents.send(:remove_const, :Skeleton) if ShadcnPhlexcomponents.const_defined?(:Skeleton)
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/skeleton.rb", __dir__))

    # Test component with custom configuration
    skeleton = ShadcnPhlexcomponents::Skeleton.new { "Custom skeleton" }
    skeleton_output = render(skeleton)
    assert_includes(skeleton_output, "custom-skeleton-base")
    assert_includes(skeleton_output, "bg-gray-300 animate-bounce rounded-lg")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    ShadcnPhlexcomponents.send(:remove_const, :Skeleton) if ShadcnPhlexcomponents.const_defined?(:Skeleton)
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/skeleton.rb", __dir__))
  end
end

class TestSkeletonIntegration < ComponentTest
  def test_skeleton_loading_states
    component = ShadcnPhlexcomponents::Skeleton.new(
      class: "profile-skeleton h-20 w-full",
      role: "status",
      aria: {
        label: "Loading user profile",
        live: "polite",
      },
      data: {
        controller: "profile-loader",
        profile_loader_target: "skeleton",
        profile_loader_timeout_value: "3000",
      },
    ) { "Loading profile..." }

    output = render(component)

    # Check loading state structure
    assert_includes(output, "profile-skeleton h-20 w-full")
    assert_includes(output, 'role="status"')
    assert_includes(output, 'aria-label="Loading user profile"')
    assert_includes(output, 'aria-live="polite"')

    # Check controller integration
    assert_includes(output, 'data-controller="profile-loader"')
    assert_includes(output, 'data-profile-loader-target="skeleton"')
    assert_includes(output, 'data-profile-loader-timeout-value="3000"')

    # Check content and styling
    assert_includes(output, "Loading profile...")
    assert_includes(output, "bg-accent animate-pulse rounded-md")
  end

  def test_skeleton_grid_layout
    skeletons = [
      { class: "h-4 w-3/4", content: "Title loading" },
      { class: "h-3 w-1/2 mt-2", content: "Subtitle loading" },
      { class: "h-8 w-full mt-4", content: "Content loading" },
      { class: "h-3 w-1/4 mt-2", content: "Footer loading" },
    ]

    output = ""
    skeletons.each do |skeleton_config|
      component = ShadcnPhlexcomponents::Skeleton.new(
        class: skeleton_config[:class],
        aria: { label: skeleton_config[:content] },
      )
      output += render(component)
    end

    # Check all skeleton parts are present
    assert_includes(output, "h-4 w-3/4")
    assert_includes(output, "h-3 w-1/2 mt-2")
    assert_includes(output, "h-8 w-full mt-4")
    assert_includes(output, "h-3 w-1/4 mt-2")

    # Check aria labels
    assert_includes(output, 'aria-label="Title loading"')
    assert_includes(output, 'aria-label="Subtitle loading"')
    assert_includes(output, 'aria-label="Content loading"')
    assert_includes(output, 'aria-label="Footer loading"')
  end

  def test_skeleton_card_layout
    component = ShadcnPhlexcomponents::Skeleton.new(
      class: "card-skeleton rounded-lg p-4 space-y-3",
      data: {
        controller: "card-loader",
        card_loader_target: "skeleton",
      },
    ) do
      # This represents the structure that would be inside a loading card
      "Card content loading..."
    end

    output = render(component)

    # Check card skeleton structure
    assert_includes(output, "card-skeleton rounded-lg p-4 space-y-3")
    assert_includes(output, 'data-controller="card-loader"')
    assert_includes(output, 'data-card-loader-target="skeleton"')
    assert_includes(output, "Card content loading...")
    assert_includes(output, "bg-accent animate-pulse rounded-md")
  end

  def test_skeleton_accessibility_features
    component = ShadcnPhlexcomponents::Skeleton.new(
      role: "status",
      tabindex: -1,
      aria: {
        label: "Loading article content",
        live: "assertive",
        atomic: "true",
      },
      data: {
        controller: "accessibility-skeleton",
        accessibility_skeleton_target: "loader",
      },
    )
    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'role="status"')
    assert_includes(output, 'tabindex="-1"')
    assert_includes(output, 'aria-label="Loading article content"')
    assert_includes(output, 'aria-live="assertive"')
    assert_includes(output, 'aria-atomic="true"')

    # Check controller integration
    assert_includes(output, 'data-controller="accessibility-skeleton"')
    assert_includes(output, 'data-accessibility-skeleton-target="loader"')
  end

  def test_skeleton_animation_variants
    animations = [
      { class: "animate-pulse", description: "pulse animation" },
      { class: "animate-bounce", description: "bounce animation" },
      { class: "animate-spin", description: "spin animation" },
      { class: "animate-none bg-gray-200", description: "no animation" },
    ]

    animations.each do |animation_config|
      component = ShadcnPhlexcomponents::Skeleton.new(
        class: animation_config[:class],
        data: { animation: animation_config[:description] },
      )
      output = render(component)

      assert_includes(output, animation_config[:class])
      assert_includes(output, "data-animation=\"#{animation_config[:description]}\"")
      assert_includes(output, "bg-accent animate-pulse rounded-md")
    end
  end

  def test_skeleton_responsive_behavior
    component = ShadcnPhlexcomponents::Skeleton.new(
      class: "responsive-skeleton h-4 w-full sm:h-6 sm:w-3/4 md:h-8 lg:w-1/2",
      data: {
        controller: "responsive-skeleton",
        responsive_skeleton_breakpoint_value: "lg",
      },
    )
    output = render(component)

    # Check responsive classes
    assert_includes(output, "responsive-skeleton")
    assert_includes(output, "h-4 w-full sm:h-6 sm:w-3/4 md:h-8 lg:w-1/2")
    assert_includes(output, 'data-controller="responsive-skeleton"')
    assert_includes(output, 'data-responsive-skeleton-breakpoint-value="lg"')
  end

  def test_skeleton_theme_variants
    themes = [
      { class: "skeleton-light bg-gray-100", theme: "light" },
      { class: "skeleton-dark bg-gray-700", theme: "dark" },
      { class: "skeleton-colored bg-blue-200", theme: "colored" },
    ]

    themes.each do |theme_config|
      component = ShadcnPhlexcomponents::Skeleton.new(
        class: theme_config[:class],
        data: { theme: theme_config[:theme] },
      )
      output = render(component)

      assert_includes(output, theme_config[:class])
      assert_includes(output, "data-theme=\"#{theme_config[:theme]}\"")
      assert_includes(output, "bg-accent animate-pulse rounded-md")
    end
  end

  def test_skeleton_complex_layout
    component = ShadcnPhlexcomponents::Skeleton.new(
      class: "article-skeleton max-w-2xl mx-auto p-6",
      role: "status",
      aria: {
        label: "Loading article",
        live: "polite",
      },
      data: {
        controller: "article-loader content-loader",
        article_loader_target: "skeleton",
        content_loader_timeout: "5000",
        action: "article:loaded->article-loader#hide",
      },
    ) { "📰 Loading news article..." }

    output = render(component)

    # Check complex layout structure
    assert_includes(output, "article-skeleton max-w-2xl mx-auto p-6")
    assert_includes(output, 'role="status"')
    assert_includes(output, 'aria-label="Loading article"')
    assert_includes(output, 'aria-live="polite"')

    # Check multiple controllers
    assert_match(/data-controller="[^"]*article-loader[^"]*content-loader[^"]*"/, output)
    assert_includes(output, 'data-article-loader-target="skeleton"')
    assert_includes(output, 'data-content-loader-timeout="5000"')
    assert_includes(output, "article-loader#hide")

    # Check content with emoji
    assert_includes(output, "📰 Loading news article...")
    assert_includes(output, "bg-accent animate-pulse rounded-md")
  end
end
