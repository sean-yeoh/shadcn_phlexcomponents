import { Controller } from '@hotwired/stimulus'
import { ANIMATION_OUT_DELAY } from '../utils'

const ToastController = class extends Controller<HTMLElement> {
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

type Toast = InstanceType<typeof ToastController>

export { ToastController }
export type { Toast }
