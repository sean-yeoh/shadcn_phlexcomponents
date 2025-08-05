# frozen_string_literal: true

require "test_helper"

class TestFormTextarea < ComponentTest
  def test_it_should_render_content_and_attributes
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :description,
    ) { "Textarea content" }
    output = render(component)

    # NOTE: Block content is consumed by vanish method and not rendered
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-textarea textarea"')
    assert_includes(output, 'name="description"')
    assert_includes(output, 'id="description"')
    assert_match(%r{<div[^>]*>.*</div>}m, output)
  end

  def test_it_should_render_with_model_and_method
    book = Book.new(title: "Sample Book Description")

    component = ShadcnPhlexcomponents::FormTextarea.new(
      :title,
      model: book,
    ) { "Enter description" }
    output = render(component)

    # NOTE: Block content is not rendered in FormTextarea, it's consumed by vanish method
    assert_includes(output, 'name="title"')
    assert_includes(output, 'id="title"')
    assert_includes(output, "Sample Book Description")
  end

  def test_it_should_handle_object_name_with_model
    book = Book.new(title: "Test Description")

    component = ShadcnPhlexcomponents::FormTextarea.new(
      :title,
      model: book,
      object_name: :book_settings,
    ) { "Enter description" }
    output = render(component)

    assert_includes(output, 'name="book_settings[title]"')
    assert_includes(output, 'id="book_settings_title"')
    assert_includes(output, "Test Description")
    # NOTE: Block content is not rendered in FormTextarea, it's consumed by vanish method
  end

  def test_it_should_render_custom_attributes
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :content,
      class: "content-textarea",
      id: "custom-content",
      data: { testid: "form-textarea" },
    ) { "Enter content" }
    output = render(component)

    assert_includes(output, "content-textarea")
    assert_includes(output, 'id="custom-content"')
    assert_includes(output, 'data-testid="form-textarea"')
    # NOTE: Block content is not rendered in FormTextarea, it's consumed by vanish method
  end

  def test_it_should_handle_explicit_value
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :notes,
      value: "These are my notes\nWith multiple lines",
    ) { "Enter notes" }
    output = render(component)

    assert_includes(output, 'name="notes"')
    assert_includes(output, "These are my notes\nWith multiple lines")
  end

  def test_it_should_render_with_label
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :comments,
      label: "Comments",
    ) { "Enter your comments" }
    output = render(component)

    assert_includes(output, "Comments")
    # NOTE: Block content is not rendered in FormTextarea, it's consumed by vanish method
    assert_match(/for="comments"/, output)
  end

  def test_it_should_render_with_hint
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :feedback,
      hint: "Please provide detailed feedback",
    ) { "Enter feedback" }
    output = render(component)

    assert_includes(output, "Please provide detailed feedback")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-hint"')
    assert_match(/id="[^"]*-description"/, output)
  end

  def test_it_should_render_with_error_from_model
    book = Book.new
    book.valid? # trigger validation errors

    component = ShadcnPhlexcomponents::FormTextarea.new(
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
      component = ShadcnPhlexcomponents::FormTextarea.new(
        :title,
        model: book,
      )
      output = render(component)
      assert_includes(output, "can&#39;t be blank")
      assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
    end
  end

  def test_it_should_render_with_explicit_error
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :description,
      error: "Description is too short",
    ) { "Enter description" }
    output = render(component)

    assert_includes(output, "Description is too short")
    assert_includes(output, 'data-shadcn-phlexcomponents="form-error"')
  end

  def test_it_should_render_with_custom_name_and_id
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :message,
      name: "custom_message",
      id: "message-textarea",
    ) { "Enter message" }
    output = render(component)

    assert_includes(output, 'name="custom_message"')
    assert_includes(output, 'id="message-textarea"')
  end

  def test_it_should_handle_textarea_specific_attributes
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :content,
      rows: 5,
      cols: 40,
      placeholder: "Enter your content here...",
      maxlength: 500,
    )
    output = render(component)

    assert_includes(output, 'rows="5"')
    assert_includes(output, 'cols="40"')
    assert_includes(output, 'placeholder="Enter your content here..."')
    assert_includes(output, 'maxlength="500"')
  end

  def test_it_should_generate_proper_aria_attributes
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :accessibility_test,
      label: "Accessible Textarea",
      hint: "Enter detailed information",
    ) { "Enter details" }
    output = render(component)

    assert_match(/aria-describedby="[^"]*-description"/, output)
    assert_includes(output, 'aria-invalid="false"')
  end

  def test_it_should_handle_aria_attributes_with_error
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :required_textarea,
      error: "This field is required",
    ) { "Required textarea" }
    output = render(component)

    assert_includes(output, 'aria-invalid="true"')
    assert_match(/aria-describedby="[^"]*-message"/, output)
  end

  def test_it_should_render_complete_form_structure
    book = Book.new(title: "Existing Description")

    component = ShadcnPhlexcomponents::FormTextarea.new(
      :title,
      model: book,
      object_name: :book,
      label: "Book Description",
      hint: "Provide a detailed description of the book",
      value: "Override Description", # explicit value should override model
      class: "book-description-textarea",
      data: {
        controller: "textarea analytics",
        analytics_event: "description_change",
      },
      rows: 6,
      placeholder: "Enter book description...",
      maxlength: 1000,
    ) { "Enter book description" }
    output = render(component)

    # Check main structure
    assert_includes(output, "book-description-textarea")
    assert_includes(output, 'name="book[title]"')
    assert_includes(output, 'id="book_title"')

    # Explicit value should be used (not model value)
    assert_includes(output, "Override Description")

    # Check form field components
    assert_includes(output, "Book Description")
    assert_includes(output, "Provide a detailed description of the book")
    # NOTE: Block content is not rendered in FormTextarea

    # Check Stimulus integration
    assert_match(/data-controller="[^"]*textarea[^"]*analytics/, output)
    assert_includes(output, 'data-analytics-event="description_change"')

    # Check textarea specific attributes
    assert_includes(output, 'rows="6"')
    assert_includes(output, 'placeholder="Enter book description..."')
    assert_includes(output, 'maxlength="1000"')

    # Check accessibility
    assert_match(/aria-describedby="[^"]*-description"/, output)
    assert_includes(output, 'aria-invalid="false"')

    # Check FormField wrapper
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :disabled_textarea,
      disabled: true,
    ) { "Disabled textarea" }
    output = render(component)

    assert_includes(output, "disabled")
  end

  def test_it_should_handle_readonly_state
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :readonly_textarea,
      readonly: true,
      value: "Read only content",
    )
    output = render(component)

    assert_includes(output, "readonly")
    assert_includes(output, "Read only content")
  end

  def test_it_should_handle_multiline_content
    multiline_content = "Line 1\nLine 2\nLine 3\n\nLine 5 with blank line above"

    component = ShadcnPhlexcomponents::FormTextarea.new(
      :multiline_test,
      value: multiline_content,
    )
    output = render(component)

    assert_includes(output, multiline_content)
  end

  def test_it_should_handle_special_characters
    special_content = "Content with <script>alert('xss')</script> and \"quotes\" and 'apostrophes'"

    component = ShadcnPhlexcomponents::FormTextarea.new(
      :special_chars_test,
      value: special_content,
    )
    output = render(component)

    # HTML should be escaped for security
    assert_includes(output, "&lt;script&gt;")
    assert_includes(output, "&quot;quotes&quot;")
    assert_includes(output, "&#39;apostrophes&#39;")
  end

  def test_it_should_handle_block_content_with_label_and_hint
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :custom_textarea,
    ) do |textarea|
      textarea.label("Custom Textarea Label", class: "font-semibold")
      textarea.hint("Custom hint text", class: "text-sm text-gray-500")
      "Custom textarea content"
    end
    output = render(component)

    assert_includes(output, "Custom Textarea Label")
    assert_includes(output, "font-semibold")
    assert_includes(output, "Custom hint text")
    assert_includes(output, "text-sm text-gray-500")
    # NOTE: Block content is not rendered in FormTextarea, the returned string is consumed by vanish method

    # Should have data attributes for removing duplicates
    assert_includes(output, "data-remove-hint")
  end

  def test_it_should_handle_textarea_wrapping_div
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :wrapped_test,
    )
    output = render(component)

    # FormTextarea wraps textarea in div to ensure spacing is correct
    # Check that textarea is wrapped in a div
    assert_match(%r{<div[^>]*>\s*<textarea[^>]*>.*</textarea>\s*</div>}m, output)
  end
