import { Controller } from "@hotwired/stimulus";
const FormFieldController = class extends Controller {
  static name = "form-field";
  connect() {
    const hintContainer = this.element.querySelector("[data-remove-label]");
    const labelContainer = this.element.querySelector("[data-remove-hint]");
    if (hintContainer) {
      const label = hintContainer.querySelector("label");
      const hint = hintContainer.querySelector("p");
      label.remove();
      hintContainer.replaceWith(hint);
    }
    if (labelContainer) {
      const hint = labelContainer.querySelector("p");
      const label = labelContainer.querySelector("label");
      hint.remove();
      labelContainer.replaceWith(label);
    }
  }
};
export { FormFieldController };
