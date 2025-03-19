# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "shadcn_phlexcomponents"
require "phlex"
require "phlex/rails"
require "action_controller/railtie"
require "minitest/autorun"
require "lucide-rails"
require "tailwind_merge"
require "debug"

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

# require base_component first
require "lib/components/base_component"

Dir.glob("lib/components/**/*.rb").map do |path|
  require path
end

class ComponentTest < Minitest::Test
  def render(component, &)
    component.call(&)
  end
end
