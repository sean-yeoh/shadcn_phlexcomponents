# frozen_string_literal: true

require "test_helper"

class TestTabs < ComponentTest
  def test_it_should_render_basic_tabs
    component = ShadcnPhlexcomponents::Tabs.new(value: "tab1")
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="tabs"')
    assert_includes(output, 'data-controller="tabs"')
    assert_includes(output, 'data-tabs-active-value="tab1"')
    assert_includes(output, 'dir="ltr"')
    assert_includes(output, "flex flex-col gap-2")
    assert_match(%r{<div[^>]*>.*</div>}m, output)
  end

  def test_it_should_render_with_default_values
    component = ShadcnPhlexcomponents::Tabs.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="tabs"')
    assert_includes(output, 'data-controller="tabs"')
    assert_includes(output, 'dir="ltr"')
    assert_includes(output, "flex flex-col gap-2")
    # Should not have tabs active value when none specified
    refute_includes(output, "data-tabs-active-value")
  end

  def test_it_should_render_with_custom_attributes
    component = ShadcnPhlexcomponents::Tabs.new(
      value: "settings",
      dir: "rtl",
      class: "custom-tabs w-full",
      id: "main-tabs",
      data: { testid: "navigation-tabs" },
    )
    output = render(component)

    assert_includes(output, "custom-tabs w-full")
    assert_includes(output, 'id="main-tabs"')
    assert_includes(output, 'data-testid="navigation-tabs"')
    assert_includes(output, 'data-tabs-active-value="settings"')
    assert_includes(output, 'dir="rtl"')
  end

  def test_it_should_render_with_helper_methods
    component = ShadcnPhlexcomponents::Tabs.new(value: "home") do |tabs|
      tabs.list(class: "custom-list") do
        tabs.trigger(value: "home", class: "home-tab") { "Home" }
        tabs.trigger(value: "about", class: "about-tab") { "About" }
      end

      tabs.content(value: "home", class: "home-content") { "Home content here" }
      tabs.content(value: "about", class: "about-content") { "About content here" }
    end
    output = render(component)

    # Check tabs list
    assert_includes(output, "custom-list")
    assert_includes(output, 'role="tablist"')
    assert_includes(output, 'aria-orientation="horizontal"')

    # Check triggers
    assert_includes(output, "home-tab")
    assert_includes(output, "about-tab")
    assert_includes(output, 'role="tab"')
    assert_includes(output, 'data-tabs-target="trigger"')
    assert_includes(output, 'data-value="home"')
    assert_includes(output, 'data-value="about"')

    # Check content
    assert_includes(output, "home-content")
    assert_includes(output, "about-content")
    assert_includes(output, 'role="tabpanel"')
    assert_includes(output, 'data-tabs-target="content"')
    assert_includes(output, "Home content here")
    assert_includes(output, "About content here")
  end

  def test_it_should_generate_aria_relationships
    component = ShadcnPhlexcomponents::Tabs.new(value: "test") do |tabs|
      tabs.list do
        tabs.trigger(value: "test") { "Test Tab" }
      end
      tabs.content(value: "test") { "Test Content" }
    end
    output = render(component)

    # Extract the generated aria_id
    aria_id_match = output.match(/id="(tabs-[a-f0-9]{10})-trigger-test"/)
    assert(aria_id_match, "Should generate aria ID for trigger")

    aria_id = aria_id_match[1]

    # Check trigger attributes
    assert_includes(output, "id=\"#{aria_id}-trigger-test\"")
    assert_includes(output, "aria-controls=\"#{aria_id}-content-test\"")

    # Check content attributes
    assert_includes(output, "id=\"#{aria_id}-content-test\"")
    assert_includes(output, "aria-labelledby=\"#{aria_id}-trigger-test\"")
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::Tabs.new do |tabs|
      tabs.list do
        tabs.trigger(value: "tab1") { "Tab 1" }
      end
    end
    output = render(component)

    # Check Stimulus actions
    assert_includes(output, 'data-action="click->tabs#setActiveTab')
    assert_includes(output, "keydown.left->tabs#setActiveTab:prevent")
    assert_includes(output, "keydown.right->tabs#setActiveTab:prevent")
  end
