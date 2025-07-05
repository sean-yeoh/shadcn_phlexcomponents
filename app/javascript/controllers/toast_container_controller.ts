import { Controller } from '@hotwired/stimulus'
import DOMPurify from 'dompurify'

const ToastContainerController = class extends Controller<HTMLElement> {
  addToast({
    title,
    description,
    action,
    variant = 'default',
    duration = 5000,
  }: {
    title: string
    description?: string
    action?: string
    variant: string
    duration?: number
  }) {
    const template = (
      variant === 'default'
        ? this.element.querySelector('[data-variant="default"]')
        : this.element.querySelector('[data-variant="destructive"]')
    ) as HTMLTemplateElement

    const clone = template.content.cloneNode(true) as HTMLElement

    const toastTemplate = clone.querySelector(
      '[data-shadcn-phlexcomponents="toast"]',
    ) as HTMLElement
    toastTemplate.dataset.duration = String(duration)

    const titleTemplate = clone.querySelector(
      '[data-shadcn-phlexcomponents="toast-title"]',
    ) as HTMLElement
    const descriptionTemplate = clone.querySelector(
      '[data-shadcn-phlexcomponents="toast-description"]',
    ) as HTMLElement
    const actionTemplate = clone.querySelector(
      '[data-shadcn-phlexcomponents="toast-action"]',
    ) as HTMLElement

    titleTemplate.innerHTML = DOMPurify.sanitize(title)

    if (description) {
      descriptionTemplate.innerHTML = DOMPurify.sanitize(description)
    } else {
      descriptionTemplate.remove()
    }

    if (action) {
      const element = document.createElement('div')
      element.innerHTML = DOMPurify.sanitize(action)
      const actionElement = element.firstElementChild as HTMLElement
      const classes = actionTemplate.classList
      actionElement.classList.add(...classes)
      actionTemplate.replaceWith(actionElement)
    } else {
      actionTemplate.remove()
    }

    this.element.append(clone)
  }
}

type ToastContainer = InstanceType<typeof ToastContainerController>

export { ToastContainerController }
export type { ToastContainer }
