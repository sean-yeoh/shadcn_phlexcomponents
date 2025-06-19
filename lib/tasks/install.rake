# frozen_string_literal: true

namespace :shadcn_phlexcomponents do
  desc "Install shadcn_phlexcomponents"
  task :install do
    system "ENVIRONMENT=#{ENV["ENVIRONMENT"]} #{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path(
      "../install/install_shadcn_phlexcomponents.rb", __dir__
    )}"
  end
end
