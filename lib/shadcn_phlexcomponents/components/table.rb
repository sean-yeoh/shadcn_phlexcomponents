# frozen_string_literal: true

module ShadcnPhlexcomponents
  class Table < Base
    class_variants(base: "w-full caption-bottom text-sm")

    def initialize(**attributes)
      @columns = []
      super(**attributes)
    end

    def view_template(&)
      div(class: "relative w-full overflow-x-auto") do
        table(**@attributes, &)
      end
    end

    def caption(**attributes, &)
      TableCaption(**attributes, &)
    end

    def header(**attributes, &)
      TableHeader(**attributes, &)
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

      thead(class: TableHeader.new.class_variants) do
        tr(class: TableRow.new.class_variants) do
          @columns.each do |column|
            th(class: TAILWIND_MERGER.merge("#{TableHead.new.class_variants} #{column[:head_class]}")) { column[:header] }
          end
        end
      end

      tbody(class: TableBody.new.class_variants) do
        @rows.each do |row|
          tr(class: TableRow.new.class_variants) do
            @columns.each do |column|
              td(class: TAILWIND_MERGER.merge("#{TableCell.new.class_variants} #{column[:cell_class]}")) do
                column[:content].call(row)
              end
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

  class TableCaption < Base
    class_variants(base: "text-muted-foreground mt-4 text-sm")

    def view_template(&)
      caption(**@attributes, &)
    end
  end

  class TableHeader < Base
    class_variants(base: "[&_tr]:border-b")

    def view_template(&)
      thead(**@attributes, &)
    end
  end

  class TableRow < Base
    class_variants(base: "hover:bg-muted/50 data-[state=selected]:bg-muted border-b transition-colors")

    def view_template(&)
      tr(**@attributes, &)
    end
  end

  class TableHead < Base
    class_variants(
      base: <<~HEREDOC,
        text-foreground h-10 px-2 text-left align-middle font-medium whitespace-nowrap [&:has([role=checkbox])]:pr-0
        [&>[role=checkbox]]:translate-y-[2px]"
      HEREDOC
    )

    def view_template(&)
      th(**@attributes, &)
    end
  end

  class TableBody < Base
    class_variants(base: "[&_tr:last-child]:border-0")

    def view_template(&)
      tbody(**@attributes, &)
    end
  end

  class TableCell < Base
    class_variants(
      base: "p-2 align-middle whitespace-nowrap [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
    )

    def view_template(&)
      td(**@attributes, &)
    end
  end

  class TableFooter < Base
    class_variants(base: "bg-muted/50 border-t font-medium [&>tr]:last:border-b-0")

    def view_template(&)
      tfoot(**@attributes, &)
    end
  end
end
