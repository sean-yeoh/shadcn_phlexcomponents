import { Controller } from "@hotwired/stimulus";
import { useClickOutside } from "stimulus-use";
import { initFloatingUi } from "../utils/floating_ui";
import {
  getSameLevelItems,
  focusTrigger,
  hideContent,
  showContent,
  lockScroll,
  unlockScroll,
  getStimulusInstance,
  onClickOutside,
  getNextEnabledIndex,
  getPreviousEnabledIndex,
  focusElement,
} from "../utils";
const onKeydown = (controller, event) => {
  const key = event.key;
  if (["Tab", "Enter", " "].includes(key)) event.preventDefault();
  if (key === "Home") {
    controller.focusItemByIndex(null, 0);
  } else if (key === "End") {
    controller.focusItemByIndex(null, controller.items.length - 1);
  } else if (key === "Escape") {
    controller.close();
  }
};
const focusItemByIndex = (controller, event = null, index = null) => {
  if (event !== null) {
    const key = event.key;
    if (key === "ArrowUp") {
      controller.items[controller.items.length - 1].focus();
    } else {
      controller.items[0].focus();
    }
  } else if (index !== null) {
    controller.items[index].focus();
  }
};
const DropdownMenuController = class extends Controller {
  static name = "dropdown-menu";
  // targets
  static targets = ["trigger", "contentContainer", "content", "item"];
  // values
  static values = {
    isOpen: Boolean,
  };
  connect() {
    this.closestContentSelector =
      '[data-dropdown-menu-target="content"], [data-dropdown-menu-sub-target="content"]';
    this.items = getSameLevelItems({
      content: this.contentTarget,
      items: this.itemTargets,
      closestContentSelector: this.closestContentSelector,
    });
    useClickOutside(this, {
      element: this.contentTarget,
      dispatchEvent: false,
    });
    this.DOMKeydownListener = this.onDOMKeydown.bind(this);
  }
  toggle(event) {
    if (this.isOpenValue) {
      this.close();
    } else {
      this.open(event);
    }
  }
  open(event) {
    this.isOpenValue = true;
    // Sub menus are not connected to the DOM yet when dropdown menu is connected.
    // So we initialize them here instead of in connect().
    if (this.subMenuControllers === undefined) {
      const subMenuControllers = [];
      const subMenus = Array.from(
        this.contentTarget.querySelectorAll(
          '[data-shadcn-phlexcomponents="dropdown-menu-sub"]',
        ),
      );
      subMenus.forEach((subMenu) => {
        const subMenuController = getStimulusInstance(
          "dropdown-menu-sub",
          subMenu,
        );
        if (subMenuController) {
          subMenuControllers.push(subMenuController);
        }
      });
      this.subMenuControllers = subMenuControllers;
    }
    let elementToFocus = null;
    if (event instanceof KeyboardEvent) {
      const key = event.key;
      if (["ArrowDown", "Enter", " "].includes(key)) {
        elementToFocus = this.items[0];
      }
    } else {
      elementToFocus = this.contentTarget;
    }
    focusElement(elementToFocus);
  }
  close() {
    this.isOpenValue = false;
    this.subMenuControllers.forEach((subMenuController) => {
      subMenuController.closeImmediately();
    });
  }
  focusItem(event) {
    const item = event.currentTarget;
    let items = [];
    const content = item.closest(this.closestContentSelector);
    const isSubMenu =
      content.dataset.shadcnPhlexcomponents === "dropdown-menu-sub-content";
    if (isSubMenu) {
      const subMenu = content.closest(
        '[data-shadcn-phlexcomponents="dropdown-menu-sub"]',
      );
      const subMenuController = this.subMenuControllers.find(
        (subMenuController) => subMenuController.element == subMenu,
      );
      if (subMenuController) {
        items = subMenuController.items;
      }
    } else {
      items = this.items;
    }
    const index = items.indexOf(item);
    if (event instanceof KeyboardEvent) {
      const key = event.key;
      let newIndex = 0;
      if (key === "ArrowUp") {
        newIndex = getPreviousEnabledIndex({
          items,
          currentIndex: index,
          wrapAround: false,
        });
      } else {
        newIndex = getNextEnabledIndex({
          items,
          currentIndex: index,
          wrapAround: false,
        });
      }
      items[newIndex].focus();
    } else {
      // item mouseover event
      items[index].focus();
    }
    // Close submenus on the same level
    const subMenusInContent = Array.from(
      content.querySelectorAll(
        '[data-shadcn-phlexcomponents="dropdown-menu-sub"]',
      ),
    );
    subMenusInContent.forEach((subMenu) => {
      const subMenuController = this.subMenuControllers.find(
        (subMenuController) => subMenuController.element == subMenu,
      );
      if (subMenuController) {
        subMenuController.closeImmediately();
      }
    });
  }
  onItemFocus(event) {
    const item = event.currentTarget;
    item.tabIndex = 0;
  }
  onItemBlur(event) {
    const item = event.currentTarget;
    item.tabIndex = -1;
  }
  focusItemByIndex(event = null, index = null) {
    focusItemByIndex(this, event, index);
  }
  focusContent(event) {
    const item = event.currentTarget;
    const content = item.closest(this.closestContentSelector);
    content.focus();
  }
  select(event) {
    if (event instanceof KeyboardEvent) {
      const key = event.key;
      const item = event.currentTarget || event.target;
      // For rails button_to
      if (item && (key === "Enter" || key === " ")) {
        item.click();
      }
    }
    this.close();
  }
  clickOutside(event) {
    onClickOutside(this, event);
  }
  isOpenValueChanged(isOpen, previousIsOpen) {
    if (isOpen) {
      lockScroll(this.contentTarget.id);
      showContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
        setEqualWidth: false,
      });
      this.cleanup = initFloatingUi({
        referenceElement: this.triggerTarget,
        floatingElement: this.contentContainerTarget,
        side: this.contentTarget.dataset.side,
        align: this.contentTarget.dataset.align,
        sideOffset: 4,
      });
      this.setupEventListeners();
    } else {
      unlockScroll(this.contentTarget.id);
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
  onDOMKeydown(event) {
    if (!this.isOpenValue) return;
    onKeydown(this, event);
  }
  setupEventListeners() {
    document.addEventListener("keydown", this.DOMKeydownListener);
  }
  cleanupEventListeners() {
    if (this.cleanup) this.cleanup();
    document.removeEventListener("keydown", this.DOMKeydownListener);
  }
};
export { DropdownMenuController, onKeydown, focusItemByIndex };
