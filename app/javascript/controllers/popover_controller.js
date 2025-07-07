import { Controller } from "@hotwired/stimulus";
import { useClickOutside } from "stimulus-use";
import { initFloatingUi } from "../utils/floating_ui";
import {
  focusTrigger,
  getFocusableElements,
  showContent,
  hideContent,
  onClickOutside,
  handleTabNavigation,
  focusElement,
} from "../utils";
const PopoverController = class extends Controller {
  // targets
  static targets = ["trigger", "contentContainer", "content"];
  // values
  static values = { isOpen: Boolean };
  connect() {
    this.DOMKeydownListener = this.onDOMKeydown.bind(this);
    useClickOutside(this, {
      element: this.contentTarget,
      dispatchEvent: false,
    });
  }
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
  clickOutside(event) {
    onClickOutside(this, event);
  }
  isOpenValueChanged(isOpen, previousIsOpen) {
    if (isOpen) {
      showContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
      });
      this.cleanup = initFloatingUi({
        referenceElement: this.triggerTarget,
        floatingElement: this.contentContainerTarget,
        side: this.contentTarget.dataset.side,
        align: this.contentTarget.dataset.align,
        sideOffset: 4,
      });
      const focusableElements = getFocusableElements(this.contentTarget);
      focusElement(focusableElements[0]);
      this.setupEventListeners();
    } else {
      hideContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
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
  setupEventListeners() {
    document.addEventListener("keydown", this.DOMKeydownListener);
  }
  cleanupEventListeners() {
    if (this.cleanup) this.cleanup();
    document.removeEventListener("keydown", this.DOMKeydownListener);
  }
  onDOMKeydown(event) {
    if (!this.isOpenValue) return;
    const key = event.key;
    if (key === "Escape") {
      this.close();
    } else if (key === "Tab") {
      handleTabNavigation(this.contentTarget, event);
    }
  }
};
export { PopoverController };
