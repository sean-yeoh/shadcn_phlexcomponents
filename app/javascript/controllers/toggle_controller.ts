import { Controller } from '@hotwired/stimulus'

export default class extends Controller<HTMLElement> {
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
