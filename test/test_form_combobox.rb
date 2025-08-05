# frozen_string_literal: true

require "test_helper"

class TestFormCombobox < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :language,
      collection: [{ value: "ruby", text: "Ruby" }],
      value_method: :value,
      text_method: :text,
    ) { "Combobox content" }
    output = render(component)

    # NOTE: Block content is consumed by vanish method and not rendered in the output
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-combobox')
    assert_includes(output, 'data-controller="combobox"')
    assert_includes(output, 'name="language"')
    assert_includes(output, 'id="language"')
    assert_includes(output, "Ruby") # Check that collection item is rendered
    assert_match(%r{<div[^>]*>.*</div>}m, output)
  end

  def test_it_should_render_with_model_and_method
    book = Book.new(category: "fiction")

    component = ShadcnPhlexcomponents::FormCombobox.new(
      :category,
      model: book,
      collection: [
        { value: "fiction", text: "Fiction" },
        { value: "non-fiction", text: "Non-Fiction" },
        { value: "mystery", text: "Mystery" },
      ],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, "Fiction")
    assert_includes(output, "Non-Fiction")
    assert_includes(output, "Mystery")
    assert_includes(output, 'name="category"')
    assert_includes(output, 'id="category"')
    assert_includes(output, 'data-combobox-selected-value="fiction"')
  end

  def test_it_should_handle_object_name_with_model
    book = Book.new(author: "Tolkien")

    component = ShadcnPhlexcomponents::FormCombobox.new(
      :author,
      model: book,
      object_name: :library,
      collection: [
        { value: "Tolkien", text: "J.R.R. Tolkien" },
        { value: "Rowling", text: "J.K. Rowling" },
        { value: "King", text: "Stephen King" },
      ],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, 'name="library[author]"')
    assert_includes(output, 'id="library_author"')
    assert_includes(output, 'data-combobox-selected-value="Tolkien"')
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :technology,
      collection: [{ value: "react", text: "React" }],
      value_method: :value,
      text_method: :text,
      class: "technology-selector",
      id: "custom-tech",
      data: { testid: "form-combobox" },
    )
    output = render(component)

    assert_includes(output, "technology-selector")
    assert_includes(output, 'id="custom-tech"')
    assert_includes(output, 'data-testid="form-combobox"')
    assert_includes(output, 'role="combobox"')
  end

  def test_it_should_handle_explicit_value
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :selected_option,
      value: "option2",
      collection: [
        { value: "option1", text: "Option 1" },
        { value: "option2", text: "Option 2" },
        { value: "option3", text: "Option 3" },
      ],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, "Option 1")
    assert_includes(output, "Option 2")
    assert_includes(output, "Option 3")
    assert_includes(output, 'data-combobox-selected-value="option2"')
  end

  def test_it_should_handle_disabled_items
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :user_role,
      collection: [
        { value: "user", text: "User" },
        { value: "admin", text: "Administrator" },
        { value: "super_admin", text: "Super Administrator" },
      ],
      value_method: :value,
      text_method: :text,
      disabled_items: ["super_admin"],
    )
    output = render(component)

    assert_includes(output, "User")
    assert_includes(output, "Administrator")
    assert_includes(output, "Super Administrator")

    # Check disabled item
    assert_includes(output, "data-disabled")
  end

  def test_it_should_convert_hash_collection_to_struct
    hash_collection = [
      { value: "small", text: "Small" },
      { value: "medium", text: "Medium" },
      { value: "large", text: "Large" },
    ]

    component = ShadcnPhlexcomponents::FormCombobox.new(
      :size,
      collection: hash_collection,
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, "Small")
    assert_includes(output, "Medium")
    assert_includes(output, "Large")
    assert_includes(output, 'data-value="small"')
    assert_includes(output, 'data-value="medium"')
    assert_includes(output, 'data-value="large"')
  end

  def test_it_should_handle_struct_collection
    struct_collection = [
      { value: "xs", text: "Extra Small" },
      { value: "sm", text: "Small" },
      { value: "md", text: "Medium" },
    ]

    component = ShadcnPhlexcomponents::FormCombobox.new(
      :shirt_size,
      collection: struct_collection,
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, "Extra Small")
    assert_includes(output, "Small")
    assert_includes(output, "Medium")
    assert_includes(output, 'data-value="xs"')
    assert_includes(output, 'data-value="sm"')
    assert_includes(output, 'data-value="md"')
  end

  def test_it_should_render_with_label
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :country,
      label: "Select your country",
      collection: [{ value: "us", text: "United States" }],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, "Select your country")
    assert_match(/for="country"/, output)
    assert_match(/id="[^"]*-label"/, output)
  end

  def test_it_should_render_with_hint
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :timezone,
      hint: "Choose your local timezone",
      collection: [{ value: "utc", text: "UTC" }],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, "Choose your local timezone")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    assert_match(/id="[^"]*-description"/, output)
  end

  def test_it_should_render_with_error_from_model
    book = Book.new
    book.valid? # trigger validation errors

    component = ShadcnPhlexcomponents::FormCombobox.new(
      :title,
      model: book,
      collection: [{ value: "Book 1", text: "Book 1" }],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, "Title can&#39;t be blank")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    assert_includes(output, "text-destructive")
  end

  def test_it_should_render_with_explicit_error
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :category,
      error: "Category is required",
      collection: [{ value: "tech", text: "Technology" }],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, "Category is required")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_it_should_render_with_custom_name_and_id
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :preference,
      name: "user_preference",
      id: "preference-selector",
      collection: [{ value: "dark", text: "Dark Mode" }],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, 'name="user_preference"')
    assert_includes(output, 'id="preference-selector"')
  end

  def test_it_should_include_hidden_input
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :hidden_test,
      value: "selected_value",
      collection: [{ value: "selected_value", text: "Selected" }],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'name="hidden_test"')
    assert_includes(output, 'value="selected_value"')
    assert_includes(output, 'data-combobox-target="hiddenInput"')
  end

  def test_it_should_generate_proper_aria_attributes
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :accessibility_test,
      label: "Accessibility Test",
      hint: "Test accessibility features",
      collection: [{ value: "test", text: "Test" }],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_match(/aria-describedby="[^"]*-description"/, output)
    assert_includes(output, 'aria-invalid="false"')
    assert_includes(output, 'role="combobox"')
    assert_includes(output, 'role="listbox"')
  end

  def test_it_should_handle_aria_attributes_with_error
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :required_combobox,
      error: "This field is required",
      collection: [{ value: "option", text: "Option" }],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    assert_includes(output, 'aria-invalid="true"')
    assert_match(/aria-describedby="[^"]*-message"/, output)
  end

  def test_it_should_include_search_functionality
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :searchable_field,
      collection: [{ value: "item1", text: "Item 1" }],
      value_method: :value,
      text_method: :text,
      search_path: "/api/search",
      search_placeholder_text: "Search items...",
      search_empty_text: "No results found",
      search_error_text: "Search failed",
    )
    output = render(component)

    assert_includes(output, 'data-search-path="/api/search"')
    assert_includes(output, 'data-combobox-target="searchInput"')
    assert_includes(output, 'placeholder="Search items..."')
    assert_includes(output, "No results found")
    assert_includes(output, "Search failed")
  end

  def test_it_should_render_complete_combobox_structure
    book = Book.new(category: "vue")

    component = ShadcnPhlexcomponents::FormCombobox.new(
      :category,
      model: book,
      object_name: :project,
      label: "Frontend Framework",
      hint: "Choose the framework for your project",
      collection: [
        { value: "react", text: "⚛️ React" },
        { value: "vue", text: "💚 Vue.js" },
        { value: "angular", text: "🅰️ Angular" },
        { value: "svelte", text: "🧡 Svelte" },
      ],
      value_method: :value,
      text_method: :text,
      disabled_items: ["angular"],
      placeholder: "Select framework...",
      search_path: "/api/frameworks",
      class: "framework-selector",
      data: {
        controller: "combobox analytics",
        analytics_category: "framework_selection",
      },
    )
    output = render(component)

    # Check main structure
    assert_includes(output, "framework-selector")
    assert_includes(output, 'name="project[category]"')
    assert_includes(output, 'id="project_category"')
    assert_includes(output, 'data-combobox-selected-value="vue"')

    # Check Stimulus integration
    assert_match(/data-controller="combobox[^"]*analytics/, output)
    assert_includes(output, 'data-analytics-category="framework_selection"')
    assert_includes(output, 'data-search-path="/api/frameworks"')

    # Check label and hint
    assert_includes(output, "Frontend Framework")
    assert_includes(output, "Choose the framework for your project")

    # Check all options with emojis
    assert_includes(output, "⚛️ React")
    assert_includes(output, "💚 Vue.js")
    assert_includes(output, "🅰️ Angular")
    assert_includes(output, "🧡 Svelte")

    # Check disabled item
    assert_includes(output, "data-disabled")

    # Check search functionality
    assert_includes(output, 'data-placeholder="Select framework..."')
    assert_includes(output, 'data-combobox-target="searchInput"')

    # Check hidden input
    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'value="vue"')

    # Check accessibility
    assert_match(/aria-describedby="[^"]*-description"/, output)
    assert_includes(output, 'aria-invalid="false"')
    assert_includes(output, 'role="combobox"')
    assert_includes(output, 'role="listbox"')
  end

  def test_it_should_handle_empty_collection
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :empty_test,
      collection: [],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    # Should still render container
    assert_includes(output, 'data-controller="combobox"')
    assert_includes(output, 'type="hidden"')
    assert_includes(output, 'name="empty_test"')
  end

  def test_it_should_handle_include_blank_option
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :optional_field,
      collection: [{ value: "option1", text: "Option 1" }],
      value_method: :value,
      text_method: :text,
      include_blank: "-- Select --",
    )
    output = render(component)

    assert_includes(output, "-- Select --")
    assert_includes(output, 'data-value=""')
  end

  def test_it_should_handle_block_content_with_label_and_hint
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :custom_field,
      collection: [{ value: "item", text: "Item" }],
      value_method: :value,
      text_method: :text,
    ) do |combobox|
      combobox.label("Custom Label", class: "font-semibold")
      combobox.hint("Custom hint text", class: "text-sm")
      "Custom combobox content"
    end
    output = render(component)

    assert_includes(output, "Custom Label")
    assert_includes(output, "font-semibold")
    assert_includes(output, "Custom hint text")
    assert_includes(output, "text-sm")
    # NOTE: Block content is not rendered in combobox - it gets consumed

    # Should have data attributes for removing duplicates
    assert_includes(output, "data-remove-hint")
  end
