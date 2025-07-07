import { Controller } from "@hotwired/stimulus";
const ToggleController = class extends Controller {
  // values
  static values = {
    isOn: Boolean,
  };
  toggle() {
    this.isOnValue = !this.isOnValue;
  }
  isOnValueChanged(isOn) {
    if (isOn) {
      this.element.dataset.state = "on";
      this.element.ariaPressed = "true";
    } else {
      this.element.dataset.state = "off";
      this.element.ariaPressed = "false";
    }
  }
};
export { ToggleController };
