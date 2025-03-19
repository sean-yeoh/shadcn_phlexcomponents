# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "shadcn_phlexcomponents"
require "phlex"
require "phlex-rails"
require "rails"
require "action_controller/railtie"
require "action_view/railtie"
require "rails/test_help"
require "minitest/autorun"
require "lucide-rails"
require "tailwind_merge"
require "nokogiri"
require "debug"

class App < Rails::Application
  config.eager_load = false
  config.hosts.clear
  config.autoload_paths << "#{root}/app/view_components"
  config.secret_key_base = "secret-key"
  config.action_dispatch.show_exceptions = :rescuable
  config.active_support.to_time_preserves_timezone = :zone
  config.action_controller.perform_caching = true
end

App.initialize!

module PhlexKit
  extend Phlex::Kit
end

Dir.glob("lib/components/**/*.rb").map do |path|
  require path
end

class ComponentTest < Minitest::Test
  def render(component, &)
    component.call(&)
  end

  def phlex(&)
    render(Phlex::HTML.new, &)
  end
end
