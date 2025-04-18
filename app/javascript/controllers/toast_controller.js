import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    this.focusableElements = this.element.querySelectorAll('button')
    this.duration = Number(this.element.dataset.duration)

    this.focusableElements.forEach((el) => {
      el.addEventListener('focus', () => {
        this.cancelDismiss()
      })
      el.addEventListener('blur', () => {
        this.dismiss()
      })
    })

    this.dismiss()
  }

  cancelDismiss() {
    window.clearTimeout(this.timer)
  }

  close() {
    this.element.dataset.state = 'closed'

    setTimeout(() => {
      this.element.remove()
    }, 100)
  }

  dismiss(event) {
    if (event && event.type === 'mouseout') {
      if (this.element.contains(document.activeElement)) {
        return
      }
    }

    if (this.duration > 0) {
      this.timer = setTimeout(() => {
        this.close()
      }, this.duration)
    }
  }
}
