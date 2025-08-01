# frozen_string_literal: true

require "test_helper"

class TestTable < ComponentTest
  def test_it_should_render_basic_table
    component = ShadcnPhlexcomponents::Table.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="table"')
    assert_includes(output, "w-full caption-bottom text-sm")
    assert_includes(output, "relative w-full overflow-x-auto")
    assert_match(%r{<div[^>]*>.*<table[^>]*>.*</table>.*</div>}m, output)
  end

  def test_it_should_render_with_custom_attributes
    component = ShadcnPhlexcomponents::Table.new(
      class: "custom-table border-2",
      id: "data-table",
      data: { testid: "user-table" },
    )
    output = render(component)

    assert_includes(output, "custom-table border-2")
    assert_includes(output, 'id="data-table"')
    assert_includes(output, 'data-testid="user-table"')
    assert_includes(output, "w-full caption-bottom text-sm")
  end

  def test_it_should_render_with_rows_and_columns
    users = [
      { name: "John Doe", email: "john@example.com", role: "Admin" },
      { name: "Jane Smith", email: "jane@example.com", role: "User" },
    ]

    component = ShadcnPhlexcomponents::Table.new do |table|
      table.rows(users) do
        table.column("Name") { |user| user[:name] }
        table.column("Email") { |user| user[:email] }
        table.column("Role") { |user| user[:role] }
      end
    end
    output = render(component)

    # Check table structure
    assert_includes(output, "<thead")
    assert_includes(output, "<tbody")
    assert_includes(output, "<th")
    assert_includes(output, "<td")

    # Check headers
    assert_includes(output, "Name")
    assert_includes(output, "Email")
    assert_includes(output, "Role")

    # Check data
    assert_includes(output, "John Doe")
    assert_includes(output, "john@example.com")
    assert_includes(output, "Jane Smith")
    assert_includes(output, "jane@example.com")
    assert_includes(output, "Admin")
    assert_includes(output, "User")
  end

  def test_it_should_render_with_helper_methods
    component = ShadcnPhlexcomponents::Table.new do |table|
      table.caption { "User Management Table" }
      table.header do
        table.row do
          table.head { "ID" }
          table.head { "Name" }
          table.head { "Status" }
        end
      end
      table.body do
        table.row do
          table.cell { "1" }
          table.cell { "John" }
          table.cell { "Active" }
        end
      end
      table.footer do
        table.row do
          table.cell(colspan: 3) { "Total: 1 user" }
        end
      end
    end
    output = render(component)

    # Check caption
    assert_includes(output, "User Management Table")
    assert_includes(output, "text-muted-foreground mt-4 text-sm")

    # Check structure
    assert_includes(output, "<caption")
    assert_includes(output, "<thead")
    assert_includes(output, "<tbody")
    assert_includes(output, "<tfoot")

    # Check content
    assert_includes(output, "ID")
    assert_includes(output, "Name")
    assert_includes(output, "Status")
    assert_includes(output, "John")
    assert_includes(output, "Active")
    assert_includes(output, "Total: 1 user")
    assert_includes(output, 'colspan="3"')
  end

  def test_it_should_render_with_column_classes
    users = [{ name: "John", status: "active" }]

    component = ShadcnPhlexcomponents::Table.new do |table|
      table.rows(users) do
        table.column("Name", head_class: "font-bold text-left", cell_class: "text-blue-500") { |user| user[:name] }
        table.column("Status", head_class: "text-center", cell_class: "uppercase text-green-600") { |user| user[:status] }
      end
    end
    output = render(component)

    # Check that custom classes are applied
    assert_includes(output, "font-bold text-left")
    assert_includes(output, "text-center")
    assert_includes(output, "text-blue-500")
    assert_includes(output, "uppercase text-green-600")
  end

  def test_it_should_handle_empty_rows
    component = ShadcnPhlexcomponents::Table.new do |table|
      table.rows([]) do
        table.column("Name") { |user| user[:name] }
      end
    end
    output = render(component)

    # Should render header but no body rows
    assert_includes(output, "<thead")
    assert_includes(output, "<tbody")
    assert_includes(output, "Name")
    # Should not contain any data rows
    refute_match(/<td/, output)
  end
end

