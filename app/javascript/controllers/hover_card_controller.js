import { Controller } from '@hotwired/stimulus'
import tippy from 'tippy.js'

const hideOnEsc = {
  name: 'hideOnEsc',
  defaultValue: true,
  fn({ hide }) {
    function onKeyDown(event) {
      if (event.keyCode === 27) {
        hide()
      }
    }

    return {
      onShow() {
        document.addEventListener('keydown', onKeyDown)
      },
      onHide() {
        document.removeEventListener('keydown', onKeyDown)
      },
    }
  },
}

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
      offset: [0, 4],
      delay: 250,
    })
  }
}
