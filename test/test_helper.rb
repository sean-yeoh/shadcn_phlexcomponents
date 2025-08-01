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
require "class_variants"
require "debug"
require "nokogiri"

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

module ShadcnPhlexcomponents
  extend Phlex::Kit
end

require_relative "../lib/shadcn_phlexcomponents/components/base.rb"

Dir.glob(File.expand_path("../lib/shadcn_phlexcomponents/components/*.rb", __dir__)).each do |file|
  next if file.ends_with?("base.rb")

  require file
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
