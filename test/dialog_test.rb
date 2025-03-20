# frozen_string_literal: true

require "test_helper"

class DialogTest < ComponentTest
  def test_it_should_render_dialog
    output = render(Dialog.new)
    assert_match(%r{<div.+</div>}, output)
    assert_match(/data-controller="shadcn-phlexcomponents--dialog"/, output)
  end

  def test_it_should_pass_aria_id_to_children
    dialog = Dialog.new(aria_id: "dialog-id") do |d|
      d.trigger { "Dialog trigger" }

      d.content do
        d.header do
          d.title
          d.description
        end
      end
    end

    output = render(dialog)
    assert_match(/aria-controls="dialog-id-content"/, output)
    assert_match(/id="dialog-id-title"/, output)
    assert_match(/id="dialog-id-description"/, output)
    assert_match(/id="dialog-id-content"/, output)
    assert_match(/aria-describedby="dialog-id-description"/, output)
    assert_match(/aria-labelledby="dialog-id-title"/, output)
  end

  def test_it_should_render_base_styles
    output = render(Dialog.new)
    assert_includes(output, Dialog::STYLES.split("\n").join(" "))
  end

  def test_it_should_render_trigger
    dialog = Dialog.new do |d|
      d.trigger { "Dialog trigger" }
    end

    output = render(dialog)
    assert_match(/Dialog trigger/, output)
  end

  def test_it_should_render_content
    dialog = Dialog.new do |d|
      d.content { "Dialog content" }
    end

    output = render(dialog)
    assert_match(/Dialog content/, output)
  end

  def test_it_should_render_header
    dialog = Dialog.new do |d|
      d.header { "Dialog header" }
    end

    output = render(dialog)
    assert_match(/Dialog header/, output)
  end

  def test_it_should_render_title
    dialog = Dialog.new do |d|
      d.title { "Dialog title" }
    end

    output = render(dialog)
    assert_match(/Dialog title/, output)
  end

  def test_it_should_render_description
    dialog = Dialog.new do |d|
      d.description { "Dialog description" }
    end

    output = render(dialog)
    assert_match(/Dialog description/, output)
  end

  def test_it_should_render_footer
    dialog = Dialog.new do |d|
      d.footer { "Dialog footer" }
    end

    output = render(dialog)
    assert_match(/Dialog footer/, output)
  end

  def test_it_should_accept_custom_attributes
    output = render(Dialog.new(
      class: "test-class",
      data: { action: "test-action", controller: "test-controller" },
    ))
    assert_match(/test-class/, output)
    assert_match(/data-action="test-action"/, output)
    assert_match(/data-controller="shadcn-phlexcomponents--dialog test-controller"/, output)
  end
end
