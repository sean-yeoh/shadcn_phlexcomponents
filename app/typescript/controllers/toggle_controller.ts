import { Controller } from '@hotwired/stimulus'

const Toggle = class extends Controller<HTMLElement> {
  static name = 'toggle'

  // values
  static values = {
    isOn: Boolean,
  }
  declare isOnValue: boolean

  toggle() {
    this.isOnValue = !this.isOnValue
  }

  isOnValueChanged(isOn: boolean) {
    if (isOn) {
      this.element.dataset.state = 'on'
      this.element.ariaPressed = 'true'
    } else {
      this.element.dataset.state = 'off'
      this.element.ariaPressed = 'false'
    }
  }
}

export default Toggle
