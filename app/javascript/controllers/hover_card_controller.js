import { Controller } from '@hotwired/stimulus'
import {
  computePosition,
  flip,
  shift,
  offset,
  autoUpdate,
} from '@floating-ui/dom'

export default class extends Controller {
  static targets = ['trigger', 'contentWrapper', 'content']

  connect() {
    this.DOMClickListener = this.onDOMClick.bind(this)
    this.DOMKeydownListener = this.onDOMKeydown.bind(this)

    if (this.triggerTarget.dataset.asChild === 'false') {
      this.triggerTarget.firstElementChild.addEventListener('focus', () => {
        this.open()
      })

      this.triggerTarget.firstElementChild.addEventListener('blur', () => {
        this.close()
      })
    } else {
      this.triggerTarget.addEventListener('focus', () => {
        this.open()
      })

      this.triggerTarget.addEventListener('blur', () => {
        this.close()
      })
    }
  }

  toggle() {
    if (this.isOpen()) {
      this.close()
    } else {
      this.openWithDelay()
    }
  }

  isOpen() {
    return this.triggerTarget.dataset.state === 'open'
  }

  open() {
    this.contentWrapperTarget.classList.remove('hidden')
    this.triggerTarget.dataset.state = 'open'
    this.contentTarget.dataset.state = 'open'
    this.setupEventListeners()

    this.cleanup = autoUpdate(
      this.triggerTarget,
      this.contentWrapperTarget,
      () => {
        computePosition(this.triggerTarget, this.contentWrapperTarget, {
          placement: this.element.dataset.side,
          strategy: 'fixed',
          middleware: [flip(), shift(), offset(4)],
        }).then(({ x, y }) => {
          Object.assign(this.contentWrapperTarget.style, {
            left: `${x}px`,
            top: `${y}px`,
          })
        })
      },
    )
  }

  close() {
    if (!this.isOpen()) return

    this.triggerTarget.dataset.state = 'closed'
    this.contentTarget.dataset.state = 'closed'
    this.cleanup()
    this.cleanupEventListeners()

    setTimeout(() => {
      this.contentWrapperTarget.classList.add('hidden')
    }, 100)
  }

  clearOpenTimer() {
    window.clearTimeout(this.openTimer)
  }

  clearCloseTimer() {
    window.clearTimeout(this.closeTimer)
  }

  openWithDelay() {
    this.clearCloseTimer()

    this.openTimer = setTimeout(() => {
      this.open()
    }, 500)
  }

  closeWithDelay() {
    window.clearTimeout(this.openTimer)

    this.closeTimer = setTimeout(() => {
      this.close()
    }, 300)
  }

  // Global listeners
  onDOMClick(event) {
    if (!this.isOpen()) return
    if (this.element.contains(event.target)) return

    this.close()
  }

  onDOMKeydown(event) {
    if (!this.isOpen()) return
    const key = event.key

    if (key === 'Escape') {
      this.close()
    }
  }

  setupEventListeners() {
    document.addEventListener('click', this.DOMClickListener)
    document.addEventListener('keydown', this.DOMKeydownListener)
  }

  cleanupEventListeners() {
    document.removeEventListener('click', this.DOMClickListener)
    document.removeEventListener('keydown', this.DOMKeydownListener)
  }
}
