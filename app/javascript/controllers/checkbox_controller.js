import { Controller } from "@hotwired/stimulus";
const CheckboxController = class extends Controller {
  // targets
  static targets = ["input", "indicator"];
  // values
  static values = {
    isChecked: Boolean,
  };
  toggle() {
    this.isCheckedValue = !this.isCheckedValue;
  }
  preventDefault(event) {
    event.preventDefault();
  }
  isCheckedValueChanged(isChecked) {
    if (isChecked) {
      this.element.ariaChecked = "true";
      this.element.dataset.state = "checked";
      this.inputTarget.checked = true;
      this.indicatorTarget.classList.remove("hidden");
    } else {
      this.element.ariaChecked = "false";
      this.element.dataset.state = "unchecked";
      this.inputTarget.checked = false;
      this.indicatorTarget.classList.add("hidden");
    }
  }
};
export { CheckboxController };
