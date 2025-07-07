import { Controller } from "@hotwired/stimulus";
import { useClickOutside } from "stimulus-use";
import {
  focusTrigger,
  getFocusableElements,
  showContent,
  hideContent,
  lockScroll,
  unlockScroll,
  handleTabNavigation,
  focusElement,
} from "../utils";
import { initFloatingUi } from "../utils/floating_ui";
import { Calendar } from "vanilla-calendar-pro";
import Inputmask from "inputmask";
import dayjs from "dayjs";
import customParseFormat from "dayjs/plugin/customParseFormat";
import utc from "dayjs/plugin/utc";
dayjs.extend(customParseFormat);
dayjs.extend(utc);
const DAYJS_FORMAT = "YYYY-MM-DD";
const DatePickerController = class extends Controller {
  // targets
  static targets = [
    "trigger",
    "triggerText",
    "contentContainer",
    "content",
    "input",
    "hiddenInput",
    "inputContainer",
    "calendar",
    "overlay",
  ];
  // values
  static values = { isOpen: Boolean, date: String };
  connect() {
    this.format = this.element.dataset.format || "DD/MM/YYYY";
    this.mask = this.element.dataset.mask === "true";
    this.DOMKeydownListener = this.onDOMKeydown.bind(this);
    this.onClickDateListener = this.onClickDate.bind(this);
    const options = this.getOptions();
    this.calendar = new Calendar(this.calendarTarget, options);
    this.calendar.init();
    if (this.hasInputTarget && this.mask) {
      this.setupInputMask();
    }
    this.calendarTarget.removeAttribute("tabindex");
    useClickOutside(this, {
      element: this.contentTarget,
      dispatchEvent: false,
    });
  }
  contentContainerTargetConnected() {
    // Datepicker is shown as a dialog on small screens
    const styles = window.getComputedStyle(this.contentContainerTarget);
    this.isMobile = styles.translate === "-50%";
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
  inputBlur() {
    let dateDisplay = "";
    const date = this.calendar.context.selectedDates[0];
    if (date) {
      dateDisplay = dayjs(date).format(this.format);
    }
    this.inputTarget.value = dateDisplay;
    this.inputContainerTarget.dataset.focus = "false";
  }
  inputDate(event) {
    const value = event.target.value;
    if (value.length === 0) {
      this.calendar.set({
        selectedDates: [],
      });
      this.dateValue = "";
    }
    if (value.length > 0 && dayjs(value, this.format, true).isValid()) {
      const dayjsDate = dayjs(value, this.format).format(DAYJS_FORMAT);
      this.calendar.set({
        selectedDates: [dayjsDate],
      });
      this.dateValue = dayjsDate;
    }
  }
  setContainerFocus() {
    this.inputContainerTarget.dataset.focus = "true";
  }
  clickOutside(event) {
    const target = event.target;
    // Let trigger handle state
    if (target === this.triggerTarget) return;
    if (this.triggerTarget.contains(target)) return;
    if (this.triggerTarget.id === target.getAttribute("for")) return;
    this.close();
  }
  isOpenValueChanged(isOpen, previousIsOpen) {
    if (isOpen) {
      showContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
      });
      // Prevent width from changing when changing to month/year view
      if (!this.contentTarget.dataset.width) {
        const contentWidth = this.contentTarget.offsetWidth;
        this.contentTarget.dataset.width = `${contentWidth}`;
        this.contentTarget.style.maxWidth = `${contentWidth}px`;
        this.contentTarget.style.minWidth = `${contentWidth}px`;
      }
      if (this.isMobile) {
        lockScroll(this.contentTarget.id);
        this.overlayTarget.style.display = "";
        this.overlayTarget.dataset.state = "open";
      } else {
        this.cleanup = initFloatingUi({
          referenceElement: this.hasInputTarget
            ? this.inputTarget
            : this.triggerTarget,
          floatingElement: this.contentContainerTarget,
          side: this.contentTarget.dataset.side,
          align: this.contentTarget.dataset.align,
          sideOffset: 4,
        });
      }
      let elementToFocus = null;
      const focusableElements = getFocusableElements(this.contentTarget);
      const selectedElement = Array.from(focusableElements).find(
        (e) => e.ariaSelected,
      );
      const currentElement = this.contentTarget.querySelector("[aria-current]");
      if (selectedElement) {
        elementToFocus = selectedElement;
      } else if (currentElement) {
        const firstElementChild = currentElement.firstElementChild;
        elementToFocus = firstElementChild;
      } else {
        elementToFocus = focusableElements[0];
      }
      focusElement(elementToFocus);
      this.setupEventListeners();
    } else {
      hideContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
      });
      if (this.isMobile) {
        unlockScroll(this.contentTarget.id);
        this.overlayTarget.style.display = "none";
        this.overlayTarget.dataset.state = "closed";
      }
      if (previousIsOpen) {
        focusTrigger(this.triggerTarget);
      }
      this.cleanupEventListeners();
    }
  }
  dateValueChanged(value) {
    if (value && value.length > 0) {
      const dayjsDate = dayjs(value);
      const formattedDate = dayjsDate.format(this.format);
      if (this.hasInputTarget) this.inputTarget.value = formattedDate;
      if (this.hasTriggerTextTarget) {
        this.triggerTarget.dataset.hasValue = "true";
        this.triggerTextTarget.textContent = formattedDate;
      }
      this.hiddenInputTarget.value = dayjsDate.utc().format();
    } else {
      if (this.hasInputTarget) this.inputTarget.value = "";
      if (this.hasTriggerTextTarget) {
        this.triggerTarget.dataset.hasValue = "false";
        if (this.triggerTarget.dataset.placeholder) {
          this.triggerTextTarget.textContent =
            this.triggerTarget.dataset.placeholder;
        } else {
          this.triggerTextTarget.textContent = "";
        }
      }
      this.hiddenInputTarget.value = "";
    }
  }
  disconnect() {
    this.cleanupEventListeners();
  }
  onClickDate(self) {
    const date = self.context.selectedDates[0];
    if (date) {
      this.dateValue = date;
      this.close();
    } else {
      this.dateValue = "";
    }
  }
  setupEventListeners() {
    document.addEventListener("keydown", this.DOMKeydownListener);
  }
  cleanupEventListeners() {
    if (this.cleanup) this.cleanup();
    document.removeEventListener("keydown", this.DOMKeydownListener);
  }
  getOptions() {
    let options = {
      type: "default",
      enableJumpToSelectedDate: true,
      onClickDate: this.onClickDateListener,
    };
    const date = this.element.dataset.value;
    if (date && dayjs(date).isValid()) {
      const dayjsDate = dayjs(date).format(DAYJS_FORMAT);
      options.selectedDates = [dayjsDate];
    }
    try {
      options = {
        ...options,
        ...JSON.parse(this.element.dataset.options || ""),
      };
    } catch {
      // noop
    }
    if (options.selectedDates && options.selectedDates.length > 0) {
      this.dateValue = `${options.selectedDates[0]}`;
    }
    return options;
  }
  onDOMKeydown(event) {
    if (!this.isOpenValue) return;
    const key = event.key;
    if (key === "Escape") {
      this.close();
    } else if (key === "Tab") {
      handleTabNavigation(this.contentTarget, event);
    } else if (
      ["ArrowUp", "ArrowDown", "ArrowRight", "ArrowLeft"].includes(key) &&
      document.activeElement != this.inputTarget
    ) {
      event.preventDefault();
    }
  }
  setupInputMask() {
    const im = new Inputmask(this.format.replace(/[^/]/g, "9"), {
      showMaskOnHover: false,
    });
    im.mask(this.inputTarget);
  }
};
export { DatePickerController };
