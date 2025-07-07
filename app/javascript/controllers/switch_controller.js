import { Controller } from "@hotwired/stimulus";
const SwitchController = class extends Controller {
  // targets
  static targets = ["input", "thumb"];
  // values
  static values = {
    isChecked: Boolean,
  };
  toggle() {
    this.isCheckedValue = !this.isCheckedValue;
  }
  isCheckedValueChanged(value) {
    if (value) {
      this.element.ariaChecked = "true";
      this.element.dataset.state = "checked";
      this.thumbTarget.dataset.state = "checked";
      this.inputTarget.checked = true;
    } else {
      this.element.ariaChecked = "false";
      this.element.dataset.state = "unchecked";
      this.thumbTarget.dataset.state = "unchecked";
      this.inputTarget.checked = false;
    }
  }
};
export { SwitchController };
