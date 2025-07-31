import { Controller } from "@hotwired/stimulus";
import {
  showContent,
  hideContent,
  getNextEnabledIndex,
  getPreviousEnabledIndex,
} from "../utils";
const AccordionController = class extends Controller {
  static name = "accordion";
  // targets
  static targets = ["item", "trigger", "content"];
  // values
  static values = { openItems: Array };
  connect() {
    this.multiple = this.element.dataset.multiple === "true";
  }
  contentTargetConnected(content) {
    setTimeout(() => {
      this.setContentHeight(content);
    }, 100);
  }
  toggle(event) {
    const trigger = event.currentTarget;
    const item = this.itemTargets.find((item) => {
      return item.contains(trigger);
    });
    if (!item) return;
    const value = item.dataset.value;
    const isOpen = this.openItemsValue.includes(value);
    if (isOpen) {
      this.openItemsValue = this.openItemsValue.filter((v) => v !== value);
    } else {
      if (this.multiple) {
        this.openItemsValue = [...this.openItemsValue, value];
      } else {
        this.openItemsValue = [value];
      }
    }
  }
  focusTrigger(event) {
    const trigger = event.currentTarget;
    const key = event.key;
    const focusableTriggers = this.triggerTargets.filter(
      (trigger) => !trigger.disabled,
    );
    const index = focusableTriggers.indexOf(trigger);
    let newIndex = 0;
    if (key === "ArrowUp") {
      newIndex = getPreviousEnabledIndex({
        items: focusableTriggers,
        currentIndex: index,
        wrapAround: true,
      });
    } else {
      newIndex = getNextEnabledIndex({
        items: focusableTriggers,
        currentIndex: index,
        wrapAround: true,
      });
    }
    focusableTriggers[newIndex].focus();
  }
  openItemsValueChanged(openItems) {
    this.itemTargets.forEach((item) => {
      const itemValue = item.dataset.value;
      const trigger = this.triggerTargets.find((trigger) =>
        item.contains(trigger),
      );
      const content = this.contentTargets.find((content) =>
        item.contains(content),
      );
      if (openItems.includes(itemValue)) {
        showContent({
          trigger,
          content: content,
          contentContainer: content,
        });
      } else {
        hideContent({
          trigger,
          content: content,
          contentContainer: content,
        });
      }
    });
  }
  setContentHeight(element) {
    const height =
      this.getContentHeight(element) || element.getBoundingClientRect().height;
    element.style.setProperty(
      "--radix-accordion-content-height",
      `${height}px`,
    );
  }
  getContentHeight(el) {
    const clone = el.cloneNode(true);
    Object.assign(clone.style, {
      display: "block",
      position: "absolute",
      visibility: "hidden",
    });
    document.body.appendChild(clone);
    const height = clone.getBoundingClientRect().height;
    document.body.removeChild(clone);
    return height;
  }
};
export { AccordionController };
