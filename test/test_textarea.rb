# frozen_string_literal: true

require "test_helper"

class TestTextarea < ComponentTest
  def test_it_should_render_basic_textarea
    component = ShadcnPhlexcomponents::Textarea.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="textarea"')
    assert_includes(output, "border-input placeholder:text-muted-foreground")
    assert_includes(output, "focus-visible:border-ring focus-visible:ring-ring/50")
    assert_includes(output, "flex field-sizing-content min-h-16 w-full rounded-md")
    assert_includes(output, "border")
    assert_includes(output, "bg-transparent")
    assert_includes(output, "px-3 py-2")
    assert_includes(output, "text-base")
    assert_includes(output, "shadow-xs")
    assert_includes(output, "transition-[color,box-shadow] outline-none")
    assert_includes(output, "disabled:cursor-not-allowed disabled:opacity-50")
    assert_match(%r{<textarea[^>]*></textarea>}, output)
  end

  def test_it_should_render_with_default_values
    component = ShadcnPhlexcomponents::Textarea.new
    output = render(component)

    assert_includes(output, 'data-shadcn-phlexcomponents="textarea"')
    assert_match(%r{<textarea[^>]*></textarea>}, output)
    refute_includes(output, "value=")
  end

  def test_it_should_render_with_value
    component = ShadcnPhlexcomponents::Textarea.new(value: "Hello world!")
    output = render(component)

    assert_includes(output, "Hello world!")
    assert_match(%r{<textarea[^>]*>Hello world!</textarea>}, output)
  end

  def test_it_should_render_with_custom_attributes
    component = ShadcnPhlexcomponents::Textarea.new(
      value: "Custom content",
      name: "description",
      placeholder: "Enter description...",
      rows: 5,
      cols: 40,
      maxlength: 500,
      class: "custom-textarea border-blue-500",
      id: "description-field",
      data: { testid: "description-input" },
    )
    output = render(component)

    assert_includes(output, "custom-textarea border-blue-500")
    assert_includes(output, 'id="description-field"')
    assert_includes(output, 'data-testid="description-input"')
    assert_includes(output, 'name="description"')
    assert_includes(output, 'placeholder="Enter description..."')
    assert_includes(output, 'rows="5"')
    assert_includes(output, 'cols="40"')
    assert_includes(output, 'maxlength="500"')
    assert_includes(output, "Custom content")
  end

  def test_it_should_handle_disabled_state
    component = ShadcnPhlexcomponents::Textarea.new(
      value: "Read-only content",
      disabled: true,
      class: "disabled-textarea",
    )
    output = render(component)

    assert_includes(output, "disabled-textarea")
    assert_includes(output, "disabled")
    assert_includes(output, "disabled:cursor-not-allowed disabled:opacity-50")
    assert_includes(output, "Read-only content")
  end

  def test_it_should_handle_readonly_state
    component = ShadcnPhlexcomponents::Textarea.new(
      value: "Readonly text",
      readonly: true,
      class: "readonly-textarea",
    )
    output = render(component)

    assert_includes(output, "readonly-textarea")
    assert_includes(output, "readonly")
    assert_includes(output, "Readonly text")
  end

  def test_it_should_handle_required_attribute
    component = ShadcnPhlexcomponents::Textarea.new(
      name: "required_field",
      required: true,
      aria: { required: "true" },
    )
    output = render(component)

    assert_includes(output, "required")
    assert_includes(output, 'aria-required="true"')
    assert_includes(output, 'name="required_field"')
  end

  def test_it_should_handle_form_attributes
    component = ShadcnPhlexcomponents::Textarea.new(
      name: "message",
      form: "contact-form",
      autocomplete: "off",
      spellcheck: "false",
      wrap: "soft",
    )
    output = render(component)

    assert_includes(output, 'name="message"')
    assert_includes(output, 'form="contact-form"')
    assert_includes(output, 'autocomplete="off"')
    assert_includes(output, 'spellcheck="false"')
    assert_includes(output, 'wrap="soft"')
  end

  def test_it_should_handle_aria_attributes
    component = ShadcnPhlexcomponents::Textarea.new(
      value: "Accessible textarea",
      aria: {
        label: "Message content",
        describedby: "message-help",
        invalid: "false",
      },
    )
    output = render(component)

    assert_includes(output, 'aria-label="Message content"')
    assert_includes(output, 'aria-describedby="message-help"')
    assert_includes(output, 'aria-invalid="false"')
    assert_includes(output, "Accessible textarea")
  end

  def test_it_should_handle_validation_states
    # Test valid state
    valid_component = ShadcnPhlexcomponents::Textarea.new(
      value: "Valid content",
      class: "valid-textarea",
      aria: { invalid: "false" },
    )
    valid_output = render(valid_component)

    assert_includes(valid_output, "valid-textarea")
    assert_includes(valid_output, 'aria-invalid="false"')

    # Test invalid state
    invalid_component = ShadcnPhlexcomponents::Textarea.new(
      value: "Invalid content",
      class: "invalid-textarea border-red-500",
      aria: { invalid: "true", describedby: "error-message" },
    )
    invalid_output = render(invalid_component)

    assert_includes(invalid_output, "invalid-textarea border-red-500")
    assert_includes(invalid_output, 'aria-invalid="true"')
    assert_includes(invalid_output, 'aria-describedby="error-message"')
    assert_includes(invalid_output, "aria-invalid:ring-destructive/20")
    assert_includes(invalid_output, "aria-invalid:border-destructive")
  end

  def test_it_should_handle_data_attributes
    component = ShadcnPhlexcomponents::Textarea.new(
      data: {
        controller: "character-counter",
        character_counter_target: "textarea",
        character_counter_max_value: "280",
        action: "input->character-counter#updateCount",
      },
    )
    output = render(component)

    assert_includes(output, 'data-controller="character-counter"')
    assert_includes(output, 'data-character-counter-target="textarea"')
    assert_includes(output, 'data-character-counter-max-value="280"')
    assert_includes(output, 'data-action="input->character-counter#updateCount"')
  end

  def test_it_should_include_styling_classes
    component = ShadcnPhlexcomponents::Textarea.new
    output = render(component)

    # Border and focus styles
    assert_includes(output, "border-input")
    assert_includes(output, "focus-visible:border-ring")
    assert_includes(output, "focus-visible:ring-ring/50")
    assert_includes(output, "focus-visible:ring-[3px]")

    # Layout and sizing
    assert_includes(output, "flex field-sizing-content")
    assert_includes(output, "min-h-16 w-full rounded-md")
    assert_includes(output, "px-3 py-2")

    # Typography and appearance
    assert_includes(output, "text-base shadow-xs")
    assert_includes(output, "md:text-sm")
    assert_includes(output, "placeholder:text-muted-foreground")
    assert_includes(output, "bg-transparent")

    # States
    assert_includes(output, "disabled:cursor-not-allowed disabled:opacity-50")
    assert_includes(output, "transition-[color,box-shadow]")
    assert_includes(output, "outline-none")
  end

  def test_it_should_handle_multiline_content
    multiline_content = "Line 1\nLine 2\nLine 3\n\nParagraph with spaces"
    component = ShadcnPhlexcomponents::Textarea.new(value: multiline_content)
    output = render(component)

    assert_includes(output, "Line 1")
    assert_includes(output, "Line 2")
    assert_includes(output, "Line 3")
    assert_includes(output, "Paragraph with spaces")
    # Check that newlines are preserved in the textarea content
    assert_match(/Line 1\nLine 2\nLine 3/, output)
  end

  def test_it_should_handle_special_characters
    special_content = "Special chars: <>&\"'\n\t"
    component = ShadcnPhlexcomponents::Textarea.new(value: special_content)
    output = render(component)

    # Content should be properly escaped in HTML
    assert_includes(output, "Special chars:")
    # HTML entities should be properly handled
    assert_match(/<textarea[^>]*>Special chars: &lt;&gt;&amp;&quot;&#39;/, output)
  end

  def test_it_should_handle_empty_and_whitespace_values
    # Empty value
    empty_component = ShadcnPhlexcomponents::Textarea.new(value: "")
    empty_output = render(empty_component)
    assert_match(%r{<textarea[^>]*></textarea>}, empty_output)

    # Whitespace-only value
    whitespace_component = ShadcnPhlexcomponents::Textarea.new(value: "   \n\t  ")
    whitespace_output = render(whitespace_component)
    assert_includes(whitespace_output, "   \n\t  ")
  end
end

class TestTextareaWithCustomConfiguration < ComponentTest
  def test_textarea_with_custom_configuration
    custom_config = ShadcnPhlexcomponents::Configuration.new
    custom_config.textarea = {
      base: "custom-textarea-base border-2 border-purple-500 bg-purple-50 rounded-lg p-4 text-purple-900",
    }

    # Set configuration
    original_config = ShadcnPhlexcomponents.instance_variable_get(:@configuration)
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, custom_config)

    # Force reload class
    ShadcnPhlexcomponents.send(:remove_const, :Textarea) if ShadcnPhlexcomponents.const_defined?(:Textarea)
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/textarea.rb", __dir__))

    # Test component with custom configuration
    textarea = ShadcnPhlexcomponents::Textarea.new(value: "Custom styled textarea")
    textarea_output = render(textarea)
    assert_includes(textarea_output, "custom-textarea-base")
    assert_includes(textarea_output, "border-2 border-purple-500 bg-purple-50")
    assert_includes(textarea_output, "rounded-lg p-4 text-purple-900")
    assert_includes(textarea_output, "Custom styled textarea")
  ensure
    # Restore and reload
    ShadcnPhlexcomponents.instance_variable_set(:@configuration, original_config || ShadcnPhlexcomponents::Configuration.new)
    ShadcnPhlexcomponents.send(:remove_const, :Textarea) if ShadcnPhlexcomponents.const_defined?(:Textarea)
    load(File.expand_path("../lib/shadcn_phlexcomponents/components/textarea.rb", __dir__))
  end
