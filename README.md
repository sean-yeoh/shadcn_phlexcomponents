# ShadcnPhlexcomponents

A modern UI component library for Ruby on Rails applications, built with [Phlex](https://www.phlex.fun/) and styled with [Tailwind CSS](https://tailwindcss.com/). Inspired by [shadcn/ui](https://ui.shadcn.com/), this gem provides beautiful, accessible, and highly customizable components for Ruby developers.

## ✨ Features

- 🎨 **50+ Beautiful Components** - Complete UI component library with consistent design
- ⚡ **Phlex-Powered** - Fast, type-safe Ruby components
- 🎯 **Stimulus Integration** - Interactive components with modern JavaScript
- 🎪 **Tailwind CSS** - Utility-first styling with full customization
- ♿ **Accessibility First** - ARIA-compliant and keyboard navigation support
- 🌙 **Dark Mode Ready** - Built-in theme switching support
- 📱 **Responsive Design** - Mobile-first approach
- 🔧 **Highly Customizable** - Extensive configuration options
- 🚀 **Easy Installation** - Simple setup with Rails integration

## 📦 Installation

Add this line to your application's Gemfile:

```ruby
gem 'shadcn_phlexcomponents'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install shadcn_phlexcomponents
```

### Rails Integration

After installing the gem, run the installer to set up the necessary files:

```bash
rails generate install:shadcn_phlexcomponents
```

This will:
- Copy JavaScript controllers and utilities
- Set up Tailwind CSS configuration
- Add Stimulus integration
- Configure component stylesheets

## 🚀 Quick Start

### Basic Usage

```ruby
# In your view or component
class MyView < Phlex::HTML
  def view_template
    render ShadcnPhlexcomponents::Button.new(variant: :primary) do
      "Click me!"
    end
  end
end
```

### With Rails Helpers

```erb
<%# In your ERB templates %>
<%= render ShadcnPhlexcomponents::Card.new do %>
  <%= render ShadcnPhlexcomponents::Card::Header.new do %>
    <h3>Card Title</h3>
  <% end %>
  <%= render ShadcnPhlexcomponents::Card::Content.new do %>
    <p>Card content goes here.</p>
  <% end %>
<% end %>
```

## 🧩 Available Components

### Layout & Structure
- **Aspect Ratio** - Maintain aspect ratios for media content
- **Card** - Flexible content containers with header, content, and footer
- **Separator** - Visual dividers for content sections
- **Sheet** - Slide-out panels and drawers
- **Skeleton** - Loading placeholders

### Navigation
- **Breadcrumb** - Navigation hierarchy display
- **Pagination** - Page navigation controls
- **Tabs** - Tabbed content organization

### Form Components
- **Button** - Primary action triggers with multiple variants
- **Input** - Text input fields with validation states
- **Textarea** - Multi-line text input
- **Label** - Accessible form labels
- **Checkbox** - Single and grouped checkboxes
- **Radio Group** - Radio button selections
- **Select** - Dropdown selections
- **Switch** - Toggle switches
- **Slider** - Range input controls
- **Date Picker** - Single date selection
- **Date Range Picker** - Date range selection
- **Combobox** - Searchable select dropdowns

### Interactive Components
- **Accordion** - Collapsible content sections
- **Alert Dialog** - Modal confirmations and alerts
- **Dialog** - Modal dialogs and overlays
- **Dropdown Menu** - Context menus and actions
- **Hover Card** - Contextual information on hover
- **Popover** - Floating content containers
- **Tooltip** - Helpful text on hover
- **Command** - Command palette interface
- **Collapsible** - Expandable content areas

### Feedback & Status
- **Alert** - Status messages and notifications
- **Badge** - Labels and status indicators
- **Progress** - Progress bars and indicators
- **Toast** - Notification messages
- **Loading Button** - Buttons with loading states

### Display Components
- **Avatar** - User profile images with fallbacks
- **Table** - Data tables with sorting and styling
- **Toggle** - Binary state toggles

### Utilities
- **Link** - Styled navigation links
- **Theme Switcher** - Light/dark mode toggle

## 🎨 Customization

### Component Variants

Most components support multiple variants for different use cases:

```ruby
# Button variants
render ShadcnPhlexcomponents::Button.new(variant: :default) { "Default" }
render ShadcnPhlexcomponents::Button.new(variant: :destructive) { "Delete" }
render ShadcnPhlexcomponents::Button.new(variant: :outline) { "Cancel" }
render ShadcnPhlexcomponents::Button.new(variant: :ghost) { "Ghost" }
render ShadcnPhlexcomponents::Button.new(variant: :link) { "Link" }

# Button sizes
render ShadcnPhlexcomponents::Button.new(size: :sm) { "Small" }
render ShadcnPhlexcomponents::Button.new(size: :default) { "Default" }
render ShadcnPhlexcomponents::Button.new(size: :lg) { "Large" }
render ShadcnPhlexcomponents::Button.new(size: :icon) { icon(:plus) }
```

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

### CSS Customization

Override component styles using Tailwind CSS:

```css
/* app/assets/stylesheets/application.css */
.shadcn-button {
  @apply font-semibold transition-all duration-200;
}

.shadcn-button--primary {
  @apply bg-brand-primary hover:bg-brand-primary-dark;
}
```

## 🎯 Interactive Components

Components with JavaScript functionality automatically include Stimulus controllers:

```ruby
# Accordion with automatic JavaScript behavior
render ShadcnPhlexcomponents::Accordion.new do
  render ShadcnPhlexcomponents::Accordion::Item.new(value: "item-1") do
    render ShadcnPhlexcomponents::Accordion::Trigger.new { "Section 1" }
    render ShadcnPhlexcomponents::Accordion::Content.new do
      "Content for section 1"
    end
  end
end

# Dialog with modal behavior
render ShadcnPhlexcomponents::Dialog.new do
  render ShadcnPhlexcomponents::Dialog::Trigger.new do
    render ShadcnPhlexcomponents::Button.new { "Open Dialog" }
  end
  render ShadcnPhlexcomponents::Dialog::Content.new do
    render ShadcnPhlexcomponents::Dialog::Header.new do
      render ShadcnPhlexcomponents::Dialog::Title.new { "Dialog Title" }
    end
    "Dialog content goes here"
  end
end
```

## 🌙 Dark Mode

Enable dark mode support by adding the theme switcher:

```ruby
# In your layout
render ShadcnPhlexcomponents::ThemeSwitcher.new
```

Components automatically adapt to dark mode using Tailwind's `dark:` classes.

## 📋 Form Integration

Components work seamlessly with Rails form helpers:

```ruby
# Using with Rails forms
form_with model: @user do |form|
  div(class: "space-y-4") do
    render ShadcnPhlexcomponents::Form::FormField.new(form: form, name: :name) do
      render ShadcnPhlexcomponents::Label.new { "Name" }
      render ShadcnPhlexcomponents::Input.new(
        name: "user[name]",
        value: @user.name,
        placeholder: "Enter your name"
      )
    end
    
    render ShadcnPhlexcomponents::Button.new(type: :submit) { "Save" }
  end
end
```

## 🛠️ Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### Available Commands

```bash
# Run tests
rake test

# Run linting
rake rubocop
rubocop

# Build JavaScript assets
yarn build

# Install gem locally
bundle exec rake install

# Release new version
bundle exec rake release
```

### Component Development

When creating new components:

1. Inherit from `ShadcnPhlexcomponents::Base`
2. Use `class_variants` for styling variations
3. Add Stimulus controllers for interactivity
4. Include comprehensive tests
5. Follow existing naming conventions

## 🧪 Testing

The gem includes comprehensive test coverage:

```bash
# Run all tests
rake test

# Run specific test file
ruby test/test_button.rb

# Run with coverage
rake test
```

## 📚 Dependencies

### Ruby Dependencies
- **Rails** (~> 8.0) - Web framework
- **Phlex Rails** (~> 2.1) - Component framework
- **Class Variants** (~> 1.1) - CSS class management
- **Lucide Rails** (~> 0.5.1) - Icon library
- **Tailwind Merge** (~> 1.0) - CSS class merging

### JavaScript Dependencies
- **Stimulus** (^3.2.2) - JavaScript framework
- **Floating UI** (^1.7.2) - Positioning library
- **Day.js** (^1.11.13) - Date manipulation
- **Fuse.js** (^7.1.0) - Fuzzy searching
- **DOMPurify** (^3.2.6) - HTML sanitization

## 🤝 Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sean-yeoh/shadcn_phlexcomponents. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/sean-yeoh/shadcn_phlexcomponents/blob/main/CODE_OF_CONDUCT.md).

### Contributing Guidelines

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for your changes
4. Ensure all tests pass (`rake test`)
5. Run the linter (`rake rubocop`)
6. Commit your changes (`git commit -am 'Add some feature'`)
7. Push to the branch (`git push origin my-new-feature`)
8. Create a new Pull Request

## 📄 License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## 🙏 Acknowledgments

- Inspired by [shadcn/ui](https://ui.shadcn.com/) - The original React component library
- Built with [Phlex](https://www.phlex.fun/) - Ruby HTML components
- Styled with [Tailwind CSS](https://tailwindcss.com/) - Utility-first CSS framework
- Icons provided by [Lucide](https://lucide.dev/) - Beautiful open source icons

## 📞 Support

- 📖 [Documentation](https://github.com/sean-yeoh/shadcn_phlexcomponents)
- 🐛 [Issues](https://github.com/sean-yeoh/shadcn_phlexcomponents/issues)
- 💬 [Discussions](https://github.com/sean-yeoh/shadcn_phlexcomponents/discussions)

---

Made with ❤️ by [Sean Yeoh](https://github.com/sean-yeoh)