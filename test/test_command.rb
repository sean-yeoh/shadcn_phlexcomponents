# frozen_string_literal: true

require "test_helper"

class TestCommand < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::Command.new(
      modifier_key: :ctrl,
      shortcut_key: "k",
    ) { "Command content" }
    output = render(component)

    assert_includes(output, "Command content")
    assert_includes(output, "inline-flex max-w-fit")
    assert_includes(output, 'data-shadcn-phlexcomponents="command"')
    assert_includes(output, 'data-controller="command"')
    assert_includes(output, 'data-modifier-key="ctrl"')
    assert_includes(output, 'data-shortcut-key="k"')
    assert_match(%r{<div[^>]*>.*Command content.*</div>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::Command.new(
      class: "custom-command",
      id: "command-id",
      data: { testid: "command" },
    ) { "Custom content" }
    output = render(component)

    assert_includes(output, "custom-command")
    assert_includes(output, 'id="command-id"')
    assert_includes(output, 'data-testid="command"')
    assert_includes(output, "inline-flex max-w-fit")
  end

  def test_it_should_validate_modifier_key
    valid_keys = [:ctrl, :alt, :shift]

    valid_keys.each do |key|
      component = ShadcnPhlexcomponents::Command.new(modifier_key: key) { "Test" }
      begin
        render(component)
      rescue => e
        flunk("Should accept #{key} but raised: #{e.message}")
      end
    end

    assert_raises(ArgumentError) do
      ShadcnPhlexcomponents::Command.new(modifier_key: :invalid)
    end
  end

  def test_it_should_handle_search_configuration
    component = ShadcnPhlexcomponents::Command.new(
      search_path: "/api/search",
      search_error_text: "Custom error message",
      search_empty_text: "Custom empty message",
      search_placeholder_text: "Custom placeholder",
    ) { "Content" }
    output = render(component)

    assert_includes(output, 'data-search-path="/api/search"')
    assert_includes(output, 'data-controller="command"')
  end

  def test_it_should_generate_unique_aria_id
    component1 = ShadcnPhlexcomponents::Command.new do |command|
      command.trigger { "Trigger 1" }
      command.content { "Content 1" }
    end
    output1 = render(component1)

    component2 = ShadcnPhlexcomponents::Command.new do |command|
      command.trigger { "Trigger 2" }
      command.content { "Content 2" }
    end
    output2 = render(component2)

    # Extract aria-controls values to ensure they're different
    controls1 = output1[/aria-controls="([^"]*)"/, 1]
    controls2 = output2[/aria-controls="([^"]*)"/, 1]

    refute_nil(controls1)
    refute_nil(controls2)
    refute_equal(controls1, controls2)
  end

  def test_it_should_handle_open_state
    component = ShadcnPhlexcomponents::Command.new(open: true) { "Content" }
    output = render(component)

    assert_includes(output, 'data-command-is-open-value="true"')
  end

  def test_it_should_include_overlay
    component = ShadcnPhlexcomponents::Command.new { "Content" }
    output = render(component)

    # The overlay doesn't have shadcn-phlexcomponents attribute, just check for overlay target
    assert_includes(output, 'data-command-target="overlay"')
    assert_includes(output, 'data-state="closed"')
  end

  def test_it_should_render_with_helper_methods
    component = ShadcnPhlexcomponents::Command.new(
      modifier_key: :ctrl,
      shortcut_key: "k",
    ) do |command|
      command.trigger(class: "custom-trigger") { "Search..." }
      command.content(class: "custom-content") do
        command.group do
          command.label { "Commands" }
          command.item(value: "item1") { "Item 1" }
          command.item(value: "item2") { "Item 2" }
        end
      end
    end
    output = render(component)

    # Check trigger
    assert_includes(output, "Search...")
    assert_includes(output, "custom-trigger")
    assert_includes(output, 'role="button"')
    assert_includes(output, 'data-command-target="trigger"')

    # Check content
    assert_includes(output, "custom-content")
    assert_includes(output, 'role="dialog"')
    assert_includes(output, 'data-command-target="content"')

    # Check group and items
    assert_includes(output, "Commands")
    assert_includes(output, "Item 1")
    assert_includes(output, "Item 2")
    assert_includes(output, 'role="group"')
    assert_includes(output, 'role="option"')
  end

  def test_it_should_render_complete_command_structure
    component = ShadcnPhlexcomponents::Command.new(
      modifier_key: :ctrl,
      shortcut_key: "k",
      open: false,
      search_path: "/search",
      class: "full-command",
    ) do |command|
      command.trigger(class: "trigger-style") { "Search anything..." }
      command.content(class: "content-style") do
        command.group do
          command.label { "Actions" }
          command.item(value: "create") { "Create new" }
          command.item(value: "edit") { "Edit" }
        end
      end
    end
    output = render(component)

    # Check main container
    assert_includes(output, "full-command")
    assert_includes(output, 'data-controller="command"')
    assert_includes(output, 'data-search-path="/search"')
    assert_includes(output, 'data-command-is-open-value="false"')

    # Check trigger with keyboard shortcuts
    assert_includes(output, "Search anything...")
    assert_includes(output, "trigger-style")
    assert_includes(output, "ctrl")

    # Check content and search functionality
    assert_includes(output, "content-style")
    assert_includes(output, 'role="dialog"')
    assert_includes(output, 'data-command-target="searchInput"')

    # Check group and items
    assert_includes(output, "Actions")
    assert_includes(output, "Create new")
    assert_includes(output, "Edit")
    assert_includes(output, 'data-value="create"')
    assert_includes(output, 'data-value="edit"')
  end
