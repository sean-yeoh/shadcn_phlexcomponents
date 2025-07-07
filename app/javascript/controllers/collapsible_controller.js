import { Controller } from "@hotwired/stimulus";
import { hideContent, showContent } from "../utils";
const CollapsibleController = class extends Controller {
  // targets
  static targets = ["trigger", "content"];
  // values
  static values = {
    isOpen: Boolean,
  };
  toggle() {
    if (this.isOpenValue) {
      this.close();
    } else {
      this.open();
    }
  }
  open() {
    this.isOpenValue = true;
  }
  close() {
    this.isOpenValue = false;
  }
  isOpenValueChanged(isOpen) {
    if (isOpen) {
      showContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentTarget,
      });
    } else {
      hideContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentTarget,
      });
    }
  }
};
export { CollapsibleController };
