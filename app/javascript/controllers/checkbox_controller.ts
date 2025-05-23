import { Controller } from '@hotwired/stimulus'

export default class extends Controller<HTMLElement> {
  static targets = ['input']
  static values = {
    checked: Boolean,
  }

  declare readonly inputTarget: HTMLInputElement
  declare checkedValue: boolean

  toggle() {
    this.checkedValue = !this.checkedValue
  }

  preventDefault(event: KeyboardEvent) {
    event.preventDefault()
  }

  checkedValueChanged(value: boolean) {
    if (value) {
      this.element.ariaChecked = 'true'
      this.element.dataset.checked = 'true'
      this.inputTarget.checked = true
    } else {
      this.element.ariaChecked = 'false'
      this.element.dataset.checked = 'false'
      this.inputTarget.checked = false
    }
  }
}
