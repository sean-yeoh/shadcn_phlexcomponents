import { Controller } from "@hotwired/stimulus";
import { useHover } from "stimulus-use";
import { initFloatingUi } from "../utils/floating_ui";
import { showContent, hideContent } from "../utils";
const HoverCardController = class extends Controller {
  // targets
  static targets = ["trigger", "content", "contentContainer"];
  // values
  static values = {
    isOpen: Boolean,
  };
  connect() {
    this.DOMKeydownListener = this.onDOMKeydown.bind(this);
    useHover(this, { element: this.triggerTarget, dispatchEvent: false });
  }
  open() {
    window.clearTimeout(this.closeTimeout);
    this.isOpenValue = true;
  }
  close() {
    this.closeTimeout = window.setTimeout(() => {
      this.isOpenValue = false;
    }, 250);
  }
  // for useHover
  mouseEnter() {
    this.open();
  }
  // for useHover
  mouseLeave() {
    this.close();
  }
  isOpenValueChanged(isOpen) {
    if (isOpen) {
      showContent({
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
      });
      this.setupEventListeners();
      this.cleanup = initFloatingUi({
        referenceElement: this.triggerTarget,
        floatingElement: this.contentContainerTarget,
        side: this.contentTarget.dataset.side,
        align: this.contentTarget.dataset.align,
        sideOffset: 4,
      });
    } else {
      hideContent({
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
      });
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
    }
  }
};
export { HoverCardController };
