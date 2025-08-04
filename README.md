# ShadcnPhlexcomponents

A modern UI component library for Ruby on Rails applications, built with [Phlex](https://www.phlex.fun/) and styled with [Tailwind CSS](https://tailwindcss.com/). Inspired by [shadcn/ui](https://ui.shadcn.com/), this gem provides beautiful, accessible, and highly customizable components for Ruby developers.

## Installation

Install gem and required gems:

```bash
bundle add shadcn_phlexcomponents phlex-rails tailwindcss-rails \
tailwind_merge lucide-rails class_variants
```

Or install it yourself as:

```ruby
gem "shadcn_phlexcomponents"
gem "phlex-rails", "~> 2.1"
gem "tailwindcss-rails", "~> 4.2"
gem "tailwind_merge", "~> 1.0"
gem "lucide-rails", "~> 0.5.1"
gem "class_variants", "~> 1.1"
```

After installing the gems, run the installer to set up the necessary files:

```bash
rails install:shadcn_phlexcomponents
```

This will:

- Copy all Phlex component files to `vendor/shadcn_phlexcomponents/components`
- Copy all Stimulus controller files (either TypeScript or JavaScript) to `vendor/shadcn_phlexcomponents/javascript`
- Copy all CSS files to `vendor/shadcn_phlexcomponents/stylesheets`
- Copy an initializer file to `config/initializers/shadcn_phlexcomponents.rb`

## Upgrading

```bash
rails upgrade:shadcn_phlexcomponents
```

This will:

- Copy all Phlex component files to `vendor/shadcn_phlexcomponents/components`
- Copy all Stimulus controller files (either TypeScript or JavaScript) to `vendor/shadcn_phlexcomponents/javascript`
- Copy all CSS files to `vendor/shadcn_phlexcomponents/stylesheets`

## Quick Start

### Basic Usage

```erb
<%= render Button.new { "Default" } %>
```

See [https://shadcn-phlexcomponents.seanysx.com/](https://shadcn-phlexcomponents.seanysx.com/) for more examples.

### Demo Rails App

Please follow instructions in [https://github.com/sean-yeoh/shadcn_phlexcomponents_demo](https://github.com/sean-yeoh/shadcn_phlexcomponents_demo) to setup a rails app locally.

## Available Components

### Layout & Structure

- **Aspect Ratio**
- **Card**
- **Separator**
- **Sheet**
- **Skeleton**

### Navigation

- **Breadcrumb**
- **Pagination**
- **Tabs**

### Form Components

- **Button**
- **Input**
- **Textarea**
- **Label**
- **Checkbox**
- **Radio Group**
- **Select**
- **Switch**
- **Slider**
- **Date Picker**
- **Date Range Picker**
- **Combobox**

### Interactive Components

- **Accordion**
- **Alert Dialog**
- **Dialog**
- **Dropdown Menu**
- **Hover Card**
- **Popover**
- **Tooltip**
- **Command**
- **Collapsible**

### Feedback & Status

- **Alert**
- **Badge**
- **Progress**
- **Toast**
- **Loading Button**

### Display Components

- **Avatar**
- **Table**
- **Toggle**

### Utilities

- **Link**
- **Theme Switcher**

## Customization

### Global Configuration

Configure default component styles in an initializer:

```ruby
# config/initializers/shadcn_phlexcomponents.rb
ShadcnPhlexcomponents.configure do |config|
  config.button = {
    base: "custom-base-classes",
    variants: {
      variant: {
        primary: "bg-blue-600 text-white hover:bg-blue-700",
        secondary: "bg-gray-200 text-gray-900 hover:bg-gray-300"
      }
    }
  }
end
```

Components automatically adapt to dark mode using Tailwind's `dark:` classes.

## Form Integration

Components work with Rails form helpers:

```erb
<%= render Form.new(model: @user, class: "space-y-6") do |f| %>
  <%= f.input(:email) %>
  <%= f.submit %>
<% end %>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### Component Development

When creating new components:

1. Inherit from `ShadcnPhlexcomponents::Base`
2. Use `class_variants` for styling variations
3. Add Stimulus controllers for interactivity
4. Include comprehensive tests
5. Follow existing naming conventions

### Available Commands

```bash
# Run tests
rake test

# Run linting
rake rubocop
rubocop

# Install JavaScript dependencies
yarn install

```

## Dependencies

### Ruby Dependencies

- **rails** (~> 8.0) - Web framework
- **Phlex Rails** (~> 2.1) - Component framework
- **Class Variants** (~> 1.1) - CSS class management
- **Lucide Rails** (~> 0.5.1) - Icon library
- **Tailwind Merge** (~> 1.0) - CSS class merging

### JavaScript Dependencies

- **@hotwired/stimulus** (^3.2.2) - JavaScript framework
- **@floating-ui/dom** (^1.7.2) - Positioning library
- **dayjs** (^1.11.13) - Date manipulation
- **fuse.js** (^7.1.0) - Fuzzy searching
- **dompurify** (^3.2.6) - HTML sanitization
- **inputmask** (^5.0.9) - Input masking
- **hotkeys-js** (^3.13.14) - Keyboard shortcuts
- **nouislider** (^15.8.1) - Slider input
- **vanilla-calendar-pro** (^3.0.4) - Calendar component

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for your changes
4. Ensure all tests pass (`rake test`)
5. Run the linter (`rake rubocop`)
6. Commit your changes (`git commit -am 'Add some feature'`)
7. Push to the branch (`git push origin my-new-feature`)
8. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Acknowledgments

- Inspired by [shadcn/ui](https://ui.shadcn.com/) - The original React component library
- Built with [Phlex](https://www.phlex.fun/) - Ruby HTML components
- Styled with [Tailwind CSS](https://tailwindcss.com/) - Utility-first CSS framework
- Icons provided by [Lucide](https://lucide.dev/) - Beautiful open source icons
- [@JacobAlexander](https://github.com/JacobAlexander) - For testing and providing feedback

---
