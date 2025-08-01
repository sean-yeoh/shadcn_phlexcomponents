# frozen_string_literal: true

require "test_helper"

class TestAvatar < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Avatar.new { "Avatar content" }
    output = render(component)

    assert_includes(output, 'data-controller="avatar"')
    assert_includes(output, "relative flex size-8 shrink-0 overflow-hidden rounded-full")
    assert_includes(output, "Avatar content")
    assert_match(%r{<span[^>]*>Avatar content</span>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Avatar.new(class: "avatar-class", id: "avatar-id", data: { testid: "avatar" })
    output = render(component)

    assert_includes(output, "avatar-class")
    assert_includes(output, 'id="avatar-id"')
    assert_includes(output, 'data-testid="avatar"')
    assert_includes(output, 'data-controller="avatar"')
  end

  def test_it_should_render_image
    component = ShadcnPhlexcomponents::Avatar.new do |avatar|
      avatar.image(src: "/avatar.jpg", alt: "User avatar")
    end
    output = render(component)

    assert_includes(output, 'src="/avatar.jpg"')
    assert_includes(output, 'alt="User avatar"')
    assert_includes(output, 'data-avatar-target="image"')
    assert_includes(output, "aspect-square size-full")
  end

  def test_it_should_render_fallback
    component = ShadcnPhlexcomponents::Avatar.new do |avatar|
      avatar.fallback { "JD" }
    end
    output = render(component)

    assert_includes(output, "JD")
    assert_includes(output, 'data-avatar-target="fallback"')
    assert_includes(output, "bg-muted flex size-full items-center justify-center rounded-full")
  end

  def test_it_should_render_complete_avatar_structure
    component = ShadcnPhlexcomponents::Avatar.new do |avatar|
      avatar.image(src: "/user.jpg", alt: "User")
      avatar.fallback { "AB" }
    end
    output = render(component)

    # Check avatar container
    assert_includes(output, 'data-controller="avatar"')
    assert_includes(output, "relative flex size-8 shrink-0")

    # Check image
    assert_includes(output, 'src="/user.jpg"')
    assert_includes(output, 'data-avatar-target="image"')
    assert_includes(output, "aspect-square size-full")

    # Check fallback
    assert_includes(output, "AB")
    assert_includes(output, 'data-avatar-target="fallback"')
    assert_includes(output, "bg-muted flex size-full")
  end
end

class TestAvatarImage < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AvatarImage.new(src: "/avatar.jpg", alt: "Avatar")
    output = render(component)

    assert_includes(output, 'src="/avatar.jpg"')
    assert_includes(output, 'alt="Avatar"')
    assert_includes(output, 'data-avatar-target="image"')
    assert_includes(output, "aspect-square size-full")
    assert_match(/<img[^>]*>/, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AvatarImage.new(
      src: "/user.png",
      alt: "User",
      class: "image-class",
      id: "image-id",
      data: { testid: "avatar-image" },
    )
    output = render(component)

    assert_includes(output, "image-class")
    assert_includes(output, 'id="image-id"')
    assert_includes(output, 'data-testid="avatar-image"')
    assert_includes(output, 'data-avatar-target="image"')
    assert_includes(output, "aspect-square size-full")
  end

  def test_it_should_render_with_loading_attribute
    component = ShadcnPhlexcomponents::AvatarImage.new(src: "/avatar.jpg", alt: "Avatar", loading: "lazy")
    output = render(component)

    assert_includes(output, 'loading="lazy"')
    assert_includes(output, 'src="/avatar.jpg"')
  end
end

class TestAvatarFallback < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::AvatarFallback.new { "JD" }
    output = render(component)

    assert_includes(output, "JD")
    assert_includes(output, 'data-avatar-target="fallback"')
    assert_includes(output, "bg-muted flex size-full items-center justify-center rounded-full")
    assert_match(%r{<span[^>]*>JD</span>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::AvatarFallback.new(
      class: "fallback-class",
      id: "fallback-id",
      data: { testid: "avatar-fallback" },
    ) { "AB" }
    output = render(component)

    assert_includes(output, "fallback-class")
    assert_includes(output, 'id="fallback-id"')
    assert_includes(output, 'data-testid="avatar-fallback"')
    assert_includes(output, 'data-avatar-target="fallback"')
    assert_includes(output, "AB")
  end

  def test_it_should_render_with_icon
    component = ShadcnPhlexcomponents::AvatarFallback.new do
      "👤" # Simple icon placeholder
    end
    output = render(component)

    assert_includes(output, "👤")
    assert_includes(output, 'data-avatar-target="fallback"')
    assert_includes(output, "bg-muted flex size-full")
  end
end

class TestAvatarWithCustomConfiguration < ComponentTest
  def test_avatar_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.avatar = {
      root: {
        base: "custom-avatar-base",
      },
      image: {
        base: "custom-image-base",
      },
      fallback: {
        base: "custom-fallback-base",
      },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload the Avatar classes to pick up the new configuration
    ["AvatarFallback", "AvatarImage", "Avatar"].each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/avatar.rb", __dir__))

    # Test Avatar with custom configuration
    avatar_component = ShadcnPhlexcomponents::Avatar.new { "Custom avatar" }
    avatar_output = render(avatar_component)
    assert_includes(avatar_output, "custom-avatar-base")

    # Test AvatarImage with custom configuration
    image_component = ShadcnPhlexcomponents::AvatarImage.new(src: "/test.jpg", alt: "Test")
    image_output = render(image_component)
    assert_includes(image_output, "custom-image-base")

    # Test AvatarFallback with custom configuration
    fallback_component = ShadcnPhlexcomponents::AvatarFallback.new { "FB" }
    fallback_output = render(fallback_component)
    assert_includes(fallback_output, "custom-fallback-base")
  ensure
    # Restore and reload classes
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    ["AvatarFallback", "AvatarImage", "Avatar"].each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/avatar.rb", __dir__))
  end
end

class TestAvatarIntegration < ComponentTest
  def test_complete_avatar_with_image_and_fallback
    component = ShadcnPhlexcomponents::Avatar.new do |avatar|
      avatar.image(src: "/users/john-doe.jpg", alt: "John Doe", loading: "lazy")
      avatar.fallback { "JD" }
    end

    output = render(component)

    # Check avatar container with Stimulus controller
    assert_includes(output, 'data-controller="avatar"')
    assert_includes(output, "relative flex size-8 shrink-0 overflow-hidden rounded-full")

    # Check image with proper attributes and Stimulus target
    assert_includes(output, 'src="/users/john-doe.jpg"')
    assert_includes(output, 'alt="John Doe"')
    assert_includes(output, 'loading="lazy"')
    assert_includes(output, 'data-avatar-target="image"')
    assert_includes(output, "aspect-square size-full")

    # Check fallback with Stimulus target
    assert_includes(output, "JD")
    assert_includes(output, 'data-avatar-target="fallback"')
    assert_includes(output, "bg-muted flex size-full items-center justify-center rounded-full")

    # Verify proper nesting structure
    assert_match(%r{<span[^>]*data-controller="avatar"[^>]*>.*<img[^>]*data-avatar-target="image"[^>]*>.*<span[^>]*data-avatar-target="fallback"[^>]*>JD</span>.*</span>}m, output)
  end

  def test_avatar_with_fallback_icon
    component = ShadcnPhlexcomponents::Avatar.new do |avatar|
      avatar.image(src: "/broken-image.jpg", alt: "Broken")
      avatar.fallback(class: "text-muted-foreground") do
        "👤"
      end
    end

    output = render(component)

    # Check Stimulus setup
    assert_includes(output, 'data-controller="avatar"')
    assert_includes(output, 'data-avatar-target="image"')
    assert_includes(output, 'data-avatar-target="fallback"')

    # Check icon fallback
    assert_includes(output, "👤")
    assert_includes(output, "text-muted-foreground")
  end

  def test_avatar_sizes_and_styling
    component = ShadcnPhlexcomponents::Avatar.new(class: "size-16") do |avatar|
      avatar.image(src: "/large-avatar.jpg", alt: "Large Avatar", class: "object-cover")
      avatar.fallback(class: "text-lg font-bold") { "LA" }
    end

    output = render(component)

    # Check custom sizing
    assert_includes(output, "size-16")
    assert_includes(output, "object-cover")
    assert_includes(output, "text-lg font-bold")

    # Still maintains base classes
    assert_includes(output, "relative flex")
    assert_includes(output, "aspect-square")
    assert_includes(output, "bg-muted")
  end
end
