import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  add({ title, description, variant = 'default' }) {
    const template =
      variant === 'default'
        ? this.element.querySelector('[data-variant="default"]')
        : this.element.querySelector('[data-variant="destructive"]')

    const clone = template.content.cloneNode(true)

    if (title) {
      clone.querySelector('[data-title]').textContent = title
    }

    if (description) {
      clone.querySelector('[data-description]').textContent = description
    }

    this.element.append(clone)
  }
}