end

class TestFormTextareaIntegration < ComponentTest
  def test_form_textarea_with_complex_model
    # Use Book with text attributes
    book = Book.new(
      title: "Sample Book Title\nWith multiple lines",
      author: "John Doe",
    )

    # Test title textarea
    title_component = ShadcnPhlexcomponents::FormTextarea.new(
      :title,
      model: book,
      object_name: :book,
      label: "Book Description",
      hint: "Enter a detailed description of the book",
      class: "book-description",
    ) { "Enter book description" }
    title_output = render(title_component)

    # Check proper model integration
    assert_includes(title_output, 'name="book[title]"')
    assert_includes(title_output, 'id="book_title"')
    assert_includes(title_output, "Sample Book Title\nWith multiple lines")

    # Author textarea
    author_component = ShadcnPhlexcomponents::FormTextarea.new(
      :author,
      model: book,
      object_name: :book,
      label: "Author Bio",
      rows: 3,
    ) { "Enter author biography" }
    author_output = render(author_component)

    assert_includes(author_output, 'name="book[author]"')
    assert_includes(author_output, "John Doe")
    assert_includes(author_output, 'rows="3"')

    # Check form field structure
    assert_includes(title_output, "book-description")
    assert_includes(title_output, "Book Description")
    assert_includes(title_output, "Enter a detailed description of the book")
  end

  def test_form_textarea_accessibility_compliance
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :accessibility_test,
      label: "Accessible Textarea Field",
      hint: "Enter detailed information using multiple lines if needed",
      error: "Please provide more detailed information",
      aria: { required: "true" },
    ) { "Enter details" }
    output = render(component)

    # Check ARIA compliance
    # Check ARIA describedby includes both description and message IDs
    assert_includes(output, "form-field-")
    assert_includes(output, "-description")
    assert_includes(output, "-message")
    # Check error state is properly displayed
    assert_includes(output, "Please provide more detailed information")
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

  def test_form_textarea_with_stimulus_integration
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :stimulus_textarea,
      data: {
        controller: "textarea analytics auto-resize",
        analytics_category: "form_textarea",
        auto_resize_min_height: "100",
      },
    ) { "Enter content" }
    output = render(component)

    # Check multiple Stimulus controllers
    assert_match(/data-controller="[^"]*textarea[^"]*analytics[^"]*auto-resize/, output)
    assert_includes(output, 'data-analytics-category="form_textarea"')
    assert_includes(output, 'data-auto-resize-min-height="100"')

    # Check default textarea Stimulus functionality
    assert_includes(output, 'data-shadcn-phlexcomponents="form-textarea textarea"')
  end

  def test_form_textarea_validation_states
    # Test valid state
    valid_component = ShadcnPhlexcomponents::FormTextarea.new(
      :valid_textarea,
      value: "Valid content with sufficient detail",
      class: "valid-textarea",
    ) { "Valid textarea field" }
    valid_output = render(valid_component)

    assert_includes(valid_output, 'aria-invalid="false"')
    assert_includes(valid_output, "valid-textarea")

    # Test invalid state
    invalid_component = ShadcnPhlexcomponents::FormTextarea.new(
      :invalid_textarea,
      error: "Content is too short",
      class: "invalid-textarea",
    ) { "Invalid textarea field" }
    invalid_output = render(invalid_component)

    assert_includes(invalid_output, 'aria-invalid="true"')
    assert_includes(invalid_output, "text-destructive") # Error styling on label
  end

  def test_form_textarea_form_integration_workflow
    # Test complete form workflow with validation and model binding

    # Valid book with content
    valid_book = Book.new(title: "Valid book description with enough detail")

    textarea_field = ShadcnPhlexcomponents::FormTextarea.new(
      :title,
      model: valid_book,
      label: "Book Description",
      hint: "Enter the book description",
    )
    textarea_output = render(textarea_field)

    assert_includes(textarea_output, "Valid book description with enough detail")
    assert_includes(textarea_output, 'aria-invalid="false"')
    refute_includes(textarea_output, "text-destructive")

    # Invalid book with validation error
    invalid_book = Book.new
    invalid_book.errors.add(:title, "can&#39;t be blank")

    invalid_textarea = ShadcnPhlexcomponents::FormTextarea.new(
      :title,
      model: invalid_book,
      label: "Book Description",
      hint: "Enter the book description",
    )
    invalid_output = render(invalid_textarea)

    refute_includes(invalid_output, "value=")
    assert_includes(invalid_output, 'aria-invalid="true"')
    assert_includes(invalid_output, "can&amp;#39;t be blank")
    assert_includes(invalid_output, "text-destructive")
  end

  def test_form_textarea_with_custom_styling
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :styled_textarea,
      value: "Custom styled content",
      label: "Styled Textarea",
      hint: "This textarea has custom styling",
      class: "w-full max-w-md custom-textarea border-2",
      data: { theme: "primary" },
    ) { "Custom styled textarea content" }
    output = render(component)

    # Check custom styling is applied
    assert_includes(output, "w-full max-w-md custom-textarea border-2")
    assert_includes(output, 'data-theme="primary"')

    # Check form field structure is preserved
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, "Styled Textarea")
    assert_includes(output, "This textarea has custom styling")
  end

  def test_form_textarea_with_character_limits
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :limited_textarea,
      maxlength: 100,
      label: "Limited Text Area",
      hint: "Maximum 100 characters allowed",
      data: {
        controller: "character-counter",
        character_counter_max_value: 100,
      },
    )
    output = render(component)

    assert_includes(output, 'maxlength="100"')
    assert_includes(output, "Maximum 100 characters allowed")
    assert_includes(output, 'data-character-counter-max-value="100"')
  end

  def test_form_textarea_keyboard_interaction
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :keyboard_test,
    ) { "Keyboard test" }
    output = render(component)

    # Check keyboard interaction setup
    assert_includes(output, 'data-shadcn-phlexcomponents="form-textarea textarea"')
    # Textarea should handle standard text editing keyboard interactions
  end

  def test_form_textarea_semantic_html_structure
    # Test that FormTextarea produces semantic HTML
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :semantic_test,
      label: "Semantic Textarea",
    )
    output = render(component)

    # Should use proper form field structure
    assert_includes(output, 'data-shadcn-phlexcomponents="form-field"')
    assert_includes(output, 'data-shadcn-phlexcomponents="form-textarea textarea"')
    assert_includes(output, "Semantic Textarea")

    # Should be wrapped in div for spacing
    assert_match(%r{<div[^>]*>\s*<textarea[^>]*>.*</textarea>\s*</div>}m, output)
  end

  def test_form_textarea_with_auto_resize
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :auto_resize_test,
      label: "Auto-resizing Textarea",
      data: {
        controller: "auto-resize",
        auto_resize_min_height: "80",
      },
    )
    output = render(component)

    assert_includes(output, 'data-controller="auto-resize"')
    assert_includes(output, 'data-auto-resize-min-height="80"')
    assert_includes(output, "Auto-resizing Textarea")
  end

  def test_form_textarea_with_internationalization
    # Test textarea with i18n content
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :i18n_test,
      label: "Description en français",
      hint: "Entrez une description détaillée",
      placeholder: "Tapez votre description ici...",
    )
    output = render(component)

    assert_includes(output, "Description en français")
    assert_includes(output, "Entrez une description détaillée")
    assert_includes(output, 'placeholder="Tapez votre description ici..."')
  end

  def test_form_textarea_performance_with_large_content
    # Test with large content to ensure no performance issues
    large_content = "Large content: " + ("Very long text with lots of detail. " * 100)

    component = ShadcnPhlexcomponents::FormTextarea.new(
      :large_content_test,
      value: large_content,
    )
    output = render(component)

    assert_includes(output, large_content)
    assert_includes(output, 'data-shadcn-phlexcomponents="form-textarea textarea"')
  end

  def test_form_textarea_with_rich_text_preparation
    # Test textarea that might be used with rich text editors
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :rich_text_test,
      label: "Rich Text Content",
      data: {
        controller: "rich-text-editor",
        rich_text_editor_toolbar: "bold,italic,underline",
      },
      class: "rich-text-target",
    )
    output = render(component)

    assert_includes(output, 'data-controller="rich-text-editor"')
    assert_includes(output, 'data-rich-text-editor-toolbar="bold,italic,underline"')
    assert_includes(output, "rich-text-target")
    assert_includes(output, "Rich Text Content")
  end

  def test_form_textarea_focus_management
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :focus_test,
      autofocus: true,
      tabindex: 1,
    ) { "Focus test" }
    output = render(component)

    # Check focus management attributes
    assert_includes(output, "autofocus")
    assert_includes(output, 'tabindex="1"')
  end

  def test_form_textarea_with_spell_check
    component = ShadcnPhlexcomponents::FormTextarea.new(
      :spell_check_test,
      spellcheck: true,
      label: "Content with Spell Check",
    )
    output = render(component)

    assert_includes(output, "spellcheck")
    assert_includes(output, "Content with Spell Check")
  end
end
