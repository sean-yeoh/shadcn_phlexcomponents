# frozen_string_literal: true

components_path = File.expand_path("../components", __dir__)
components_install_path = Rails.root.join("vendor/shadcn_phlexcomponents")
stimulus_controllers_path = File.expand_path("../../app/javascript/controllers", __dir__)
stimulus_controllers_install_path = Rails.root.join("app/javascript/controllers/shadcn_phlexcomponents")
tailwindcss_animate_path = File.expand_path("../../app/assets/tailwind/tailwindcss-animate.css", __dir__)
tailwindcss_animate_install_path = Rails.root.join("app/assets/tailwind/shadcn_phlexcomponents/tailwindcss-animate.css")

directory(components_path, components_install_path)
directory(stimulus_controllers_path, stimulus_controllers_install_path)
copy_file(tailwindcss_animate_path, tailwindcss_animate_install_path)
