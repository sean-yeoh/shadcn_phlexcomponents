import { Controller } from '@hotwired/stimulus'

export default class extends Controller<HTMLElement> {
  static targets = ['input', 'thumb']
  static values = {
    isChecked: Boolean,
  }

  declare readonly inputTarget: HTMLInputElement
  declare readonly thumbTarget: HTMLElement
  declare isCheckedValue: boolean

  toggle() {
    this.isCheckedValue = !this.isCheckedValue
  }

  isCheckedValueChanged(value: boolean) {
    if (value) {
      this.element.ariaChecked = 'true'
      this.element.dataset.state = 'checked'
      this.thumbTarget.dataset.state = 'checked'
      this.inputTarget.checked = true
    } else {
      this.element.ariaChecked = 'false'
      this.element.dataset.state = 'unchecked'
      this.thumbTarget.dataset.state = 'unchecked'
      this.inputTarget.checked = false
    }
  }
}
