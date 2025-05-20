# frozen_string_literal: true

components_path = File.expand_path("../shadcn_phlexcomponents/components", __dir__)
components_install_path = Rails.root.join("vendor/shadcn_phlexcomponents/components")
stimulus_controllers_path = File.expand_path("../../app/javascript", __dir__)
stimulus_controllers_install_path = Rails.root.join("vendor/shadcn_phlexcomponents/javascript")
css_path = File.expand_path("../../app/stylesheets", __dir__)
css_install_path = Rails.root.join("vendor/shadcn_phlexcomponents/stylesheets")

directory(components_path, components_install_path)
directory(stimulus_controllers_path, stimulus_controllers_install_path)
directory(css_path, css_install_path)
