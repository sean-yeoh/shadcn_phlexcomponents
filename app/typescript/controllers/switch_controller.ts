import { Controller } from '@hotwired/stimulus'

const SwitchController = class extends Controller<HTMLElement> {
  // targets
  static targets = ['input', 'thumb']
  declare readonly inputTarget: HTMLInputElement
  declare readonly thumbTarget: HTMLElement

  // values
  static values = {
    isChecked: Boolean,
  }
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

type Switch = InstanceType<typeof SwitchController>

export { SwitchController }
export type { Switch }
