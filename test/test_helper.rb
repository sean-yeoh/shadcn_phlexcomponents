# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "shadcn_phlexcomponents"
require "phlex"
require "phlex/rails"
require "rails"
require "action_controller/railtie"
require "minitest/autorun"
require "lucide-rails"
require "tailwind_merge"
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

Dir.glob("lib/components/**/*.rb").map do |path|
  class_name = path.split("/").last.delete_suffix(".rb").split("_").map(&:capitalize).join.to_sym
  autoload class_name, path
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
