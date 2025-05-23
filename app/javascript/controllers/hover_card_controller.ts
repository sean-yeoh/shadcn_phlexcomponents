import { Controller } from '@hotwired/stimulus'
import tippy, { Placement } from 'tippy.js'
import { hideOnEsc } from '../utils'

export default class extends Controller<HTMLElement> {
  static targets = ['trigger', 'content']

  declare readonly triggerTarget: HTMLElement
  declare readonly contentTarget: HTMLElement

  connect() {
    const content = this.contentTarget.innerHTML

    tippy(this.triggerTarget, {
      content: content,
      allowHTML: true,
      interactive: true,
      arrow: false,
      placement: this.element.dataset.side as Placement,
      plugins: [hideOnEsc],
      delay: 250,
    })
  }
}
