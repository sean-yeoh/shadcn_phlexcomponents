# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Command < Base
    class_variants(base: "inline-flex max-w-fit")

    MODIFIER_KEYS = [
      :ctrl,
      :alt,
      :shift,
    ]

    def initialize(
      open: false,
      modifier_key: nil,
      shortcut_key: nil,
      search_path: nil,
      search_error_text: "Something went wrong, please try again.",
      search_empty_text: "No results found",
      search_placeholder_text: "Search...",
      **attributes
    )
      if modifier_key && !MODIFIER_KEYS.include?(modifier_key)
        raise ArgumentError, "Expected one of #{MODIFIER_KEYS} for \"modifier_key\", got #{modifier_key}"
      end

      @open = open
      @modifier_key = modifier_key
      @shortcut_key = shortcut_key
      @search_path = search_path
      @search_error_text = search_error_text
      @search_empty_text = search_empty_text
      @search_placeholder_text = search_placeholder_text
      @aria_id = "command-#{SecureRandom.hex(5)}"
      super(**attributes)
    end

    def trigger(**attributes, &)
      CommandTrigger(modifier_key: @modifier_key, shortcut_key: @shortcut_key, aria_id: @aria_id, **attributes, &)
    end

    def content(**attributes, &)
      CommandContent(
        search_error_text: @search_error_text,
        search_empty_text: @search_empty_text,
        search_placeholder_text: @search_placeholder_text,
        aria_id: @aria_id,
        **attributes,
        &
      )
    end

    def item(**attributes, &)
      CommandItem(aria_id: @aria_id, **attributes, &)
    end

    def label(**attributes, &)
      CommandLabel(**attributes, &)
    end

    def group(**attributes, &)
      CommandGroup(aria_id: @aria_id, **attributes, &)
    end

    def default_attributes
      {
        data: {
          controller: "command",
          command_is_open_value: @open.to_s,
          modifier_key: @modifier_key,
          shortcut_key: @shortcut_key,
          search_path: @search_path,
        },
      }
    end

    def view_template(&)
      div(**@attributes) do
        overlay("command")

        yield
      end
    end
  end

  class CommandTrigger < Base
    def initialize(modifier_key: nil, shortcut_key: nil, aria_id: nil, **attributes)
      @modifier_key = modifier_key
      @shortcut_key = shortcut_key
      @aria_id = aria_id
      super(**attributes)
    end

    def class_variants(**args)
      Button.new.class_variants(
        variant: :secondary,
        class: <<~HEREDOC,
          bg-surface text-surface-foreground/60 dark:bg-card relative h-8 w-full justify-start pl-2.5 font-normal
          shadow-none sm:pr-12 md:w-40 lg:w-56 xl:w-64 #{args[:class]}
        HEREDOC
      )
    end

    def default_attributes
      {
        role: "button",
        aria: {
          haspopup: "dialog",
          expanded: "false",
          controls: "#{@aria_id}-content",
        },
        data: {
          command_target: "trigger",
          action: "click->command#open",
        },
      }
    end

    def view_template(&)
      button(**@attributes) do
        yield

        if @modifier_key || @shortcut_key
          span(class: "absolute top-1.5 right-1.5 hidden gap-1 sm:flex") do
            if @modifier_key
              CommandKbd(class: "capitalize", data: { command_target: "modifierKey" }) { @modifier_key }
            end

            if @shortcut_key
              CommandKbd(class: "capitalize") { @shortcut_key }
            end
          end
        end
      end
    end
  end

  class CommandContent < Base
    class_variants(
      base: <<~HEREDOC,
        bg-background bg-clip-padding dark:bg-neutral-900 dark:ring-neutral-800 data-[state=closed]:animate-out#{" "}
        data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 data-[state=open]:animate-in data-[state=open]:fade-in-0
        data-[state=open]:zoom-in-95 duration-200 fixed gap-4 grid left-[50%] max-w-[calc(100%-2rem)] p-2 pb-11 ring-4 ring-neutral-200/80
        rounded-xl shadow-2xl sm:max-w-lg top-[50%] translate-x-[-50%] translate-y-[-50%] w-full z-50 pointer-events-auto outline-none
      HEREDOC
    )

    def initialize(
      search_error_text: nil,
      search_empty_text: nil,
      search_placeholder_text: nil,
      aria_id: nil,
      **attributes
    )
      @search_error_text = search_error_text
      @search_empty_text = search_empty_text
      @search_placeholder_text = search_placeholder_text
      @aria_id = aria_id
      super(**attributes)
    end

    def default_attributes
      {
        style: { display: "none" },
        id: "#{@aria_id}-content",
        tabindex: -1,
        role: "dialog",
        aria: {
          describedby: "#{@aria_id}-description",
          labelledby: "#{@aria_id}-title",
        },
        data: {
          state: "closed",
          command_target: "content",
          action: <<~HEREDOC,
            command:click:outside->command#clickOutside
            keydown.up->command#highlightItem:prevent
            keydown.down->command#highlightItem:prevent
            keydown.enter->command#select
          HEREDOC
        },
      }
    end

    def view_template(&)
      div(**@attributes) do
        template do
          CommandGroup do
            CommandLabel { "" }
          end
        end

        div(class: "text-popover-foreground flex h-full w-full flex-col overflow-hidden bg-transparent") do
          div(class: "sr-only") do
            h2(id: "#{@aria_id}-title") { @search_placeholder_text }
            p(id: "#{@aria_id}-description") { "Search for a command to run..." }
          end

          label(
            class: "sr-only",
            id: "#{@aria_id}-search-label",
            for: "#{@aria_id}-search",
          ) { @search_placeholder_text }

          div(class: "flex h-9 items-center gap-2 border px-3 bg-input/50 border-input rounded-md") do
            icon("search", class: "size-4 shrink-0 opacity-50")

            input(
              class: "placeholder:text-muted-foreground flex w-full rounded-md bg-transparent py-3 text-sm
              outline-hidden disabled:cursor-not-allowed disabled:opacity-50 h-9",
              id: "#{@aria_id}-search",
              placeholder: @search_placeholder_text,
              type: :text,
              autocomplete: "off",
              autocorrect: "off",
              role: "combobox",
              spellcheck: "false",
              aria: {
                autocomplete: "list",
                expanded: "false",
                controls: "#{@aria_id}-list",
                labelledby: "#{@aria_id}-search-label",
              },
              data: {
                command_target: "searchInput",
                action: "keydown->command#inputKeydown input->command#search",
              },
            )
          end

          div(class: "mt-3 p-1 max-h-80 min-h-80 overflow-y-auto", data: { command_target: "listContainer" }) do
            CommandText(target: "empty") { @search_empty_text }
            CommandText(target: "error") { @search_error_text }
            CommandText(target: "loading") do
              div(class: "flex justify-center", aria: { label: "Loading" }) do
                icon("loader-circle", class: "animate-spin")
              end
            end

            div(id: "#{@aria_id}-list", data: { command_target: "list" }, &)
          end

          CommandFooter()
        end
      end
    end
  end

  class CommandItem < Base
    class_variants(
      base: <<~HEREDOC,
        data-[highlighted=true]:text-accent-foreground [&_svg:not([class*='text-'])]:text-muted-foreground relative flex
        cursor-default items-center gap-2 px-3 py-1.5 text-sm outline-hidden select-none data-[disabled=true]:pointer-events-none
        data-[disabled=true]:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4
        data-[highlighted=true]:border-input data-[highlighted=true]:bg-input/50 h-9 rounded-md border border-transparent
        font-medium
      HEREDOC
    )

    def initialize(value: nil, aria_id: nil, **attributes)
      @value = value
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      div(**@attributes, &)
    end

    def default_attributes
      {
        role: "option",
        tabindex: -1,
        aria: {
          labelledby: @aria_labelledby,
        },
        data: {
          highlighted: "false",
          disabled: @disabled,
          value: @value,
          action: <<~HEREDOC,
            click->command#select
            mouseover->command#highlightItem
          HEREDOC
          command_target: "item",
        },
      }
    end
  end

  class CommandLabel < Base
    class_variants(base: "text-muted-foreground text-xs px-3 pb-1 text-xs font-medium")

    def initialize(**attributes)
      super(**attributes)
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class CommandGroup < Base
    class_variants(base: "scroll-mt-16 first:pt-0 pt-3")

    def initialize(aria_id: nil, **attributes)
      @aria_id = aria_id
      super(**attributes)
    end

    def view_template(&)
      div(**@attributes, &)
    end

    def default_attributes
      {
        role: "group",
        aria: {
          labelledby: "#{@aria_id}-group-#{SecureRandom.hex(5)}",
        },
        data: {
          command_target: "group",
        },
      }
    end
  end

  class CommandText < Base
    class_variants(base: "py-6 text-center text-sm hidden")

    def initialize(target:, **attributes)
      @target = target
      super(**attributes)
    end

    def default_attributes
      {
        role: "presentation",
        data: { command_target: @target },
      }
    end

    def view_template(&)
      div(**@attributes, &)
    end
  end

  class CommandKbd < Base
    class_variants(
      base: <<~HEREDOC,
        bg-background text-muted-foreground pointer-events-none flex h-5 items-center justify-center gap-1 rounded
        border px-1 font-sans text-[0.7rem] font-medium select-none [&_svg:not([class*='size-'])]:size-3
      HEREDOC
    )

    def view_template(&)
      kbd(**@attributes, &)
    end
  end

  class CommandFooter < Base
    class_variants(
      base: <<~HEREDOC,
        text-muted-foreground absolute inset-x-0 bottom-0 z-20 flex h-10 items-center gap-2 rounded-b-xl border-t#{" "}
        border-t-neutral-100 bg-neutral-50 px-4 text-xs font-medium dark:border-t-neutral-700 dark:bg-neutral-800
      HEREDOC
    )

    def view_template
      div(**@attributes) do
        div(class: "flex items-center gap-2") do
          CommandKbd do
            icon("corner-down-left")
          end

          plain("Go to Page")
        end
      end
    end
  end
end
