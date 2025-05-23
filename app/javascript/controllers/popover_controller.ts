import { Controller } from '@hotwired/stimulus'
import {
  ANIMATION_OUT_DELAY,
  FOCUS_DELAY,
  initFloatingUi,
  focusTrigger,
} from '../utils'

export default class extends Controller<HTMLElement> {
  static targets = ['trigger', 'contentWrapper', 'content']

  declare readonly triggerTarget: HTMLElement
  declare readonly contentWrapperTarget: HTMLElement
  declare readonly contentTarget: HTMLElement
  declare DOMClickListener: (event: MouseEvent) => void
  declare DOMKeydownListener: (event: KeyboardEvent) => void
  declare focusableElements: HTMLElement[]
  declare firstElement: HTMLElement
  declare lastElement: HTMLElement
  declare cleanup: () => void

  connect() {
    this.DOMClickListener = this.onDOMClick.bind(this)
    this.DOMKeydownListener = this.onDOMKeydown.bind(this)

    this.focusableElements = Array.from(
      this.contentTarget.querySelectorAll(
        'button, [href], input:not([type="hidden"]), select, textarea, [tabindex]:not([tabindex="-1"])',
      ),
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

  onDOMClick(event: MouseEvent) {
    if (!this.isOpen()) return
    if (this.element.contains(event.target as HTMLElement)) return
    this.close()
  }

  onDOMKeydown(event: KeyboardEvent) {
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
    this.triggerTarget.ariaExpanded = 'true'
    this.contentTarget.dataset.state = 'open'
    this.setupEventListeners()

    this.onOpen()
  }

  onOpen() {
    setTimeout(() => {
      if (this.firstElement) {
        this.firstElement.focus()
      }
    }, FOCUS_DELAY * 1.25)

    this.cleanup = initFloatingUi(
      this.triggerTarget,
      this.contentWrapperTarget,
      this.element.dataset.side,
    )
  }

  close() {
    this.contentTarget.dataset.state = 'closed'
    this.triggerTarget.ariaExpanded = 'false'
    this.cleanup()
    this.cleanupEventListeners()

    setTimeout(() => {
      this.contentWrapperTarget.classList.add('hidden')
    }, ANIMATION_OUT_DELAY)

    this.onClose()
  }

  onClose() {
    focusTrigger(this.triggerTarget)
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
