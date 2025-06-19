# frozen_string_literal: true

module ShadcnPhlexcomponents
  extend Phlex::Kit
end

# Require base.rb first
require Rails.root.join("vendor/shadcn_phlexcomponents/components/base.rb")

Dir[Rails.root.join("vendor/shadcn_phlexcomponents/components/*.rb")].each do |file|
  unless file.ends_with?("base.rb")
    require file
  end
end

ClassVariants.configure do |config|
  merger = TailwindMerge::Merger.new
  config.process_classes_with do |classes|
    merger.merge(classes)
  end
end

Rails.application.config.after_initialize do
  require "shadcn_phlexcomponents/alias"
end