end

class TestFormComboboxIntegration < ComponentTest
  def test_form_combobox_with_complex_model
    # Test with Book model that has a selected category
    book = Book.new(category: "fiction")

    categories = [
      { id: 1, name: "Fiction" },
      { id: 2, name: "Non-Fiction" },
      { id: 3, name: "Mystery" },
    ]

    component = ShadcnPhlexcomponents::FormCombobox.new(
      :category,
      model: book,
      collection: categories,
      value_method: :id,
      text_method: :name,
      label: "Book Category",
      hint: "Select the category for this book",
      class: "category-selector",
    )
    output = render(component)

    # Check proper form integration
    assert_includes(output, 'name="category"')
    assert_includes(output, 'id="category"')
    assert_includes(output, 'data-combobox-selected-value="fiction"')

    # Check all categories are rendered
    assert_includes(output, "Fiction")
    assert_includes(output, "Non-Fiction")
    assert_includes(output, "Mystery")

    # Check form field structure
    assert_includes(output, "category-selector")
    assert_includes(output, "Book Category")
    assert_includes(output, "Select the category for this book")
  end

  def test_form_combobox_accessibility_compliance
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :accessibility_test,
      label: "Accessible Combobox",
      hint: "Use arrow keys to navigate options",
      error: "Please select a valid option",
      collection: [
        { value: "option1", text: "Option 1" },
        { value: "option2", text: "Option 2" },
      ],
      value_method: :value,
      text_method: :text,
      aria: { required: "true" },
    )
    output = render(component)

    # Check ARIA compliance
    assert_includes(output, 'role="combobox"')
    assert_includes(output, 'role="listbox"')
    assert_includes(output, 'role="option"')
    # Check ARIA describedby includes both description and message
    assert_includes(output, "form-field-")
    assert_includes(output, "-description")
    assert_includes(output, "-message")
    # Check error state - should have error message displayed
    assert_includes(output, "Please select a valid option")
    assert_includes(output, "text-destructive")
    assert_includes(output, 'aria-required="true"')

    # Check search input accessibility
    assert_includes(output, 'aria-autocomplete="list"')
    assert_match(/aria-controls="[^"]*-list"/, output)
    assert_match(/aria-labelledby="[^"]*-search-label"/, output)

    # Check label association
    assert_match(/for="accessibility_test"/, output)

    # Check error and hint IDs are properly referenced
    assert_match(/id="[^"]*-description"/, output)
    assert_match(/id="[^"]*-message"/, output)
  end

  def test_form_combobox_with_stimulus_integration
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :dynamic_selection,
      collection: [
        { value: "item1", text: "Dynamic Item 1" },
        { value: "item2", text: "Dynamic Item 2" },
      ],
      value_method: :value,
      text_method: :text,
      search_path: "/api/search",
      data: {
        controller: "combobox dynamic-loader analytics",
        dynamic_loader_api_url: "/api/items",
        analytics_event: "combobox_interaction",
      },
    )
    output = render(component)

    # Check multiple Stimulus controllers
    assert_match(/data-controller="combobox[^"]*dynamic-loader[^"]*analytics/, output)
    assert_includes(output, 'data-dynamic-loader-api-url="/api/items"')
    assert_includes(output, 'data-analytics-event="combobox_interaction"')
    assert_includes(output, 'data-search-path="/api/search"')

    # Check default combobox Stimulus functionality
    assert_includes(output, 'data-combobox-target="trigger"')
    assert_includes(output, 'data-combobox-target="content"')
    assert_includes(output, 'data-combobox-target="hiddenInput"')
  end

  def test_form_combobox_validation_states
    # Test valid state
    valid_component = ShadcnPhlexcomponents::FormCombobox.new(
      :valid_field,
      value: "valid_option",
      collection: [{ value: "valid_option", text: "Valid Option" }],
      value_method: :value,
      text_method: :text,
      class: "valid-combobox",
    )
    valid_output = render(valid_component)

    assert_includes(valid_output, 'aria-invalid="false"')
    assert_includes(valid_output, "valid-combobox")

    # Test invalid state
    invalid_component = ShadcnPhlexcomponents::FormCombobox.new(
      :invalid_field,
      error: "Invalid selection",
      collection: [{ value: "option", text: "Option" }],
      value_method: :value,
      text_method: :text,
      class: "invalid-combobox",
    )
    invalid_output = render(invalid_component)

    assert_includes(invalid_output, 'aria-invalid="true"')
    assert_includes(invalid_output, "text-destructive") # Error styling on label
  end

  def test_form_combobox_with_search_and_filtering
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :searchable_items,
      collection: [
        { value: "apple", text: "🍎 Apple" },
        { value: "banana", text: "🍌 Banana" },
        { value: "cherry", text: "🍒 Cherry" },
        { value: "date", text: "🌴 Date" },
      ],
      value_method: :value,
      text_method: :text,
      value: "banana",
      search_path: "/api/fruits",
      search_placeholder_text: "Search fruits...",
      search_empty_text: "No fruits found",
      search_error_text: "Failed to load fruits",
      include_blank: "-- Choose a fruit --",
      disabled_items: ["date"],
    )
    output = render(component)

    # Check search configuration
    assert_includes(output, 'data-search-path="/api/fruits"')
    assert_includes(output, 'placeholder="Search fruits..."')
    assert_includes(output, "No fruits found")
    assert_includes(output, "Failed to load fruits")

    # Check blank option
    assert_includes(output, "-- Choose a fruit --")
    assert_includes(output, 'data-value=""')

    # Check all items with emojis
    assert_includes(output, "🍎 Apple")
    assert_includes(output, "🍌 Banana")
    assert_includes(output, "🍒 Cherry")
    assert_includes(output, "🌴 Date")

    # Check selected value
    assert_includes(output, 'data-combobox-selected-value="banana"')

    # Check disabled item
    assert_includes(output, "data-disabled")

    # Check search targets
    assert_includes(output, 'data-combobox-target="searchInput"')
    assert_includes(output, 'data-combobox-target="empty"')
    assert_includes(output, 'data-combobox-target="error"')
  end

  def test_form_combobox_keyboard_interaction
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :keyboard_test,
      collection: [{ value: "option", text: "Option" }],
      value_method: :value,
      text_method: :text,
    )
    output = render(component)

    # Check keyboard interaction setup on trigger
    assert_match(/click->combobox#toggle/, output)
    assert_match(/keydown\.down->combobox#open:prevent/, output)

    # Check keyboard interaction on content
    assert_match(/keydown\.up->combobox#highlightItem:prevent/, output)
    assert_match(/keydown\.down->combobox#highlightItem:prevent/, output)
    assert_match(/keydown\.enter->combobox#select:prevent/, output)
    assert_match(/combobox:click:outside->combobox#clickOutside/, output)
  end

  def test_form_combobox_with_complex_content_structure
    component = ShadcnPhlexcomponents::FormCombobox.new(
      :complex_selection,
      collection: [
        { value: "frontend", text: "Frontend Development" },
        { value: "backend", text: "Backend Development" },
        { value: "fullstack", text: "Full Stack Development" },
        { value: "mobile", text: "Mobile Development" },
        { value: "devops", text: "DevOps Engineering" },
      ],
      value_method: :value,
      text_method: :text,
      value: "fullstack",
      label: "Development Specialization",
      hint: "Choose your primary area of expertise",
      placeholder: "Select specialization...",
      search_path: "/api/specializations",
      search_placeholder_text: "Search specializations...",
      class: "specialization-selector min-w-[300px]",
    )
    output = render(component)

    # Check combobox structure with trigger and content
    assert_includes(output, 'role="combobox"')
    assert_includes(output, 'role="listbox"')
    assert_includes(output, 'data-placeholder="Select specialization..."')

    # Check all development options
    assert_includes(output, "Frontend Development")
    assert_includes(output, "Backend Development")
    assert_includes(output, "Full Stack Development")
    assert_includes(output, "Mobile Development")
    assert_includes(output, "DevOps Engineering")

    # Check selected value handling
    assert_includes(output, 'data-combobox-selected-value="fullstack"')
    assert_includes(output, 'data-has-value="true"')

    # Check search functionality
    assert_includes(output, 'data-search-path="/api/specializations"')
    assert_includes(output, 'placeholder="Search specializations..."')

    # Check content container and list structure
    assert_includes(output, 'data-combobox-target="content"')
    assert_includes(output, 'data-combobox-target="list"')
    assert_includes(output, 'data-combobox-target="listContainer"')
    assert_includes(output, "max-h-80 overflow-y-auto")

    # Check custom styling
    assert_includes(output, "specialization-selector min-w-[300px]")
  end

  def test_form_combobox_form_integration_workflow
    # Test complete form workflow with validation and model binding

    categories = [
      { value: "fiction", text: "Fiction" },
      { value: "non-fiction", text: "Non-Fiction" },
      { value: "mystery", text: "Mystery" },
    ]

    # Valid book with category selected
    valid_book = Book.new(category: "fiction")

    country_combobox = ShadcnPhlexcomponents::FormCombobox.new(
      :category,
      model: valid_book,
      collection: categories,
      value_method: :value,
      text_method: :text,
      label: "Category",
      hint: "Select your category",
    )
    country_output = render(country_combobox)

    assert_includes(country_output, 'data-combobox-selected-value="fiction"')
    assert_includes(country_output, 'aria-invalid="false"')
    refute_includes(country_output, "text-destructive")

    # Invalid book with validation error
    invalid_book = Book.new
    invalid_book.valid? # trigger validation errors

    timezone_combobox = ShadcnPhlexcomponents::FormCombobox.new(
      :title,
      model: invalid_book,
      collection: [{ value: "Book 1", text: "Book 1" }],
      value_method: :value,
      text_method: :text,
      label: "Title",
      hint: "Select your title",
    )
    timezone_output = render(timezone_combobox)

    refute_includes(timezone_output, "data-combobox-selected-value")
    assert_includes(timezone_output, 'aria-invalid="true"')
    assert_includes(timezone_output, "Title can&#39;t be blank")
    assert_includes(timezone_output, "text-destructive")
  end
end
