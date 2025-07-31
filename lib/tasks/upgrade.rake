# frozen_string_literal: true

namespace :shadcn_phlexcomponents do
  desc "Upgrade shadcn_phlexcomponents"
  task :upgrade do
    system "ENVIRONMENT=#{ENV["ENVIRONMENT"]} #{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path(
      "../install/upgrade_shadcn_phlexcomponents.rb", __dir__
    )}"
  end
end
