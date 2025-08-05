# frozen_string_literal: true

require "test_helper"

class TestFormInput < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::FormInput.new(
      :username,
    ) { "Input content" }
    output = render(component)

    # NOTE: Block content is consumed by vanish method and not rendered
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-input input"')
    assert_includes(output, 'name="username"')
    assert_includes(output, 'id="username"')
    assert_includes(output, 'type="text"')
    assert_match(%r{<div[^>]*>.*</div>}m, output)
  end

  def test_it_should_render_with_model_and_method
    book = Book.new(title: "Sample Book")

    component = ShadcnPhlexcomponents::FormInput.new(
      :title,
      model: book,
    ) { "Enter book title" }
    output = render(component)

    # NOTE: Block content is not rendered in FormInput, it's consumed by vanish method
    assert_includes(output, 'name="title"')
    assert_includes(output, 'id="title"')
    assert_includes(output, 'value="Sample Book"')
    assert_includes(output, 'type="text"')
  end

  def test_it_should_handle_object_name_with_model
    book = Book.new(title: "Test Title")

    component = ShadcnPhlexcomponents::FormInput.new(
      :title,
      model: book,
      object_name: :book_settings,
    ) { "Enter title" }
    output = render(component)

    assert_includes(output, 'name="book_settings[title]"')
    assert_includes(output, 'id="book_settings_title"')
    assert_includes(output, 'value="Test Title"')
    # NOTE: Block content is not rendered in FormInput, it's consumed by vanish method
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::FormInput.new(
      :email,
      class: "email-input",
      id: "custom-email",
      data: { testid: "form-input" },
    ) { "Enter email" }
    output = render(component)

    assert_includes(output, "email-input")
    assert_includes(output, 'id="custom-email"')
    assert_includes(output, 'data-testid="form-input"')
    # NOTE: Block content is not rendered in FormInput, it's consumed by vanish method
  end

  def test_it_should_handle_explicit_value
    component = ShadcnPhlexcomponents::FormInput.new(
      :username,
      value: "john_doe",
    ) { "Enter username" }
    output = render(component)

    assert_includes(output, 'name="username"')
    assert_includes(output, 'value="john_doe"')
    assert_includes(output, 'type="text"')
  end

  def test_it_should_render_with_label
    component = ShadcnPhlexcomponents::FormInput.new(
      :full_name,
      label: "Full Name",
    ) { "Enter your full name" }
    output = render(component)

    assert_includes(output, "Full Name")
    # NOTE: Block content is not rendered in FormInput, it's consumed by vanish method
    assert_match(/for="full_name"/, output)
  end

  def test_it_should_render_with_hint
    component = ShadcnPhlexcomponents::FormInput.new(
      :password,
      hint: "Must be at least 8 characters",
    ) { "Enter password" }
    output = render(component)

    assert_includes(output, "Must be at least 8 characters")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    assert_match(/id="[^"]*-description"/, output)
  end

  def test_it_should_render_with_error_from_model
    book = Book.new
    book.valid? # trigger validation errors

    component = ShadcnPhlexcomponents::FormInput.new(
      :title,
      model: book,
    ) { "This field is required" }
    output = render(component)

    # Check if there are any errors on title field
    if book.errors[:title].any?
      # HTML encoding changes apostrophes
      expected_error = book.errors[:title].first.gsub("'", "&#39;")
      assert_includes(output, expected_error)
      assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
      assert_includes(output, "text-destructive")
    else
      # If no errors on title field, test with a book that has errors
      book.errors.add(:title, "can't be blank")
      component = ShadcnPhlexcomponents::FormInput.new(
        :title,
        model: book,
      )
      output = render(component)
      assert_includes(output, "can&#39;t be blank")
      assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    end
  end

  def test_it_should_render_with_explicit_error
    component = ShadcnPhlexcomponents::FormInput.new(
      :email,
      error: "Email format is invalid",
    ) { "Enter email address" }
    output = render(component)

    assert_includes(output, "Email format is invalid")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_it_should_render_with_custom_name_and_id
    component = ShadcnPhlexcomponents::FormInput.new(
      :username,
      name: "custom_username",
      id: "username-field",
    ) { "Enter username" }
    output = render(component)

    assert_includes(output, 'name="custom_username"')
    assert_includes(output, 'id="username-field"')
  end

  def test_it_should_handle_different_input_types
    # Test text input (default)
    text_component = ShadcnPhlexcomponents::FormInput.new(
      :name,
      type: :text,
    )
    text_output = render(text_component)
    assert_includes(text_output, 'type="text"')

    # Test email input
    email_component = ShadcnPhlexcomponents::FormInput.new(
      :email,
      type: :email,
    )
    email_output = render(email_component)
    assert_includes(email_output, 'type="email"')

    # Test password input
    password_component = ShadcnPhlexcomponents::FormInput.new(
      :password,
      type: :password,
    )
    password_output = render(password_component)
    assert_includes(password_output, 'type="password"')

    # Test number input
    number_component = ShadcnPhlexcomponents::FormInput.new(
      :age,
      type: :number,
    )
    number_output = render(number_component)
    assert_includes(number_output, 'type="number"')
  end

  def test_it_should_generate_proper_aria_attributes
    component = ShadcnPhlexcomponents::FormInput.new(
      :accessibility_test,
      label: "Accessible Input Field",
      hint: "Enter your information here",
    ) { "Enter data" }
    output = render(component)

    assert_match(/aria-describedby="[^"]*-description"/, output)
    assert_includes(output, 'aria-invalid="false"')
  end

  def test_it_should_handle_aria_attributes_with_error
    component = ShadcnPhlexcomponents::FormInput.new(
      :required_field,
      error: "This field is required",
    ) { "Required field" }
    output = render(component)

    assert_includes(output, 'aria-invalid="true"')
    assert_match(/aria-describedby="[^"]*-message"/, output)
  end

  def test_it_should_render_complete_form_structure
    book = Book.new(title: "Existing Title")

    component = ShadcnPhlexcomponents::FormInput.new(
      :title,
      model: book,
      object_name: :book,
      label: "Book Title",
      hint: "Enter the title of your book",
      value: "Override Title", # explicit value should override model
      class: "book-title-input",
      data: {
        controller: "input-validation analytics",
        analytics_event: "input_change",
      },
      placeholder: "Enter book title",
      required: true,
    ) { "Enter book title" }
    output = render(component)

    # Check main structure
    assert_includes(output, "book-title-input")
    assert_includes(output, 'name="book[title]"')
    assert_includes(output, 'id="book_title"')

    # Explicit value should be used (not model value)
    assert_includes(output, 'value="Override Title"')

    # Check form field components
    assert_includes(output, "Book Title")
    assert_includes(output, "Enter the title of your book")
    # NOTE: Block content is not rendered in FormInput

    # Check Stimulus integration
    assert_match(/data-controller="[^"]*input-validation[^"]*analytics/, output)
    assert_includes(output, 'data-analytics-event="input_change"')

    # Check input specific attributes
    assert_includes(output, 'placeholder="Enter book title"')
    assert_includes(output, "required")

    # Check accessibility
    assert_match(/aria-describedby="[^"]*-description"/, output)
    assert_includes(output, 'aria-invalid="false"')

    # Check FormField wrapper
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::FormInput.new(
      :disabled_field,
      disabled: true,
    ) { "Disabled input" }
    output = render(component)

    assert_includes(output, "disabled")
  end

  def test_it_should_handle_readonly_state
    component = ShadcnPhlexcomponents::FormInput.new(
      :readonly_field,
      readonly: true,
      value: "Read only value",
    )
    output = render(component)

    assert_includes(output, "readonly")
    assert_includes(output, 'value="Read only value"')
  end

  def test_it_should_handle_placeholder
    component = ShadcnPhlexcomponents::FormInput.new(
      :search_field,
      placeholder: "Search for something...",
    )
    output = render(component)

    assert_includes(output, 'placeholder="Search for something..."')
  end

  def test_it_should_handle_min_max_attributes
    component = ShadcnPhlexcomponents::FormInput.new(
      :age,
      type: :number,
      min: 0,
      max: 120,
    )
    output = render(component)

    assert_includes(output, 'type="number"')
    assert_includes(output, 'min="0"')
    assert_includes(output, 'max="120"')
  end

  def test_it_should_handle_block_content_with_label_and_hint
    component = ShadcnPhlexcomponents::FormInput.new(
      :custom_field,
    ) do |input|
      input.label("Custom Field Label", class: "font-semibold")
      input.hint("Custom hint text", class: "text-sm text-gray-500")
      "Custom input content"
    end
    output = render(component)

    assert_includes(output, "Custom Field Label")
    assert_includes(output, "font-semibold")
    assert_includes(output, "Custom hint text")
    assert_includes(output, "text-sm text-gray-500")
    # NOTE: Block content is not rendered in FormInput, the returned string is consumed by vanish method

    # Should have data attributes for removing duplicates
    assert_includes(output, "data-remove-hint")
  end
end

class TestFormInputIntegration < ComponentTest
  def test_form_input_with_complex_model
    # Use Book with various attributes
    book = Book.new(
      title: "Sample Book Title",
      author: "John Doe",
      category: "fiction",
    )

    # Test title input
    title_component = ShadcnPhlexcomponents::FormInput.new(
      :title,
      model: book,
      object_name: :book,
      label: "Book Title",
      hint: "Enter the full title of the book",
      class: "book-title",
    ) { "Enter book title" }
    title_output = render(title_component)

    # Check proper model integration
    assert_includes(title_output, 'name="book[title]"')
    assert_includes(title_output, 'id="book_title"')
    assert_includes(title_output, 'value="Sample Book Title"')

    # Author input
    author_component = ShadcnPhlexcomponents::FormInput.new(
      :author,
      model: book,
      object_name: :book,
      label: "Author",
      type: :text,
    ) { "Enter author name" }
    author_output = render(author_component)

    assert_includes(author_output, 'name="book[author]"')
    assert_includes(author_output, 'value="John Doe"')
    assert_includes(author_output, 'type="text"')

    # Category input
    category_component = ShadcnPhlexcomponents::FormInput.new(
      :category,
      model: book,
      object_name: :book,
      label: "Category",
      type: :text,
    ) { "Enter category" }
    category_output = render(category_component)

    assert_includes(category_output, 'name="book[category]"')
    assert_includes(category_output, 'value="fiction"')
    assert_includes(category_output, 'type="text"')

    # Check form field structure
    assert_includes(title_output, "book-title")
    assert_includes(title_output, "Book Title")
    assert_includes(title_output, "Enter the full title of the book")
  end

  def test_form_input_accessibility_compliance
    component = ShadcnPhlexcomponents::FormInput.new(
      :accessibility_test,
      label: "Accessible Input Field",
      hint: "Use clear and descriptive text",
      error: "Please enter a valid value",
      aria: { required: "true" },
    ) { "Enter value" }
    output = render(component)

    # Check ARIA compliance
    # Check ARIA describedby includes both description and message IDs
    assert_includes(output, "form-field-")
    assert_includes(output, "-description")
    assert_includes(output, "-message")
    # Check error state is properly displayed
    assert_includes(output, "Please enter a valid value")
    assert_includes(output, "text-destructive")
    assert_includes(output, 'aria-required="true"')

    # Check label association
    assert_match(/for="accessibility_test"/, output)

    # Check error and hint IDs are properly referenced
    assert_match(/id="[^"]*-description"/, output)
    assert_match(/id="[^"]*-message"/, output)

    # Check proper label styling for error state
    assert_includes(output, "text-destructive")
  end

  def test_form_input_with_stimulus_integration
    component = ShadcnPhlexcomponents::FormInput.new(
      :stimulus_field,
      data: {
        controller: "input-validation analytics formatter",
        analytics_category: "form_input",
        formatter_type_value: "currency",
      },
    ) { "Enter amount" }
    output = render(component)

    # Check multiple Stimulus controllers
    assert_match(/data-controller="[^"]*input-validation[^"]*analytics[^"]*formatter/, output)
    assert_includes(output, 'data-analytics-category="form_input"')
    assert_includes(output, 'data-formatter-type-value="currency"')
  end

  def test_form_input_validation_states
    # Test valid state
    valid_component = ShadcnPhlexcomponents::FormInput.new(
      :valid_field,
      value: "Valid input",
      class: "valid-input",
    ) { "Valid field" }
    valid_output = render(valid_component)

    assert_includes(valid_output, 'aria-invalid="false"')
    assert_includes(valid_output, "valid-input")

    # Test invalid state
    invalid_component = ShadcnPhlexcomponents::FormInput.new(
      :invalid_field,
      error: "Invalid input provided",
      class: "invalid-input",
    ) { "Invalid field" }
    invalid_output = render(invalid_component)

    assert_includes(invalid_output, 'aria-invalid="true"')
    assert_includes(invalid_output, "text-destructive") # Error styling on label
  end

  def test_form_input_form_integration_workflow
    # Test complete form workflow with validation and model binding

    # Valid book with data
    valid_book = Book.new(title: "Valid Book Title")

    input_field = ShadcnPhlexcomponents::FormInput.new(
      :title,
      model: valid_book,
      label: "Book Title",
      hint: "Enter the book title",
    )
    input_output = render(input_field)

    assert_includes(input_output, 'value="Valid Book Title"')
    assert_includes(input_output, 'aria-invalid="false"')
    refute_includes(input_output, "text-destructive")

    # Invalid book with validation error
    invalid_book = Book.new
    invalid_book.errors.add(:title, "can't be blank")

    invalid_input = ShadcnPhlexcomponents::FormInput.new(
      :title,
      model: invalid_book,
      label: "Book Title",
      hint: "Enter the book title",
    )
    invalid_output = render(invalid_input)

    refute_includes(invalid_output, "value=")
    assert_includes(invalid_output, 'aria-invalid="true"')
    assert_includes(invalid_output, "can&#39;t be blank")
    assert_includes(invalid_output, "text-destructive")
  end

  def test_form_input_with_custom_styling
    component = ShadcnPhlexcomponents::FormInput.new(
      :styled_field,
      value: "Custom styled input",
      label: "Styled Input Field",
      hint: "This input has custom styling",
      class: "w-full max-w-md custom-input border-2",
      data: { theme: "primary" },
    ) { "Custom styled input content" }
    output = render(component)

    # Check custom styling is applied
    assert_includes(output, "w-full max-w-md custom-input border-2")
    assert_includes(output, 'data-theme="primary"')

    # Check form field structure is preserved
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, "Styled Input Field")
    assert_includes(output, "This input has custom styling")
  end

  def test_form_input_with_different_input_types_integration
    # Test email field with validation
    email_component = ShadcnPhlexcomponents::FormInput.new(
      :email,
      type: :email,
      label: "Email Address",
      hint: "We'll never share your email",
      placeholder: "you@example.com",
      required: true,
    )
    email_output = render(email_component)

    assert_includes(email_output, 'type="email"')
    assert_includes(email_output, 'placeholder="you@example.com"')
    assert_includes(email_output, "required")

    # Test password field with security attributes
    password_component = ShadcnPhlexcomponents::FormInput.new(
      :password,
      type: :password,
      label: "Password",
      hint: "Must be at least 8 characters",
      autocomplete: "new-password",
    )
    password_output = render(password_component)

    assert_includes(password_output, 'type="password"')
    assert_includes(password_output, 'autocomplete="new-password"')

    # Test search field with special attributes
    search_component = ShadcnPhlexcomponents::FormInput.new(
      :search,
      type: :search,
      label: "Search",
      placeholder: "Search books...",
      "aria-label": "Search through book collection",
    )
    search_output = render(search_component)

    assert_includes(search_output, 'type="search"')
    assert_includes(search_output, 'placeholder="Search books..."')
    assert_includes(search_output, 'aria-label="Search through book collection"')
  end

  def test_form_input_with_file_upload
    # Test file input type
    file_component = ShadcnPhlexcomponents::FormInput.new(
      :attachment,
      type: :file,
      label: "Upload File",
      hint: "Select a file to upload",
      accept: ".pdf,.doc,.docx",
    )
    file_output = render(file_component)

    assert_includes(file_output, 'type="file"')
    assert_includes(file_output, 'accept=".pdf,.doc,.docx"')
    assert_includes(file_output, "Upload File")
    assert_includes(file_output, "Select a file to upload")
  end

  def test_form_input_with_data_attributes_and_validation
    component = ShadcnPhlexcomponents::FormInput.new(
      :validated_field,
      label: "Validated Field",
      data: {
        controller: "validation",
        validation_rules: "required|min:3|max:50",
        validation_target: "input",
      },
      "data-validation-message": "Please enter a valid value",
    )
    output = render(component)

    # Check validation data attributes
    assert_match(/data-controller="[^"]*validation/, output)
    assert_includes(output, 'data-validation-rules="required|min:3|max:50"')
    assert_includes(output, 'data-validation-target="input"')
    assert_includes(output, 'data-validation-message="Please enter a valid value"')
  end

  def test_form_input_keyboard_and_focus_management
    component = ShadcnPhlexcomponents::FormInput.new(
      :focus_test,
      autofocus: true,
      tabindex: 1,
    ) { "Focus test" }
    output = render(component)

    # Check focus management attributes
    assert_includes(output, "autofocus")
    assert_includes(output, 'tabindex="1"')
  end
end
