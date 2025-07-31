# frozen_string_literal: true

components_path = File.expand_path("../shadcn_phlexcomponents/components", __dir__)
components_install_path = Rails.root.join("vendor/shadcn_phlexcomponents/components")
stimulus_js_controllers_path = File.expand_path("../../app/javascript", __dir__)
stimulus_ts_controllers_path = File.expand_path("../../app/typescript", __dir__)
stimulus_controllers_install_path = Rails.root.join("vendor/shadcn_phlexcomponents/javascript")
css_path = File.expand_path("../../app/stylesheets", __dir__)
css_install_path = Rails.root.join("vendor/shadcn_phlexcomponents/stylesheets")

say "Running the upgrade command will copy a lot of files to your working directory.", :blue
say "Please make sure to commit or stash your existing changes in your working directory.", :blue

if ENV["ENVIRONMENT"] == "test"
  directory(components_path, components_install_path)
  directory(stimulus_js_controllers_path, stimulus_controllers_install_path)
  directory(css_path, css_install_path)
elsif yes?("Do you want to continue? (y/n)")
  using_typescript = yes?("Are you using Typescript?")

  if using_typescript
    directory(stimulus_ts_controllers_path, stimulus_controllers_install_path)
  else
    directory(stimulus_js_controllers_path, stimulus_controllers_install_path)
  end
  directory(components_path, components_install_path)
  directory(css_path, css_install_path)
end
