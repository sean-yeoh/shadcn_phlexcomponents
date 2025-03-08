components_install_path = Rails.root.join("lib/shadcn_phlexcomponents/components")
components_path = File.expand_path("../components", __dir__).to_s
stimulus_controllers_install_path = Rails.root.join("app/javascript/controllers/shadcn_phlexcomponents")
stimulus_controllers_path = File.expand_path("../../app/javascript/controllers", __dir__).to_s

directory(components_path, components_install_path)
directory(stimulus_controllers_path, stimulus_controllers_install_path)