end

class TestTabsList < ComponentTest
  def test_it_should_render_tabs_list
    component = ShadcnPhlexcomponents::TabsList.new { "Tab buttons here" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="tabs-list"')
    assert_includes(output, 'role="tablist"')
    assert_includes(output, 'tabindex="-1"')
    assert_includes(output, 'aria-orientation="horizontal"')
    assert_includes(output, "bg-muted text-muted-foreground")
    assert_includes(output, "inline-flex h-9 w-fit items-center justify-center rounded-lg p-[3px]")
    assert_includes(output, "Tab buttons here")
    assert_match(%r{<div[^>]*>.*Tab buttons here.*</div>}m, output)
  end

  def test_it_should_render_with_custom_attributes
    component = ShadcnPhlexcomponents::TabsList.new(
      class: "custom-tabs-list w-full",
      id: "tab-list",
      data: { testid: "navigation-list" },
    ) { "Custom list content" }
    output = render(component)

    assert_includes(output, "custom-tabs-list w-full")
    assert_includes(output, 'id="tab-list"')
    assert_includes(output, 'data-testid="navigation-list"')
    assert_includes(output, "Custom list content")
  end
end

class TestTabsTrigger < ComponentTest
  def test_it_should_render_tabs_trigger
    component = ShadcnPhlexcomponents::TabsTrigger.new(
      value: "settings",
      aria_id: "tabs-12345",
    ) { "Settings" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="tabs-trigger"')
    assert_includes(output, 'id="tabs-12345-trigger-settings"')
    assert_includes(output, 'role="tab"')
    assert_includes(output, 'tabindex="-1"')
    assert_includes(output, 'aria-controls="tabs-12345-content-settings"')
    # TabsTrigger doesn't include aria-selected in default attributes - that would be in the component class vars
    assert_includes(output, 'data-tabs-target="trigger"')
    assert_includes(output, 'data-value="settings"')
    assert_includes(output, 'data-state="inactive"')
    assert_includes(output, "Settings")
    assert_match(%r{<button[^>]*>.*Settings.*</button>}m, output)
  end

  def test_it_should_render_with_styling_classes
    component = ShadcnPhlexcomponents::TabsTrigger.new(
      value: "test",
      aria_id: "tabs-test",
    ) { "Test" }
    output = render(component)

    assert_includes(output, "data-[state=active]:bg-background")
    assert_includes(output, "focus-visible:border-ring")
    assert_includes(output, "focus-visible:ring-ring/50")
    assert_includes(output, "inline-flex")
    assert_includes(output, "items-center justify-center gap-1.5")
    assert_includes(output, "rounded-md border border-transparent")
    assert_includes(output, "px-2 py-1")
    assert_includes(output, "text-sm")
    assert_includes(output, "font-medium")
    assert_includes(output, "transition-[color,box-shadow]")
    assert_includes(output, "disabled:pointer-events-none disabled:opacity-50")
  end

  def test_it_should_render_with_custom_attributes
    component = ShadcnPhlexcomponents::TabsTrigger.new(
      value: "custom",
      aria_id: "tabs-custom",
      class: "custom-trigger",
      id: "trigger-id",
      data: { testid: "custom-tab" },
    ) { "Custom Tab" }
    output = render(component)

    assert_includes(output, "custom-trigger")
    # The id gets generated as part of the aria_id system
    assert_includes(output, "trigger-id")
    assert_includes(output, 'data-testid="custom-tab"')
    assert_includes(output, "Custom Tab")
  end
end

class TestTabsContent < ComponentTest
  def test_it_should_render_tabs_content
    component = ShadcnPhlexcomponents::TabsContent.new(
      value: "profile",
      aria_id: "tabs-67890",
    ) { "Profile content here" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="tabs-content"')
    assert_includes(output, 'id="tabs-67890-content-profile"')
    assert_includes(output, 'role="tabpanel"')
    assert_includes(output, 'tabindex="0"')
    assert_includes(output, 'aria-labelledby="tabs-67890-trigger-profile"')
    assert_includes(output, 'data-value="profile"')
    assert_includes(output, 'data-tabs-target="content"')
    assert_includes(output, "flex-1 outline-none")
    assert_includes(output, "Profile content here")
    assert_match(%r{<div[^>]*>.*Profile content here.*</div>}m, output)
  end

  def test_it_should_render_with_custom_attributes
    component = ShadcnPhlexcomponents::TabsContent.new(
      value: "custom",
      aria_id: "tabs-custom",
      class: "custom-content p-4",
      id: "content-id",
      data: { testid: "custom-content" },
    ) { "Custom content" }
    output = render(component)

    assert_includes(output, "custom-content p-4")
    # The id gets generated as part of the aria_id system
    assert_includes(output, "content-id")
    assert_includes(output, 'data-testid="custom-content"')
    assert_includes(output, "Custom content")
  end
end

class TestTabsWithCustomConfiguration < ComponentTest
  def test_tabs_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.tabs = {
      root: { base: "custom-tabs-base grid gap-4" },
      list: { base: "custom-list-base bg-blue-100 rounded-xl" },
      trigger: { base: "custom-trigger-base bg-white hover:bg-gray-50" },
      content: { base: "custom-content-base p-6 bg-gray-50" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    tabs_classes = ["TabsContent", "TabsTrigger", "TabsList", "Tabs"]

    tabs_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/tabs.rb", __dir__))

    # Test components with custom configuration
    tabs = ShadcnPhlexcomponents::Tabs.new(value: "test")
    tabs_output = render(tabs)
    assert_includes(tabs_output, "custom-tabs-base")
    assert_includes(tabs_output, "grid gap-4")

    list = ShadcnPhlexcomponents::TabsList.new { "Test" }
    list_output = render(list)
    assert_includes(list_output, "custom-list-base")
    assert_includes(list_output, "bg-blue-100 rounded-xl")

    trigger = ShadcnPhlexcomponents::TabsTrigger.new(value: "test", aria_id: "test") { "Test" }
    trigger_output = render(trigger)
    assert_includes(trigger_output, "custom-trigger-base")
    assert_includes(trigger_output, "bg-white hover:bg-gray-50")

    content = ShadcnPhlexcomponents::TabsContent.new(value: "test", aria_id: "test") { "Test" }
    content_output = render(content)
    assert_includes(content_output, "custom-content-base")
    assert_includes(content_output, "p-6 bg-gray-50")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    tabs_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/tabs.rb", __dir__))
  end
end

class TestTabsIntegration < ComponentTest
  def test_settings_tabs_workflow
    component = ShadcnPhlexcomponents::Tabs.new(
      value: "general",
      class: "settings-tabs w-full max-w-2xl",
      data: {
        controller: "tabs settings-manager",
        settings_manager_target: "tabContainer",
        settings_manager_auto_save: "true",
      },
    ) do |tabs|
      tabs.list(class: "grid w-full grid-cols-3") do
        tabs.trigger(
          value: "general",
          class: "settings-tab",
          data: {
            settings_manager_section: "general",
            action: "click->tabs#setActiveTab click->settings-manager#loadSection",
          },
        ) { "🔧 General" }

        tabs.trigger(
          value: "account",
          class: "settings-tab",
          data: {
            settings_manager_section: "account",
            action: "click->tabs#setActiveTab click->settings-manager#loadSection",
          },
        ) { "👤 Account" }

        tabs.trigger(
          value: "privacy",
          class: "settings-tab",
          data: {
            settings_manager_section: "privacy",
            action: "click->tabs#setActiveTab click->settings-manager#loadSection",
          },
        ) { "🔒 Privacy" }
      end

      tabs.content(
        value: "general",
        class: "settings-content mt-6",
        data: { settings_manager_target: "generalSection" },
      ) { "General settings form goes here..." }

      tabs.content(
        value: "account",
        class: "settings-content mt-6",
        data: { settings_manager_target: "accountSection" },
      ) { "Account settings form goes here..." }

      tabs.content(
        value: "privacy",
        class: "settings-content mt-6",
        data: { settings_manager_target: "privacySection" },
      ) { "Privacy settings form goes here..." }
    end
    output = render(component)

    # Check main tabs structure
    assert_includes(output, "settings-tabs w-full max-w-2xl")
    assert_match(/data-controller="[^"]*tabs[^"]*settings-manager[^"]*"/, output)
    assert_includes(output, 'data-settings-manager-target="tabContainer"')
    assert_includes(output, 'data-settings-manager-auto-save="true"')
    assert_includes(output, 'data-tabs-active-value="general"')

    # Check tabs list layout
    assert_includes(output, "grid w-full grid-cols-3")

    # Check all tabs with icons
    assert_includes(output, "🔧 General")
    assert_includes(output, "👤 Account")
    assert_includes(output, "🔒 Privacy")

    # Check custom actions
    assert_includes(output, 'data-settings-manager-section="general"')
    assert_includes(output, "settings-manager#loadSection")

    # Check content sections
    assert_includes(output, "settings-content mt-6")
    assert_includes(output, 'data-settings-manager-target="generalSection"')
    assert_includes(output, "General settings form goes here...")
    assert_includes(output, "Account settings form goes here...")
    assert_includes(output, "Privacy settings form goes here...")
  end

  def test_documentation_tabs
    component = ShadcnPhlexcomponents::Tabs.new(
      value: "overview",
      class: "documentation-tabs border rounded-lg",
    ) do |tabs|
      tabs.list(class: "border-b px-6") do
        tabs.trigger(value: "overview") { "📖 Overview" }
        tabs.trigger(value: "api") { "⚡ API" }
        tabs.trigger(value: "examples") { "💡 Examples" }
        tabs.trigger(value: "changelog") { "📝 Changelog" }
      end

      tabs.content(value: "overview", class: "p-6") do
        "# Component Overview\n\nThis component provides..."
      end

      tabs.content(value: "api", class: "p-6") do
        "## API Reference\n\n### Props\n\n- `value`: string..."
      end

      tabs.content(value: "examples", class: "p-6") do
        "## Examples\n\n### Basic Usage\n\n```ruby\nTabs.new..."
      end

      tabs.content(value: "changelog", class: "p-6") do
        "## Changelog\n\n### v1.2.0\n\n- Added new features..."
      end
    end
    output = render(component)

    # Check documentation structure
    assert_includes(output, "documentation-tabs border rounded-lg")
    assert_includes(output, "border-b px-6")

    # Check all documentation sections
    ["📖 Overview", "⚡ API", "💡 Examples", "📝 Changelog"].each do |tab_text|
      assert_includes(output, tab_text)
    end

    # Check content formatting
    assert_includes(output, "# Component Overview")
    assert_includes(output, "## API Reference")
    assert_includes(output, "## Examples")
    assert_includes(output, "## Changelog")
    assert_includes(output, "```ruby")
  end

  def test_dashboard_tabs_with_counters
    stats = { users: 156, orders: 23, revenue: 1250 }

    component = ShadcnPhlexcomponents::Tabs.new(
      value: "users",
      class: "dashboard-tabs",
      data: {
        controller: "tabs dashboard-stats",
        dashboard_stats_target: "tabsContainer",
      },
    ) do |tabs|
      tabs.list(class: "justify-start") do
        tabs.trigger(
          value: "users",
          class: "gap-2",
          data: { dashboard_stats_metric: "users" },
        ) { "👥 Users <span class=\"ml-1 rounded-full bg-blue-100 px-2 py-0.5 text-xs text-blue-800\">#{stats[:users]}</span>" }

        tabs.trigger(
          value: "orders",
          class: "gap-2",
          data: { dashboard_stats_metric: "orders" },
        ) { "📦 Orders <span class=\"ml-1 rounded-full bg-green-100 px-2 py-0.5 text-xs text-green-800\">#{stats[:orders]}</span>" }

        tabs.trigger(
          value: "revenue",
          class: "gap-2",
          data: { dashboard_stats_metric: "revenue" },
        ) { "💰 Revenue <span class=\"ml-1 rounded-full bg-purple-100 px-2 py-0.5 text-xs text-purple-800\">$#{stats[:revenue]}</span>" }
      end

      tabs.content(value: "users", class: "dashboard-content") do
        "<div class=\"grid grid-cols-2 gap-4\">User analytics charts...</div>"
      end

      tabs.content(value: "orders", class: "dashboard-content") do
        "<div class=\"space-y-4\">Order management interface...</div>"
      end

      tabs.content(value: "revenue", class: "dashboard-content") do
        "<div class=\"flex flex-col gap-6\">Revenue tracking dashboard...</div>"
      end
    end
    output = render(component)

    # Check dashboard structure
    assert_includes(output, "dashboard-tabs")
    assert_match(/data-controller="[^"]*tabs[^"]*dashboard-stats[^"]*"/, output)
    assert_includes(output, 'data-dashboard-stats-target="tabsContainer"')

    # Check counter badges
    assert_includes(output, "rounded-full bg-blue-100 px-2 py-0.5 text-xs text-blue-800")
    assert_includes(output, "156")
    assert_includes(output, "23")
    assert_includes(output, "$1250")

    # Check metric data attributes
    assert_includes(output, 'data-dashboard-stats-metric="users"')
    assert_includes(output, 'data-dashboard-stats-metric="orders"')
    assert_includes(output, 'data-dashboard-stats-metric="revenue"')

    # Check content layouts
    assert_includes(output, "grid grid-cols-2 gap-4")
    assert_includes(output, "space-y-4")
    assert_includes(output, "flex flex-col gap-6")
  end

  def test_mobile_responsive_tabs
    component = ShadcnPhlexcomponents::Tabs.new(
      value: "home",
      class: "mobile-tabs w-full",
      data: {
        controller: "tabs responsive-tabs",
        responsive_tabs_mobile_breakpoint: "640",
      },
    ) do |tabs|
      tabs.list(class: "w-full justify-between sm:justify-start overflow-x-auto") do
        tabs.trigger(
          value: "home",
          class: "flex-shrink-0 min-w-0 sm:min-w-fit",
          data: { responsive_tabs_section: "home" },
        ) { "🏠 Home" }

        tabs.trigger(
          value: "search",
          class: "flex-shrink-0 min-w-0 sm:min-w-fit",
          data: { responsive_tabs_section: "search" },
        ) { "🔍 Search" }

        tabs.trigger(
          value: "profile",
          class: "flex-shrink-0 min-w-0 sm:min-w-fit",
          data: { responsive_tabs_section: "profile" },
        ) { "👤 Profile" }

        tabs.trigger(
          value: "settings",
          class: "flex-shrink-0 min-w-0 sm:min-w-fit",
          data: { responsive_tabs_section: "settings" },
        ) { "⚙️ Settings" }
      end

      tabs.content(value: "home", class: "p-4 sm:p-6") { "Home feed content..." }
      tabs.content(value: "search", class: "p-4 sm:p-6") { "Search interface..." }
      tabs.content(value: "profile", class: "p-4 sm:p-6") { "User profile..." }
      tabs.content(value: "settings", class: "p-4 sm:p-6") { "Settings panel..." }
    end
    output = render(component)

    # Check responsive structure
    assert_includes(output, "mobile-tabs w-full")
    assert_match(/data-controller="[^"]*tabs[^"]*responsive-tabs[^"]*"/, output)
    assert_includes(output, 'data-responsive-tabs-mobile-breakpoint="640"')

    # Check responsive list classes
    assert_includes(output, "w-full justify-between sm:justify-start overflow-x-auto")
    assert_includes(output, "flex-shrink-0 min-w-0 sm:min-w-fit")

    # Check responsive content padding
    assert_includes(output, "p-4 sm:p-6")

    # Check all mobile navigation items
    ["🏠 Home", "🔍 Search", "👤 Profile", "⚙️ Settings"].each do |nav_text|
      assert_includes(output, nav_text)
    end
  end
end
