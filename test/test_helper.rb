# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "shadcn_phlexcomponents"
require "phlex"
require "phlex/rails"
require "rails"
require "action_controller/railtie"
require "rails-html-sanitizer"
require "minitest/autorun"
require "lucide-rails"
require "tailwind_merge"
# Load components directly
require "shadcn_phlexcomponents/components/base"

# Load components in a specific order
require "shadcn_phlexcomponents/components/link/link"
require "shadcn_phlexcomponents/components/form/form_helpers"

# Then load the rest
Dir.glob(File.expand_path("../lib/shadcn_phlexcomponents/components/**/*.rb", __dir__)).each do |file|
  next if file.include?("link/link.rb") # Skip link.rb since we already loaded it

  require file
end
require "debug"

ENV["RAILS_ENV"] = "test"
class App < Rails::Application
  routes.append do
    resources :posts
  end
end

class PostsController < ActionController::Base
  def index
  end
end

App.initialize!

module PhlexKit
  extend Phlex::Kit
end

# Create constants for component classes
ShadcnPhlexcomponents.constants.each do |const|
  next unless ShadcnPhlexcomponents.const_get(const).is_a?(Class)

  Object.const_set(const, ShadcnPhlexcomponents.const_get(const))
end

# Monkey patch view_context
module Phlex::Rails::SGML
  def view_context
    view_paths = [Rails.root.join("app/views")]
    controller =  ActionView::TestCase::TestController.new
    @view_context ||= ::ActionView::Base.new(
      ::ActionView::LookupContext.new(view_paths),
      controller.view_assigns,
      controller,
    )
  end
end

class ComponentTest < Minitest::Test
  include LucideRails::RailsHelper
  include Phlex::Rails::Helpers::ContentTag
  include ActionView::Helpers::OutputSafetyHelper

  def view_context
    view_paths = [Rails.root.join("app/views")]
    controller =  ActionView::TestCase::TestController.new
    @view_context ||= ::ActionView::Base.new(
      ::ActionView::LookupContext.new(view_paths),
      controller.view_assigns,
      controller,
    )
  end

  def render(component, &)
    component.call(&)
  end
end
