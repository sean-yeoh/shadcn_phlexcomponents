# frozen_string_literal: true

module ShadcnPhlexcomponents
  class TableHeader < Base
    STYLES = "[&_tr]:border-b".freeze

    def view_template(&)
      thead(**@attributes, &)
    end
  end
end