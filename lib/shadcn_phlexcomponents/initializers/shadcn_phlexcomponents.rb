# frozen_string_literal: true

module ShadcnPhlexcomponents
  extend Phlex::Kit
end

# Configure your components here.
# ShadcnPhlexcomponents.configure do |config|
#   config.alert = {
#     root: {
#       base: <<~HEREDOC,
#         relative w-full rounded-lg border px-4 py-3 text-sm grid has-[>svg]:grid-cols-[calc(var(--spacing)*4)_1fr]
#         grid-cols-[0_1fr] has-[>svg]:gap-x-3 gap-y-0.5 items-start [&>svg]:size-4 [&>svg]:translate-y-0.5
#         [&>svg]:text-current
#       HEREDOC
#       variants: {
#         variant: {
#           default: "bg-card text-card-foreground",
#           destructive: "text-destructive bg-card [&>svg]:text-current *:data-[shadcn-phlexcomponents=alert-description]:text-destructive/90",
#         },
#       },
#       defaults: {
#         variant: :default,
#       },
#     },
#     title: {
#       base: "col-start-2 line-clamp-1 min-h-4 font-medium tracking-tight",
#     },
#     description: {
#       base: "text-muted-foreground col-start-2 grid justify-items-start gap-1 text-sm [&_p]:leading-relaxed",
#     },
#   }
# end

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
