# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Ruby gem called `shadcn_phlexcomponents` - a UI component library for Ruby on Rails that provides Shadcn-style components built with Phlex. The library includes interactive JavaScript controllers using Stimulus and Tailwind CSS for styling.

## Architecture

### Core Structure
- **Ruby Components**: Located in `lib/shadcn_phlexcomponents/components/` - each component inherits from `Base` class
- **JavaScript Controllers**: Located in `app/javascript/controllers/` - Stimulus controllers that provide interactivity
- **Stylesheets**: Located in `app/javascript/stylesheets/` - component-specific CSS
- **Base Component**: `lib/shadcn_phlexcomponents/components/base.rb` provides common functionality including:
  - Phlex::HTML integration
  - TailwindMerge for class merging
  - Sanitization helpers for SVG icons
  - Class variants system
  - Lucide Rails icon integration

### Component Pattern
Components follow a dual-layer architecture:
1. Ruby Phlex components for HTML structure and styling
2. Stimulus controllers for JavaScript behavior and interactivity

### Key Dependencies
- **Class Variants** (~> 1.1): For configuring different variants of css classes
- **Phlex Rails** (~> 2.1): For component rendering
- **Lucide Rails** (~> 0.5.1): For icons
- **TailwindMerge** (~> 1.0): For CSS class merging
- **Rails** (~> 8.0): Host framework

## Development Commands

### Testing
```bash
rake test          # Run all tests
```

### Linting
```bash
rake rubocop       # Run RuboCop linter
rubocop            # Direct RuboCop execution
```

### Development Setup
```bash
bin/setup          # Install dependencies
bin/console        # Interactive Ruby console
```

### Gem Management
```bash
bundle exec rake install    # Install gem locally
bundle exec rake release    # Release new version
rake                        # Default task (test + rubocop)
```

## Component Development

### Adding New Components
1. Create Ruby component in `lib/shadcn_phlexcomponents/components/`
2. If interactive, create corresponding Stimulus controller in `app/javascript/controllers/`
3. Add any component-specific CSS to `app/javascript/stylesheets/`
4. Components should inherit from `ShadcnPhlexcomponents::Base`

### Styling Guidelines
- Use Tailwind CSS classes
- Leverage the `TAILWIND_MERGER` for class merging
- Follow existing component patterns for consistency
- Use `class_variants` system for component variations

### JavaScript Controllers
- Use Stimulus framework
- Controllers should be named `[component_name]_controller.ts`
- Follow existing controller patterns for data attributes and targets