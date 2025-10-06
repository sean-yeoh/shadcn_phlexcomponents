import { Controller } from '@hotwired/stimulus'

const Checkbox = class extends Controller<HTMLElement> {
  static name = 'checkbox'

  // targets
  static targets = ['input', 'indicator']
  declare readonly inputTarget: HTMLInputElement
  declare readonly indicatorTarget: HTMLInputElement

  // values
  static values = {
    isChecked: Boolean,
  }
  declare isCheckedValue: boolean

  toggle() {
    this.isCheckedValue = !this.isCheckedValue
  }

  preventDefault(event: KeyboardEvent) {
    event.preventDefault()
  }

  isCheckedValueChanged(isChecked: boolean) {
    if (isChecked) {
      this.element.ariaChecked = 'true'
      this.element.dataset.state = 'checked'
      this.inputTarget.checked = true
      this.indicatorTarget.classList.remove('hidden')
    } else {
      this.element.ariaChecked = 'false'
      this.element.dataset.state = 'unchecked'
      this.inputTarget.checked = false
      this.indicatorTarget.classList.add('hidden')
    }
  }
}

export default Checkbox
