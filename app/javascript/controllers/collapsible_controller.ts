import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['trigger', 'content', 'item']

  declare readonly triggerTarget: HTMLElement
  declare readonly contentTarget: HTMLElement
  declare readonly itemTarget: HTMLElement

  connect() {
    if (this.isOpen()) {
      this.open()
    }
  }

  toggle() {
    if (this.isOpen()) {
      this.close()
    } else {
      this.open()
    }
  }

  isOpen() {
    return this.triggerTarget.ariaExpanded === 'true'
  }

  open() {
    this.triggerTarget.ariaExpanded = 'true'
    this.triggerTarget.dataset.state = 'open'
    this.contentTarget.classList.remove('hidden')
  }

  close() {
    this.triggerTarget.ariaExpanded = 'false'
    this.triggerTarget.dataset.state = 'closed'
    this.contentTarget.classList.add('hidden')
  }
}
