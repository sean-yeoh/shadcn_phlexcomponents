import { Controller } from '@hotwired/stimulus'

export default class extends Controller<HTMLElement> {
  add({
    title,
    description,
    variant = 'default',
  }: {
    title: string
    description: string
    variant: string
  }) {
    const template = (
      variant === 'default'
        ? this.element.querySelector('[data-variant="default"]')
        : this.element.querySelector('[data-variant="destructive"]')
    ) as HTMLTemplateElement

    const clone = template.content.cloneNode(true) as HTMLElement

    if (title) {
      const titleElement = clone.querySelector('[data-title]') as HTMLElement
      titleElement.textContent = title
    }

    if (description) {
      const descriptionElement = clone.querySelector('[data-description]')
      if (descriptionElement) {
        descriptionElement.textContent = description
      }
    }

    this.element.append(clone)
  }
}
