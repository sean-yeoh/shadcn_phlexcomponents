import { Controller } from '@hotwired/stimulus'
import { ANIMATION_OUT_DELAY } from '../utils'

const Toast = class extends Controller<HTMLElement> {
  static name = 'toast'

  // custom properties
  declare duration: number
  declare closeTimeout: number

  connect() {
    this.duration = Number(this.element.dataset.duration)
    this.close()
  }

  cancelClose() {
    window.clearTimeout(this.closeTimeout)
  }

  close() {
    if (this.duration > 0) {
      this.closeTimeout = window.setTimeout(() => {
        this.element.dataset.state = 'closed'

        setTimeout(() => {
          this.element.remove()
        }, ANIMATION_OUT_DELAY)
      }, this.duration)
    }
  }
}

export default Toast
