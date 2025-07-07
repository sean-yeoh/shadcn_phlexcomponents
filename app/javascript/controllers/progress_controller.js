import { Controller } from "@hotwired/stimulus";
const ProgressController = class extends Controller {
  // targets
  static targets = ["indicator"];
  // values
  static values = {
    percent: Number,
  };
  percentValueChanged(value) {
    this.element.setAttribute("aria-valuenow", `${value}`);
    this.indicatorTarget.style.transform = `translateX(-${100 - value}%)`;
  }
};
export { ProgressController };
