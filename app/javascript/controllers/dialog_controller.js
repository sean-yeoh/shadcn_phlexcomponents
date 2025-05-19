import { Controller } from '@hotwired/stimulus'
import {
  ANIMATION_OUT_DELAY,
  openWithOverlay,
  closeWithOverlay,
  focusTrigger,
  FOCUS_DELAY,
} from '../utils'

export default class extends Controller {
  static targets = ['trigger', 'content']

  connect() {
    this.DOMClickListener = this.onDOMClick.bind(this)
    this.DOMKeydownListener = this.onDOMKeydown.bind(this)

    this.focusableElements = this.contentTarget.querySelectorAll(
      'button, [href], input:not([type="hidden"]), select, textarea, [tabindex]:not([tabindex="-1"])',
    )

    this.firstElement = this.focusableElements[0]
    this.lastElement = this.focusableElements[this.focusableElements.length - 1]
    this.contentElement = document.querySelector(`#${this.contentTarget.id}`)
  }

  open() {
    openWithOverlay([this.contentElement])
    this.contentElement.classList.remove('hidden')
    this.contentElement.dataset.state = 'open'
    this.triggerTarget.ariaExpanded = true
    this.setupEventListeners()

    document.body.appendChild(this.contentElement)

    setTimeout(() => {
      // must be after appendChild
      this.firstElement.focus()
    }, FOCUS_DELAY * 1.25)
  }

  close() {
    closeWithOverlay()
    this.contentElement.dataset.state = 'closed'
    this.triggerTarget.ariaExpanded = false
    this.cleanupEventListeners()
    this.element.appendChild(this.contentElement)

    setTimeout(() => {
      this.contentElement.classList.add('hidden')
    }, ANIMATION_OUT_DELAY)

    focusTrigger(this.triggerTarget)
  }

  isOpen() {
    return this.triggerTarget.ariaExpanded === 'true'
  }

  // Global listeners
  onDOMClick(event) {
    if (!this.isOpen()) return

    const target = event.target
    const trigger = event.target.closest(
      `[data-${this.identifier}-target="trigger"]`,
    )

    if (trigger) return

    const close = target.closest(`[data-action*="${this.identifier}#close"]`)

    if (
      close ||
      (target.dataset.action &&
        target.dataset.action.includes(`${this.identifier}#close`))
    )
      this.close()

    if (this.contentElement.contains(event.target)) return

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

  setupEventListeners() {
    document.addEventListener('click', this.DOMClickListener)
    document.addEventListener('keydown', this.DOMKeydownListener)
  }

  cleanupEventListeners() {
    document.removeEventListener('click', this.DOMClickListener)
    document.removeEventListener('keydown', this.DOMKeydownListener)
  }
}