end

class TestCommandTrigger < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::CommandTrigger.new(
      modifier_key: :ctrl,
      shortcut_key: "k",
      aria_id: "test-command",
    ) { "Trigger content" }
    output = render(component)

    assert_includes(output, "Trigger content")
    assert_includes(output, 'data-shadcn-phlexcomponents="command-trigger"')
    assert_includes(output, 'role="button"')
    assert_includes(output, 'aria-controls="test-command-content"')
    assert_includes(output, 'data-command-target="trigger"')
    assert_match(%r{<button[^>]*>.*Trigger content.*</button>}m, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::CommandTrigger.new(
      aria_id: "custom-test",
      class: "custom-trigger",
      id: "trigger-id",
    ) { "Custom trigger content" }
    output = render(component)

    assert_includes(output, "custom-trigger")
    assert_includes(output, 'id="trigger-id"')
    assert_includes(output, 'aria-controls="custom-test-content"')
  end

  def test_it_should_include_keyboard_shortcuts
    component = ShadcnPhlexcomponents::CommandTrigger.new(
      modifier_key: :ctrl,
      shortcut_key: "k",
      aria_id: "test",
    ) { "Search" }
    output = render(component)

    assert_includes(output, "ctrl")
    assert_includes(output, "k")
    assert_includes(output, 'data-command-target="modifierKey"')
    assert_includes(output, "capitalize")
  end

  def test_it_should_handle_single_modifier_key
    component = ShadcnPhlexcomponents::CommandTrigger.new(
      modifier_key: :alt,
      aria_id: "test",
    ) { "Search" }
    output = render(component)

    assert_includes(output, "alt")
    refute_includes(output, "shortcut_key")
  end

  def test_it_should_handle_single_shortcut_key
    component = ShadcnPhlexcomponents::CommandTrigger.new(
      shortcut_key: "f",
      aria_id: "test",
    ) { "Search" }
    output = render(component)

    assert_includes(output, "f")
    refute_includes(output, 'data-command-target="modifierKey"')
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::CommandTrigger.new(aria_id: "test") { "Search" }
    output = render(component)

    assert_match(/click->command#open/, output)
  end

  def test_it_should_use_button_variant_styling
    component = ShadcnPhlexcomponents::CommandTrigger.new(aria_id: "test") { "Search" }
    output = render(component)

    # Should include button styling from Button component
    assert_includes(output, "bg-surface")
    assert_includes(output, "text-surface-foreground/60")
    assert_includes(output, "relative h-8")
  end
end

class TestCommandContent < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::CommandContent.new(
      aria_id: "test-content",
    ) { "Content body" }
    output = render(component)

    assert_includes(output, "Content body")
    assert_includes(output, 'data-shadcn-phlexcomponents="command-content"')
    assert_includes(output, 'id="test-content-content"')
    assert_includes(output, 'role="dialog"')
    assert_includes(output, 'data-command-target="content"')
    assert_includes(output, 'data-state="closed"')
  end

  def test_it_should_include_search_functionality
    component = ShadcnPhlexcomponents::CommandContent.new(
      aria_id: "search-test",
      search_placeholder_text: "Search commands...",
      search_empty_text: "No results",
      search_error_text: "Error occurred",
    )
    output = render(component)

    # Check search input
    assert_includes(output, 'data-command-target="searchInput"')
    assert_includes(output, 'placeholder="Search commands..."')
    assert_includes(output, 'role="combobox"')

    # Check search states
    assert_includes(output, 'data-command-target="empty"')
    assert_includes(output, 'data-command-target="error"')
    assert_includes(output, 'data-command-target="loading"')
    assert_includes(output, "No results")
    assert_includes(output, "Error occurred")
  end

  def test_it_should_include_list_container_and_targets
    component = ShadcnPhlexcomponents::CommandContent.new(aria_id: "list-test")
    output = render(component)

    assert_includes(output, 'data-command-target="list"')
    assert_includes(output, 'data-command-target="listContainer"')
    assert_includes(output, 'id="list-test-list"')
    assert_includes(output, "max-h-80 min-h-80 overflow-y-auto")
  end

  def test_it_should_include_accessibility_features
    component = ShadcnPhlexcomponents::CommandContent.new(
      aria_id: "a11y-test",
      search_placeholder_text: "Search...",
    )
    output = render(component)

    assert_includes(output, 'aria-describedby="a11y-test-description"')
    assert_includes(output, 'aria-labelledby="a11y-test-title"')
    assert_includes(output, 'id="a11y-test-title"')
    assert_includes(output, 'id="a11y-test-description"')
    assert_includes(output, "Search for a command to run...")
  end

  def test_it_should_include_footer
    component = ShadcnPhlexcomponents::CommandContent.new(aria_id: "footer-test")
    output = render(component)

    assert_includes(output, "Go to Page")
    # Check for SVG path - the corner-down-left icon path elements
    assert_includes(output, "9 10 4 15 9 20")
    assert_includes(output, "M20 4v7a4 4 0 0 1-4 4H4")
    assert_includes(output, 'data-shadcn-phlexcomponents="command-footer"')
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::CommandContent.new(aria_id: "action-test")
    output = render(component)

    assert_match(/command:click:outside->command#clickOutside/, output)
    assert_match(/keydown\.up->command#highlightItem:prevent/, output)
    assert_match(/keydown\.down->command#highlightItem:prevent/, output)
    assert_match(/keydown\.enter->command#select/, output)
  end
end

class TestCommandItem < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::CommandItem.new(
      value: "test_item",
      aria_id: "test-command",
    ) { "Item text" }
    output = render(component)

    assert_includes(output, "Item text")
    assert_includes(output, 'data-shadcn-phlexcomponents="command-item"')
    assert_includes(output, 'role="option"')
    assert_includes(output, 'data-value="test_item"')
    assert_includes(output, 'data-command-target="item"')
    assert_includes(output, 'data-highlighted="false"')
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::CommandItem.new(
      value: "action_item",
      aria_id: "test",
    ) { "Actionable item" }
    output = render(component)

    assert_match(/click->command#select/, output)
    assert_match(/mouseover->command#highlightItem/, output)
  end

  def test_it_should_handle_custom_styling
    component = ShadcnPhlexcomponents::CommandItem.new(
      value: "styled_item",
      aria_id: "test",
      class: "custom-item",
    ) { "Styled item" }
    output = render(component)

    assert_includes(output, "custom-item")
    assert_includes(output, "data-[highlighted=true]:text-accent-foreground")
    # The classes are there but in a different order
    assert_includes(output, "relative flex")
    assert_includes(output, "cursor-default")
  end
end

class TestCommandLabel < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::CommandLabel.new { "Label text" }
    output = render(component)

    assert_includes(output, "Label text")
    assert_includes(output, 'data-shadcn-phlexcomponents="command-label"')
    assert_includes(output, "text-muted-foreground text-xs px-3 pb-1 text-xs font-medium")
    assert_match(%r{<div[^>]*>Label text</div>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::CommandLabel.new(
      class: "custom-label",
      id: "label-id",
    ) { "Custom label" }
    output = render(component)

    assert_includes(output, "custom-label")
    assert_includes(output, 'id="label-id"')
  end
end

class TestCommandGroup < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::CommandGroup.new(
      aria_id: "test-group",
    ) { "Group content" }
    output = render(component)

    assert_includes(output, "Group content")
    assert_includes(output, 'data-shadcn-phlexcomponents="command-group"')
    assert_includes(output, 'role="group"')
    assert_includes(output, 'data-command-target="group"')
    assert_match(/aria-labelledby="test-group-group-[a-f0-9]+"/, output)
  end

  def test_it_should_include_styling
    component = ShadcnPhlexcomponents::CommandGroup.new(aria_id: "test")
    output = render(component)

    assert_includes(output, "scroll-mt-16 first:pt-0 pt-3")
  end
end

class TestCommandText < ComponentTest
  def test_it_should_render_with_target
    component = ShadcnPhlexcomponents::CommandText.new(target: "empty") { "No results" }
    output = render(component)

    assert_includes(output, "No results")
    assert_includes(output, 'data-shadcn-phlexcomponents="command-text"')
    assert_includes(output, 'role="presentation"')
    assert_includes(output, 'data-command-target="empty"')
    assert_includes(output, "py-6 text-center text-sm hidden")
  end
end

class TestCommandKbd < ComponentTest
  def test_it_should_render_keyboard_shortcut
    component = ShadcnPhlexcomponents::CommandKbd.new { "Ctrl" }
    output = render(component)

    assert_includes(output, "Ctrl")
    assert_includes(output, 'data-shadcn-phlexcomponents="command-kbd"')
    assert_includes(output, "bg-background text-muted-foreground")
    assert_includes(output, "pointer-events-none flex h-5")
    assert_match(%r{<kbd[^>]*>Ctrl</kbd>}, output)
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::CommandKbd.new(
      class: "custom-kbd",
      id: "kbd-id",
    ) { "K" }
    output = render(component)

    assert_includes(output, "custom-kbd")
    assert_includes(output, 'id="kbd-id"')
  end
end

class TestCommandFooter < ComponentTest
  def test_it_should_render_footer
    component = ShadcnPhlexcomponents::CommandFooter.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="command-footer"')
    assert_includes(output, "Go to Page")
    # Check for SVG path elements instead of icon name
    assert_includes(output, "9 10 4 15 9 20")
    assert_includes(output, "absolute inset-x-0 bottom-0")
    assert_includes(output, "text-muted-foreground")
  end
end

class TestCommandSearchInputContainer < ComponentTest
  def test_it_should_render_container
    component = ShadcnPhlexcomponents::CommandSearchInputContainer.new { "Search input" }
    output = render(component)

    assert_includes(output, "Search input")
    assert_includes(output, 'data-shadcn-phlexcomponents="command-search-input-container"')
    assert_includes(output, "flex h-9 items-center gap-2 border px-3")
    assert_includes(output, "bg-input/50 border-input rounded-md")
  end
end

class TestCommandSearchInput < ComponentTest
  def test_it_should_render_search_input
    component = ShadcnPhlexcomponents::CommandSearchInput.new(
      aria_id: "test-search",
      search_placeholder_text: "Search...",
    )
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="command-search-input"')
    assert_includes(output, 'id="test-search-search"')
    assert_includes(output, 'placeholder="Search..."')
    assert_includes(output, 'type="text"')
    assert_includes(output, 'role="combobox"')
    assert_includes(output, 'data-command-target="searchInput"')
  end

  def test_it_should_include_accessibility_attributes
    component = ShadcnPhlexcomponents::CommandSearchInput.new(
      aria_id: "a11y-test",
      search_placeholder_text: "Type to search...",
    )
    output = render(component)

    assert_includes(output, 'aria-autocomplete="list"')
    assert_includes(output, 'aria-expanded="false"')
    assert_includes(output, 'aria-controls="a11y-test-list"')
    assert_includes(output, 'aria-labelledby="a11y-test-search-label"')
    assert_includes(output, 'autocomplete="off"')
    assert_includes(output, 'spellcheck="false"')
  end

  def test_it_should_include_stimulus_actions
    component = ShadcnPhlexcomponents::CommandSearchInput.new(aria_id: "test")
    output = render(component)

    assert_match(/keydown->command#inputKeydown/, output)
    assert_match(/input->command#search/, output)
  end
end

class TestCommandListContainer < ComponentTest
  def test_it_should_render_list_container
    component = ShadcnPhlexcomponents::CommandListContainer.new { "List content" }
    output = render(component)

    assert_includes(output, "List content")
    assert_includes(output, 'data-shadcn-phlexcomponents="command-list-container"')
    assert_includes(output, 'data-command-target="listContainer"')
    assert_includes(output, "mt-3 p-1 max-h-80 min-h-80 overflow-y-auto")
  end
end

class TestCommandWithCustomConfiguration < ComponentTest
  def test_command_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.command = {
      root: { base: "custom-command-base" },
      trigger: { base: "custom-trigger-base" },
      content: { base: "custom-content-base" },
      label: { base: "custom-label-base" },
      item: { base: "custom-item-base" },
      text: { base: "custom-text-base" },
      kbd: { base: "custom-kbd-base" },
      footer: { base: "custom-footer-base" },
      group: { base: "custom-group-base" },
      search_input_container: { base: "custom-search-input-container-base" },
      search_input: { base: "custom-search-input-base" },
      list_container: { base: "custom-list-container-base" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload classes
    command_classes = [
      "CommandListContainer",
      "CommandSearchInput",
      "CommandSearchInputContainer",
      "CommandFooter",
      "CommandKbd",
      "CommandText",
      "CommandGroup",
      "CommandItem",
      "CommandLabel",
      "CommandContent",
      "CommandTrigger",
      "Command",
    ]

    command_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/command.rb", __dir__))

    # Test components with custom configuration
    command = ShadcnPhlexcomponents::Command.new { "Test" }
    assert_includes(render(command), "custom-command-base")

    # CommandTrigger uses Button styling, not direct configuration, so check for Button classes
    trigger = ShadcnPhlexcomponents::CommandTrigger.new(aria_id: "test") { "Test" }
    trigger_output = render(trigger)
    assert_includes(trigger_output, "bg-surface text-surface-foreground/60")

    content = ShadcnPhlexcomponents::CommandContent.new(aria_id: "test")
    assert_includes(render(content), "custom-content-base")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    command_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/command.rb", __dir__))
  end
end

class TestCommandIntegration < ComponentTest
  def test_complete_command_workflow
    component = ShadcnPhlexcomponents::Command.new(
      modifier_key: :ctrl,
      shortcut_key: "k",
      open: false,
      search_path: "/api/commands",
      search_placeholder_text: "Type a command...",
      search_empty_text: "No commands found",
      search_error_text: "Failed to search",
      class: "command-palette",
      data: { controller: "command analytics", analytics_category: "command-usage" },
    ) do |command|
      command.trigger(class: "search-trigger") { "🔍 Search commands..." }
      command.content(class: "command-dialog") do
        command.group do
          command.label { "🔧 Actions" }
          command.item(value: "create") { "📝 Create new item" }
          command.item(value: "edit") { "✏️ Edit current item" }
        end
        command.group do
          command.label { "🚀 Navigation" }
          command.item(value: "home") { "🏠 Go to home" }
          command.item(value: "settings") { "⚙️ Open settings" }
        end
      end
    end

    output = render(component)

    # Check main structure
    assert_includes(output, "command-palette")
    # Controller attribute merging - may include spaces
    assert_match(/data-controller="[^"]*command[^"]*analytics[^"]*"/, output)
    assert_includes(output, 'data-analytics-category="command-usage"')
    assert_includes(output, 'data-search-path="/api/commands"')

    # Check trigger with keyboard shortcuts
    assert_includes(output, "🔍 Search commands...")
    assert_includes(output, "search-trigger")
    assert_includes(output, "ctrl")
    assert_includes(output, "k")

    # Check content with search
    assert_includes(output, "command-dialog")
    assert_includes(output, 'role="dialog"')
    assert_includes(output, 'data-command-target="searchInput"')
    assert_includes(output, 'placeholder="Type a command..."')

    # Check groups and items
    assert_includes(output, "🔧 Actions")
    assert_includes(output, "🚀 Navigation")
    assert_includes(output, "📝 Create new item")
    assert_includes(output, "✏️ Edit current item")
    assert_includes(output, "🏠 Go to home")
    assert_includes(output, "⚙️ Open settings")

    # Check item values
    assert_includes(output, 'data-value="create"')
    assert_includes(output, 'data-value="edit"')
    assert_includes(output, 'data-value="home"')
    assert_includes(output, 'data-value="settings"')

    # Check search states
    assert_includes(output, "No commands found")
    assert_includes(output, "Failed to search")
  end

  def test_command_accessibility_features
    component = ShadcnPhlexcomponents::Command.new(
      modifier_key: :alt,
      shortcut_key: "c",
      aria: { label: "Command palette", describedby: "help-text" },
    ) do |command|
      command.trigger(aria: { labelledby: "command-label" }) { "Accessible trigger" }
      command.content do
        command.group do
          command.label { "Commands Group" }
          command.item(value: "option1") { "Option 1" }
          command.item(value: "option2") { "Option 2" }
        end
      end
    end

    output = render(component)

    # Check accessibility attributes
    assert_includes(output, 'aria-label="Command palette"')
    assert_includes(output, 'aria-describedby="help-text"')
    assert_includes(output, 'aria-labelledby="command-label"')

    # Check ARIA roles and relationships
    assert_includes(output, 'role="button"')
    assert_includes(output, 'role="dialog"')
    assert_includes(output, 'role="group"')
    assert_includes(output, 'role="option"')

    # Check search accessibility
    assert_includes(output, 'role="combobox"') # search input
    assert_includes(output, 'aria-autocomplete="list"')
    assert_match(/aria-controls="[^"]*-list"/, output)
    assert_match(/aria-labelledby="[^"]*-search-label"/, output)
  end

  def test_command_stimulus_integration
    component = ShadcnPhlexcomponents::Command.new(
      modifier_key: :shift,
      shortcut_key: "p",
      search_path: "/api/search",
      data: {
        controller: "command custom-command",
        custom_command_setting_value: "test",
      },
    ) do |command|
      command.trigger(
        data: { action: "click->custom-command#beforeOpen" },
      ) { "Stimulus trigger" }

      command.content do
        command.item(
          value: "item1",
          data: { action: "click->custom-command#itemSelected" },
        ) { "Custom Item" }
      end
    end

    output = render(component)

    # Check multiple controllers
    assert_match(/data-controller="command[^"]*custom-command/, output)
    assert_includes(output, 'data-custom-command-setting-value="test"')

    # Check search path
    assert_includes(output, 'data-search-path="/api/search"')

    # Check custom actions
    assert_match(/click->custom-command#beforeOpen/, output)
    assert_match(/click->custom-command#itemSelected/, output)

    # Check default command actions still work
    assert_match(/click->command#open/, output)
    assert_match(/click->command#select/, output)
  end
end
