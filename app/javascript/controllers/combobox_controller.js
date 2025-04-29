import { Controller } from '@hotwired/stimulus'
import Choices from 'choices.js'
export default class extends Controller {
  static targets = ['select']

  connect() {
    if (this.element.dataset.value) {
      const option = this.selectTarget.querySelector(
        `[value=${this.element.dataset.value}]`,
      )

      if (option) {
        option.selected = true
      }
    }

    this.choices = new Choices(this.selectTarget, {
      itemSelectText: '',
      placeholderValue: this.element.dataset.placeholder,
    })

    if (this.element.dataset.includeBlank === 'false') {
      this.choices.removeChoice('')
    }

    this.selectTarget.addEventListener(
      'hideDropdown',
      function () {
        this.choices.containerOuter.element.focus()
      }.bind(this),
      false,
    )
  }
}
