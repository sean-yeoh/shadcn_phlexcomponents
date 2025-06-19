# frozen_string_literal: true

components_path = File.expand_path("../shadcn_phlexcomponents/components", __dir__)
components_install_path = Rails.root.join("vendor/shadcn_phlexcomponents/components")
stimulus_controllers_path = File.expand_path("../../app/javascript", __dir__)
stimulus_controllers_install_path = Rails.root.join("vendor/shadcn_phlexcomponents/javascript")
css_path = File.expand_path("../../app/stylesheets", __dir__)
css_install_path = Rails.root.join("vendor/shadcn_phlexcomponents/stylesheets")
initializer_file_path = File.expand_path("../shadcn_phlexcomponents/initializers/shadcn_phlexcomponents.rb", __dir__)
initializer_file_install_path = Rails.root.join("config/initializers/shadcn_phlexcomponents.rb")

say "Running the install command will copy a lot of files to your working directory.", :blue
say "Please make sure to commit or stash your existing changes in your working directory.", :blue

if yes?("Do you want to continue? (y/n)")
  directory(components_path, components_install_path)
  directory(stimulus_controllers_path, stimulus_controllers_install_path)
  directory(css_path, css_install_path)
  copy_file(initializer_file_path, initializer_file_install_path)
end