end

class TestTextareaIntegration < ComponentTest
  def test_comment_form_textarea
    component = ShadcnPhlexcomponents::Textarea.new(
      name: "comment",
      value: "This is my comment on the article...",
      placeholder: "Share your thoughts about this article...",
      rows: 4,
      maxlength: 1000,
      class: "comment-textarea resize-none",
      id: "comment-field",
      aria: {
        label: "Article comment",
        describedby: "comment-help comment-counter",
      },
      data: {
        controller: "comment-form character-counter",
        comment_form_target: "textarea",
        character_counter_target: "input",
        character_counter_max_value: "1000",
        action: "input->character-counter#updateCount input->comment-form#validateComment",
      },
    )
    output = render(component)

    # Check comment form structure
    assert_includes(output, "comment-textarea resize-none")
    assert_includes(output, 'id="comment-field"')
    assert_includes(output, 'name="comment"')
    assert_includes(output, 'rows="4"')
    assert_includes(output, 'maxlength="1000"')

    # Check accessibility
    assert_includes(output, 'aria-label="Article comment"')
    assert_includes(output, 'aria-describedby="comment-help comment-counter"')

    # Check placeholder and value
    assert_includes(output, 'placeholder="Share your thoughts about this article..."')
    assert_includes(output, "This is my comment on the article...")

    # Check stimulus integration
    assert_match(/data-controller="[^"]*comment-form[^"]*character-counter[^"]*"/, output)
    assert_includes(output, 'data-comment-form-target="textarea"')
    assert_includes(output, 'data-character-counter-target="input"')
    assert_includes(output, 'data-character-counter-max-value="1000"')
    assert_includes(output, "character-counter#updateCount")
    assert_includes(output, "comment-form#validateComment")
  end

  def test_message_composer_textarea
    component = ShadcnPhlexcomponents::Textarea.new(
      name: "message_content",
      placeholder: "Type your message here... (Shift+Enter for new line)",
      rows: 3,
      class: "message-composer min-h-20 max-h-40 resize-none",
      data: {
        controller: "message-composer auto-resize",
        message_composer_target: "textarea",
        auto_resize_target: "textarea",
        auto_resize_min_height: "80",
        auto_resize_max_height: "160",
        action: "input->auto-resize#adjustHeight keydown.enter->message-composer#handleEnter:prevent",
      },
    )
    output = render(component)

    # Check message composer structure
    assert_includes(output, "message-composer min-h-20 max-h-40 resize-none")
    assert_includes(output, 'name="message_content"')
    assert_includes(output, 'rows="3"')
    assert_includes(output, 'placeholder="Type your message here... (Shift+Enter for new line)"')

    # Check auto-resize functionality
    assert_match(/data-controller="[^"]*message-composer[^"]*auto-resize[^"]*"/, output)
    assert_includes(output, 'data-message-composer-target="textarea"')
    assert_includes(output, 'data-auto-resize-target="textarea"')
    assert_includes(output, 'data-auto-resize-min-height="80"')
    assert_includes(output, 'data-auto-resize-max-height="160"')

    # Check keyboard handling
    assert_includes(output, "auto-resize#adjustHeight")
    assert_includes(output, "keydown.enter->message-composer#handleEnter:prevent")
  end

  def test_feedback_form_textarea
    component = ShadcnPhlexcomponents::Textarea.new(
      name: "feedback",
      placeholder: "Please describe your experience and any suggestions for improvement...",
      rows: 6,
      maxlength: 2000,
      required: true,
      class: "feedback-textarea w-full",
      aria: {
        label: "Feedback details",
        describedby: "feedback-help feedback-counter",
        required: "true",
      },
      data: {
        controller: "feedback-form character-counter form-validation",
        feedback_form_target: "feedbackText",
        character_counter_target: "input",
        character_counter_max_value: "2000",
        form_validation_target: "required",
        action: "input->character-counter#updateCount blur->form-validation#validateRequired",
      },
    )
    output = render(component)

    # Check feedback form structure
    assert_includes(output, "feedback-textarea w-full")
    assert_includes(output, 'name="feedback"')
    assert_includes(output, "required")
    assert_includes(output, 'rows="6"')
    assert_includes(output, 'maxlength="2000"')

    # Check accessibility and validation
    assert_includes(output, 'aria-label="Feedback details"')
    assert_includes(output, 'aria-describedby="feedback-help feedback-counter"')
    assert_includes(output, 'aria-required="true"')

    # Check placeholder
    assert_includes(output, 'placeholder="Please describe your experience and any suggestions for improvement..."')

    # Check multiple controllers
    assert_match(/data-controller="[^"]*feedback-form[^"]*character-counter[^"]*form-validation[^"]*"/, output)
    assert_includes(output, 'data-feedback-form-target="feedbackText"')
    assert_includes(output, 'data-character-counter-max-value="2000"')
    assert_includes(output, 'data-form-validation-target="required"')

    # Check validation actions
    assert_includes(output, "character-counter#updateCount")
    assert_includes(output, "form-validation#validateRequired")
  end

  def test_code_editor_textarea
    component = ShadcnPhlexcomponents::Textarea.new(
      name: "code_content",
      value: "def hello_world\n  puts 'Hello, World!'\nend",
      class: "code-editor font-mono text-sm bg-gray-900 text-green-400 border-gray-700",
      rows: 10,
      cols: 80,
      spellcheck: "false",
      autocomplete: "off",
      wrap: "off",
      data: {
        controller: "code-editor syntax-highlighter",
        code_editor_target: "textarea",
        syntax_highlighter_language: "ruby",
        syntax_highlighter_theme: "dark",
        action: "input->syntax-highlighter#highlight tab->code-editor#insertTab:prevent",
      },
    )
    output = render(component)

    # Check code editor structure
    assert_includes(output, "code-editor font-mono text-sm")
    assert_includes(output, "bg-gray-900 text-green-400 border-gray-700")
    assert_includes(output, 'name="code_content"')
    assert_includes(output, 'rows="10"')
    assert_includes(output, 'cols="80"')

    # Check code-specific attributes
    assert_includes(output, 'spellcheck="false"')
    assert_includes(output, 'autocomplete="off"')
    assert_includes(output, 'wrap="off"')

    # Check code content
    assert_includes(output, "def hello_world")
    assert_includes(output, "puts &#39;Hello, World!&#39;")
    assert_includes(output, "end")

    # Check syntax highlighting integration
    assert_match(/data-controller="[^"]*code-editor[^"]*syntax-highlighter[^"]*"/, output)
    assert_includes(output, 'data-code-editor-target="textarea"')
    assert_includes(output, 'data-syntax-highlighter-language="ruby"')
    assert_includes(output, 'data-syntax-highlighter-theme="dark"')

    # Check keyboard handling for code
    assert_includes(output, "syntax-highlighter#highlight")
    assert_includes(output, "tab->code-editor#insertTab:prevent")
  end

  def test_markdown_editor_textarea
    component = ShadcnPhlexcomponents::Textarea.new(
      name: "markdown_content",
      value: "# Heading\n\nThis is **bold** and *italic* text.\n\n- List item 1\n- List item 2",
      placeholder: "Write in Markdown format...",
      class: "markdown-editor font-mono",
      rows: 8,
      data: {
        controller: "markdown-editor live-preview",
        markdown_editor_target: "textarea",
        live_preview_target: "source",
        live_preview_delay: "500",
        action: "input->live-preview#updatePreview:debounce(500)",
      },
    )
    output = render(component)

    # Check markdown editor structure
    assert_includes(output, "markdown-editor font-mono")
    assert_includes(output, 'name="markdown_content"')
    assert_includes(output, 'rows="8"')
    assert_includes(output, 'placeholder="Write in Markdown format..."')

    # Check markdown content
    assert_includes(output, "# Heading")
    assert_includes(output, "This is **bold** and *italic* text.")
    assert_includes(output, "- List item 1")
    assert_includes(output, "- List item 2")

    # Check live preview integration
    assert_match(/data-controller="[^"]*markdown-editor[^"]*live-preview[^"]*"/, output)
    assert_includes(output, 'data-markdown-editor-target="textarea"')
    assert_includes(output, 'data-live-preview-target="source"')
    assert_includes(output, 'data-live-preview-delay="500"')
    assert_includes(output, "live-preview#updatePreview:debounce(500)")
  end

  def test_textarea_with_validation_states
    # Valid state
    valid_component = ShadcnPhlexcomponents::Textarea.new(
      name: "valid_field",
      value: "This content is valid",
      class: "border-green-500 focus-visible:ring-green-500/20",
      aria: { invalid: "false" },
    )
    valid_output = render(valid_component)

    assert_includes(valid_output, "border-green-500")
    assert_includes(valid_output, 'aria-invalid="false"')

    # Invalid state with error styling
    invalid_component = ShadcnPhlexcomponents::Textarea.new(
      name: "invalid_field",
      value: "Too short",
      class: "border-red-500 focus-visible:ring-red-500/20",
      aria: {
        invalid: "true",
        describedby: "field-error",
      },
      data: {
        controller: "field-validation",
        field_validation_target: "input",
        field_validation_state: "invalid",
      },
    )
    invalid_output = render(invalid_component)

    assert_includes(invalid_output, "border-red-500")
    assert_includes(invalid_output, 'aria-invalid="true"')
    assert_includes(invalid_output, 'aria-describedby="field-error"')
    assert_includes(invalid_output, 'data-field-validation-state="invalid"')
    assert_includes(invalid_output, "aria-invalid:ring-destructive/20")
    assert_includes(invalid_output, "aria-invalid:border-destructive")
  end
end
