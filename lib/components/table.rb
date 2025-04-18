# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Table < Base
    STYLES = "w-full caption-bottom text-sm".freeze

    def initialize( **attributes)
      @columns = []
      super(**attributes)
    end

    def view_template(&)
      table(**@attributes, &)
    end

    def header(**attributes, &)
      TableHeader(**attributes, &)
    end 

    def caption(**attributes, &)
      TableCaption(**attributes, &)
    end

    def row(**attributes, &)
      TableRow(**attributes, &)
    end

    def head(**attributes, &)
      TableHead(**attributes, &)
    end

    def body(**attributes, &)
      TableBody(**attributes, &)
    end

    def cell(**attributes, &)
      TableCell(**attributes, &)
    end

    def footer(**attributes, &)
      TableFooter(**attributes, &)
    end

    def rows(rows, &)
      @rows = rows

      vanish(&)

      thead(class: TableHeader::STYLES) do
        tr(class: TableRow::STYLES) do
          @columns.each do |column|
            th(class: TAILWIND_MERGER.merge("#{TableHead::STYLES} #{column[:head_class]}")) { column[:header] }
          end
        end
      end

      tbody(class: TableBody::STYLES) do
        @rows.each do |row|
          tr(class: TableRow::STYLES) do
            @columns.each do |column|
              td(class: TAILWIND_MERGER.merge("#{TableCell::STYLES} #{column[:cell_class]}")) { column[:content].call(row) }
            end
          end
        end
      end
    end

    def column(header, head_class: nil, cell_class: nil, &content)
      @columns << { header:, head_class:, cell_class:, content: }
      nil
    end
  end
end