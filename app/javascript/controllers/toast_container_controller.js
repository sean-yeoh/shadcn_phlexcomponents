import { Controller } from "@hotwired/stimulus";
import DOMPurify from "dompurify";
const ToastContainerController = class extends Controller {
  addToast({
    title,
    description,
    action,
    variant = "default",
    duration = 5000,
  }) {
    const template =
      variant === "default"
        ? this.element.querySelector('[data-variant="default"]')
        : this.element.querySelector('[data-variant="destructive"]');
    const clone = template.content.cloneNode(true);
    const toastTemplate = clone.querySelector(
      '[data-shadcn-phlexcomponents="toast"]',
    );
    toastTemplate.dataset.duration = String(duration);
    const titleTemplate = clone.querySelector(
      '[data-shadcn-phlexcomponents="toast-title"]',
    );
    const descriptionTemplate = clone.querySelector(
      '[data-shadcn-phlexcomponents="toast-description"]',
    );
    const actionTemplate = clone.querySelector(
      '[data-shadcn-phlexcomponents="toast-action"]',
    );
    titleTemplate.innerHTML = DOMPurify.sanitize(title);
    if (description) {
      descriptionTemplate.innerHTML = DOMPurify.sanitize(description);
    } else {
      descriptionTemplate.remove();
    }
    if (action) {
      const element = document.createElement("div");
      element.innerHTML = DOMPurify.sanitize(action);
      const actionElement = element.firstElementChild;
      const classes = actionTemplate.classList;
      actionElement.classList.add(...classes);
      actionTemplate.replaceWith(actionElement);
    } else {
      actionTemplate.remove();
    }
    this.element.append(clone);
  }
};
export { ToastContainerController };
