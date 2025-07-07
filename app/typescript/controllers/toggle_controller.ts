import { Controller } from '@hotwired/stimulus'

const ToggleController = class extends Controller<HTMLElement> {
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

type Toggle = InstanceType<typeof ToggleController>

export { ToggleController }
export type { Toggle }