class TestTableSubComponents < ComponentTest
  def test_table_caption_should_render
    component = ShadcnPhlexcomponents::TableCaption.new { "Table Caption" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="table-caption"')
    assert_includes(output, "text-muted-foreground mt-4 text-sm")
    assert_includes(output, "Table Caption")
    assert_match(%r{<caption[^>]*>.*Table Caption.*</caption>}m, output)
  end

  def test_table_header_should_render
    component = ShadcnPhlexcomponents::TableHeader.new { "Header Content" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="table-header"')
    assert_includes(output, "[&_tr]:border-b")
    assert_includes(output, "Header Content")
    assert_match(%r{<thead[^>]*>.*Header Content.*</thead>}m, output)
  end

  def test_table_body_should_render
    component = ShadcnPhlexcomponents::TableBody.new { "Body Content" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="table-body"')
    assert_includes(output, "[&_tr:last-child]:border-0")
    assert_includes(output, "Body Content")
    assert_match(%r{<tbody[^>]*>.*Body Content.*</tbody>}m, output)
  end

  def test_table_footer_should_render
    component = ShadcnPhlexcomponents::TableFooter.new { "Footer Content" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="table-footer"')
    assert_includes(output, "bg-muted/50 border-t font-medium")
    assert_includes(output, "Footer Content")
    assert_match(%r{<tfoot[^>]*>.*Footer Content.*</tfoot>}m, output)
  end

  def test_table_row_should_render
    component = ShadcnPhlexcomponents::TableRow.new { "Row Content" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="table-row"')
    assert_includes(output, "hover:bg-muted/50")
    assert_includes(output, "data-[state=selected]:bg-muted")
    assert_includes(output, "border-b transition-colors")
    assert_includes(output, "Row Content")
    assert_match(%r{<tr[^>]*>.*Row Content.*</tr>}m, output)
  end

  def test_table_head_should_render
    component = ShadcnPhlexcomponents::TableHead.new { "Header Cell" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="table-head"')
    assert_includes(output, "text-foreground")
    assert_includes(output, "h-10 px-2 text-left align-middle font-medium")
    assert_includes(output, "Header Cell")
    assert_match(%r{<th[^>]*>.*Header Cell.*</th>}m, output)
  end

  def test_table_cell_should_render
    component = ShadcnPhlexcomponents::TableCell.new { "Cell Content" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="table-cell"')
    assert_includes(output, "p-2 align-middle")
    assert_includes(output, "[&:has([role=checkbox])]:pr-0")
    assert_includes(output, "Cell Content")
    assert_match(%r{<td[^>]*>.*Cell Content.*</td>}m, output)
  end

  def test_table_container_should_render
    component = ShadcnPhlexcomponents::TableContainer.new { "Container Content" }
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="table-container"')
    assert_includes(output, "relative w-full overflow-x-auto")
    assert_includes(output, "Container Content")
    assert_match(%r{<div[^>]*>.*Container Content.*</div>}m, output)
  end

  def test_sub_components_with_custom_attributes
    components = [
      { component: ShadcnPhlexcomponents::TableCaption, tag: "caption" },
      { component: ShadcnPhlexcomponents::TableHeader, tag: "thead" },
      { component: ShadcnPhlexcomponents::TableBody, tag: "tbody" },
      { component: ShadcnPhlexcomponents::TableFooter, tag: "tfoot" },
      { component: ShadcnPhlexcomponents::TableRow, tag: "tr" },
      { component: ShadcnPhlexcomponents::TableHead, tag: "th" },
      { component: ShadcnPhlexcomponents::TableCell, tag: "td" },
      { component: ShadcnPhlexcomponents::TableContainer, tag: "div" },
    ]

    components.each do |config|
      component = config[:component].new(
        class: "custom-class",
        id: "custom-id",
        data: { testid: "custom-test" },
      ) { "Test Content" }
      output = render(component)

      assert_includes(output, "custom-class")
      assert_includes(output, 'id="custom-id"')
      assert_includes(output, 'data-testid="custom-test"')
      assert_includes(output, "Test Content")
      assert_match(%r{<#{config[:tag]}[^>]*>.*Test Content.*</#{config[:tag]}>}m, output)
    end
  end
end

class TestTableWithCustomConfiguration < ComponentTest
  def test_table_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.table = {
      root: { base: "custom-table-base border-4 border-red-500" },
      caption: { base: "custom-caption-base text-blue-600" },
      header: { base: "custom-header-base bg-gray-100" },
      body: { base: "custom-body-base bg-gray-50" },
      footer: { base: "custom-footer-base bg-gray-200" },
      row: { base: "custom-row-base hover:bg-yellow-100" },
      head: { base: "custom-head-base font-bold text-purple-600" },
      cell: { base: "custom-cell-base p-4 text-green-600" },
      container: { base: "custom-container-base border-2 border-blue-500" },
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload all table classes
    table_classes = [
      "TableContainer",
      "TableFooter",
      "TableCell",
      "TableHead",
      "TableBody",
      "TableRow",
      "TableHeader",
      "TableCaption",
      "Table",
    ]

    table_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/table.rb", __dir__))

    # Test components with custom configuration
    table = ShadcnPhlexcomponents::Table.new
    table_output = render(table)
    assert_includes(table_output, "custom-table-base")
    assert_includes(table_output, "border-4 border-red-500")
    assert_includes(table_output, "custom-container-base")
    assert_includes(table_output, "border-2 border-blue-500")

    caption = ShadcnPhlexcomponents::TableCaption.new { "Test" }
    caption_output = render(caption)
    assert_includes(caption_output, "custom-caption-base")
    assert_includes(caption_output, "text-blue-600")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    table_classes.each do |klass|
      ShadcnPhlexcomponents.send(:remove_const, klass.to_sym) if ShadcnPhlexcomponents.const_defined?(klass.to_sym)
    end
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/table.rb", __dir__))
  end
end

class TestTableIntegration < ComponentTest
  def test_user_management_table
    users = [
      { id: 1, name: "John Doe", email: "john@example.com", role: "Admin", status: "Active" },
      { id: 2, name: "Jane Smith", email: "jane@example.com", role: "Editor", status: "Active" },
      { id: 3, name: "Bob Wilson", email: "bob@example.com", role: "User", status: "Inactive" },
    ]

    component = ShadcnPhlexcomponents::Table.new(
      class: "user-table",
      data: {
        controller: "user-management",
        user_management_target: "table",
      },
    ) do |table|
      table.caption { "User Management - #{users.length} users total" }

      table.rows(users) do
        table.column("ID", head_class: "w-16") { |user| user[:id] }
        table.column("Name", head_class: "font-semibold") { |user| user[:name] }
        table.column("Email") { |user| user[:email] }
        table.column("Role", cell_class: "text-center") { |user| user[:role] }
        table.column("Status", cell_class: "font-medium") do |user|
          status_class = user[:status] == "Active" ? "text-green-600" : "text-red-600"
          "<span class='#{status_class}'>#{user[:status]}</span>"
        end
      end
    end
    output = render(component)

    # Check table structure and styling
    assert_includes(output, "user-table")
    assert_includes(output, 'data-controller="user-management"')
    assert_includes(output, 'data-user-management-target="table"')

    # Check caption
    assert_includes(output, "User Management - 3 users total")

    # Check headers and custom classes
    assert_includes(output, "w-16")
    assert_includes(output, "font-semibold")
    assert_includes(output, "text-center")
    assert_includes(output, "font-medium")

    # Check all user data
    users.each do |user|
      assert_includes(output, user[:name])
      assert_includes(output, user[:email])
      assert_includes(output, user[:role])
      assert_includes(output, user[:status])
    end

    # Check status styling
    assert_includes(output, "text-green-600")
    assert_includes(output, "text-red-600")
  end

  def test_data_table_with_sorting
    products = [
      { name: "Laptop", price: 999.99, category: "Electronics" },
      { name: "Book", price: 29.99, category: "Education" },
    ]

    component = ShadcnPhlexcomponents::Table.new(
      class: "sortable-table",
      data: {
        controller: "sortable-table",
        sortable_table_sort_column: "name",
        sortable_table_sort_direction: "asc",
      },
    ) do |table|
      table.header do
        table.row do
          table.head(
            class: "cursor-pointer hover:bg-muted/50",
            data: {
              action: "click->sortable-table#sort",
              sortable_table_column: "name",
            },
          ) { "Product Name ↑" }
          table.head(
            class: "cursor-pointer hover:bg-muted/50",
            data: {
              action: "click->sortable-table#sort",
              sortable_table_column: "price",
            },
          ) { "Price" }
          table.head { "Category" }
        end
      end

      table.body do
        products.each do |product|
          table.row(
            class: "hover:bg-muted/30",
            data: { product_id: product.object_id },
          ) do
            table.cell { product[:name] }
            table.cell(class: "text-right font-mono") { "$#{product[:price]}" }
            table.cell(class: "text-muted-foreground") { product[:category] }
          end
        end
      end
    end
    output = render(component)

    # Check sorting functionality
    assert_includes(output, "sortable-table")
    assert_includes(output, 'data-controller="sortable-table"')
    assert_includes(output, 'data-sortable-table-sort-column="name"')
    assert_includes(output, 'data-sortable-table-sort-direction="asc"')

    # Check sortable headers
    assert_includes(output, "cursor-pointer hover:bg-muted/50")
    assert_includes(output, 'data-action="click->sortable-table#sort"')
    assert_includes(output, 'data-sortable-table-column="name"')
    assert_includes(output, "Product Name ↑")

    # Check data formatting
    assert_includes(output, "text-right font-mono")
    assert_includes(output, "$999.99")
    assert_includes(output, "$29.99")
    assert_includes(output, "text-muted-foreground")
  end

  def test_responsive_table_with_mobile_view
    component = ShadcnPhlexcomponents::Table.new(
      class: "responsive-table hidden md:table",
      data: {
        controller: "responsive-table",
        responsive_table_breakpoint: "md",
      },
    ) do |table|
      table.rows([{ name: "John", email: "john@example.com" }]) do
        table.column("Name", head_class: "hidden sm:table-cell", cell_class: "hidden sm:table-cell") { |user| user[:name] }
        table.column("Email") { |user| user[:email] }
      end
    end
    output = render(component)

    # Check responsive classes
    assert_includes(output, "responsive-table hidden md:table")
    assert_includes(output, 'data-controller="responsive-table"')
    assert_includes(output, 'data-responsive-table-breakpoint="md"')
    assert_includes(output, "hidden sm:table-cell")
  end

  def test_table_with_selection
    users = [
      { id: 1, name: "John", selected: false },
      { id: 2, name: "Jane", selected: true },
    ]

    component = ShadcnPhlexcomponents::Table.new(
      class: "selectable-table",
      data: {
        controller: "table-selection",
        table_selection_selected_ids: [2].to_json,
      },
    ) do |table|
      table.header do
        table.row do
          table.head(class: "w-12") do
            "<input type='checkbox' class='rounded border-input' data-action='change->table-selection#toggleAll'>"
          end
          table.head { "Name" }
          table.head { "Actions" }
        end
      end

      table.body do
        users.each do |user|
          table.row(
            class: user[:selected] ? "bg-muted/50" : "",
            data: {
              state: user[:selected] ? "selected" : "",
              user_id: user[:id],
            },
          ) do
            table.cell(class: "w-12") do
              checked_attr = user[:selected] ? "checked" : ""
              "<input type='checkbox' #{checked_attr} class='rounded border-input' data-action='change->table-selection#toggleRow'>"
            end
            table.cell { user[:name] }
            table.cell do
              "<button class='text-sm text-blue-600 hover:underline' data-action='click->table-selection#editUser'>Edit</button>"
            end
          end
        end
      end
    end
    output = render(component)

    # Check selection functionality
    assert_includes(output, "selectable-table")
    assert_includes(output, 'data-controller="table-selection"')
    assert_includes(output, 'data-table-selection-selected-ids="[2]"')

    # Check checkbox functionality
    assert_includes(output, "change-&gt;table-selection#toggleAll")
    assert_includes(output, "change-&gt;table-selection#toggleRow")
    assert_includes(output, 'data-state="selected"')
    assert_includes(output, "bg-muted/50")
    assert_includes(output, "checked")

    # Check actions
    assert_includes(output, "click-&gt;table-selection#editUser")
    assert_includes(output, "text-blue-600 hover:underline")
  end
end
