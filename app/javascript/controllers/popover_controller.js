import { Controller } from '@hotwired/stimulus'
import {
  computePosition,
  flip,
  shift,
  offset,
  autoUpdate,
} from '@floating-ui/dom'

export default class extends Controller {
  static targets = ['trigger', 'contentWrapper', 'content', 'menuItem']

  connect() {
    this.DOMClickListener = this.onDOMClick.bind(this)
    this.DOMKeydownListener = this.onDOMKeydown.bind(this)

    this.focusableElements = this.contentTarget.querySelectorAll(
      'button, [href], input:not([type="hidden"]), select, textarea, [tabindex]:not([tabindex="-1"])',
    )

    this.firstElement = this.focusableElements[0]
    this.lastElement = this.focusableElements[this.focusableElements.length - 1]
  }

  toggle() {
    if (this.isOpen()) {
      this.close()
    } else {
      this.open()
    }
  }

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
    } else if (key === 'Tab') {
      // If Shift + Tab pressed on first element, go to last element
      if (event.shiftKey && document.activeElement === this.firstElement) {
        event.preventDefault()
        this.lastElement.focus()
      }
      // If Tab pressed on last element, go to first element
      else if (!event.shiftKey && document.activeElement === this.lastElement) {
        event.preventDefault()
        this.firstElement.focus()
      }
    }
  }

  isOpen() {
    return this.triggerTarget.ariaExpanded === 'true'
  }

  open() {
    this.contentWrapperTarget.classList.remove('hidden')
    this.triggerTarget.ariaExpanded = true
    this.contentTarget.dataset.state = 'open'
    this.setupEventListeners()

    setTimeout(() => {
      this.firstElement.focus()
    }, 100)

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
    this.contentTarget.dataset.state = 'closed'
    this.triggerTarget.ariaExpanded = false
    this.cleanup()
    this.cleanupEventListeners()

    setTimeout(() => {
      this.contentWrapperTarget.classList.add('hidden')
    }, 100)

    this.focusTrigger()
  }

  focusTrigger() {
    if (this.triggerTarget.dataset.asChild === 'false') {
      this.triggerTarget.firstElementChild.focus()
    } else {
      this.triggerTarget.focus()
    }
  }

  // Global listeners
  setupEventListeners() {
    document.addEventListener('click', this.DOMClickListener)
    document.addEventListener('keydown', this.DOMKeydownListener)
  }

  cleanupEventListeners() {
    document.removeEventListener('click', this.DOMClickListener)
    document.removeEventListener('keydown', this.DOMKeydownListener)
  }
}
