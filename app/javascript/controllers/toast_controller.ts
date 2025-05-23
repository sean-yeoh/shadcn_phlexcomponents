import { Controller } from '@hotwired/stimulus'
import { ANIMATION_OUT_DELAY } from '../utils'

export default class extends Controller<HTMLElement> {
  declare focusableElements: HTMLButtonElement[]
  declare duration: number
  declare timer: number

  connect() {
    this.focusableElements = Array.from(this.element.querySelectorAll('button'))
    this.duration = Number(this.element.dataset.duration)

    this.focusableElements.forEach((el) => {
      el.addEventListener('focus', () => {
        this.cancelDismiss()
      })
      el.addEventListener('blur', () => {
        this.dismiss(null)
      })
    })

    this.dismiss(null)
  }

  cancelDismiss() {
    window.clearTimeout(this.timer)
  }

  close() {
    this.element.dataset.state = 'closed'

    setTimeout(() => {
      this.element.remove()
    }, ANIMATION_OUT_DELAY)
  }

  dismiss(event: MouseEvent | null) {
    if (event && event.type === 'mouseout') {
      if (this.element.contains(document.activeElement)) {
        return
      }
    }

    if (this.duration > 0) {
      this.timer = window.setTimeout(() => {
        this.close()
      }, this.duration)
    }
  }
}
