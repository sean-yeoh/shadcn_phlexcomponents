import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['input']
  static values = {
    checked: Boolean,
  }

  toggle() {
    this.checkedValue = !this.checkedValue
  }

  checkedValueChanged(value) {
    if (value === true) {
      this.element.ariaChecked = true
      this.element.dataset.checked = true
      this.inputTarget.checked = true
    } else {
      this.element.ariaChecked = false
      this.element.dataset.checked = false
      this.inputTarget.checked = false
    }
  }
}
