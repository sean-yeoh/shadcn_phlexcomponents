import { Controller } from "@hotwired/stimulus";
import {
  focusElement,
  focusTrigger,
  showContent,
  hideContent,
  getFocusableElements,
  anyNestedComponentsOpen,
  handleTabNavigation,
} from "../utils";
const DialogController = class extends Controller {
  static name = "dialog";
  // targets
  static targets = ["trigger", "content", "overlay"];
  // values
  static values = {
    isOpen: Boolean,
  };
  connect() {
    this.DOMKeydownListener = this.onDOMKeydown.bind(this);
    this.DOMClickListener = this.onDOMClick.bind(this);
  }
  open() {
    this.isOpenValue = true;
  }
  close() {
    this.isOpenValue = false;
  }
  isOpenValueChanged(isOpen, previousIsOpen) {
    if (isOpen) {
      showContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentTarget,
        appendToBody: true,
        overlay: this.overlayTarget,
      });
      const focusableElements = getFocusableElements(this.contentTarget);
      focusElement(focusableElements[0]);
      this.setupEventListeners();
    } else {
      hideContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentTarget,
        overlay: this.overlayTarget,
      });
      if (previousIsOpen) {
        focusTrigger(this.triggerTarget);
      }
      this.cleanupEventListeners();
    }
  }
  disconnect() {
    this.cleanupEventListeners();
  }
  onDOMClick(event) {
    if (!this.isOpenValue) return;
    const target = event.target;
    if (target === this.triggerTarget) return;
    if (this.contentTarget.contains(target)) return;
    const shouldClose = !anyNestedComponentsOpen(this.contentTarget);
    if (shouldClose) this.close();
  }
  onDOMKeydown(event) {
    if (!this.isOpenValue) return;
    const key = event.key;
    if (key === "Escape") {
      const shouldClose = !anyNestedComponentsOpen(this.contentTarget);
      if (shouldClose) this.close();
    } else if (key === "Tab") {
      handleTabNavigation(this.contentTarget, event);
    }
  }
  setupEventListeners() {
    document.addEventListener("keydown", this.DOMKeydownListener);
    document.addEventListener("pointerdown", this.DOMClickListener);
  }
  cleanupEventListeners() {
    document.removeEventListener("keydown", this.DOMKeydownListener);
    document.removeEventListener("pointerdown", this.DOMClickListener);
  }
};
export { DialogController };
