import { Controller } from '@hotwired/stimulus'
import tippy from 'tippy.js'
import { hideOnEsc } from '../utils'

export default class extends Controller {
  static targets = ['trigger', 'content']

  connect() {
    const content = this.contentTarget.innerHTML

    this.tippy = tippy(this.triggerTarget, {
      content: content,
      allowHTML: true,
      interactive: true,
      arrow: false,
      placement: this.element.dataset.side,
      plugins: [hideOnEsc],
      delay: 250,
    })
  }
}
