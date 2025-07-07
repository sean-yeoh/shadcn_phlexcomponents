import { Controller } from "@hotwired/stimulus";
import { getNextEnabledIndex, getPreviousEnabledIndex } from "../utils";
const TabsController = class extends Controller {
  // targets
  static targets = ["trigger", "content"];
  // values
  static values = {
    active: String,
  };
  connect() {
    if (!this.activeValue) {
      this.activeValue = this.triggerTargets[0].dataset.value;
    }
  }
  setActiveTab(event) {
    const target = event.currentTarget;
    if (event instanceof MouseEvent) {
      this.activeValue = target.dataset.value;
    } else {
      const key = event.key;
      const focusableTriggers = this.triggerTargets.filter((t) => !t.disabled);
      const index = focusableTriggers.indexOf(target);
      let newIndex = 0;
      if (key === "ArrowLeft") {
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
      this.activeValue = focusableTriggers[newIndex].dataset.value;
      focusableTriggers[newIndex].focus();
    }
  }
  activeValueChanged(value) {
    this.triggerTargets.forEach((trigger) => {
      const triggerValue = trigger.dataset.value;
      const content = this.contentTargets.find((c) => {
        return c.dataset.value === triggerValue;
      });
      if (!content) {
        throw new Error(
          `Could not find TabsContent with value "${triggerValue}"`,
        );
      }
      if (triggerValue === value) {
        trigger.ariaSelected = "true";
        trigger.tabIndex = 0;
        trigger.dataset.state = "active";
        content.classList.remove("hidden");
      } else {
        trigger.ariaSelected = "false";
        trigger.tabIndex = -1;
        trigger.dataset.state = "inactive";
        content.classList.add("hidden");
      }
    });
  }
};
export { TabsController };
