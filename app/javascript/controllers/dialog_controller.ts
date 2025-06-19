import { Controller } from '@hotwired/stimulus'
import { useClickOutside } from 'stimulus-use'
import {
  ON_OPEN_FOCUS_DELAY,
  openWithOverlay,
  closeWithOverlay,
  focusTrigger,
  showContent,
  hideContent,
  getFocusableElements,
} from '../utils'

export default class extends Controller<HTMLElement> {
  static targets = ['trigger', 'content']
  static values = {
    isOpen: Boolean,
  }

  declare readonly triggerTarget: HTMLElement
  declare readonly contentTarget: HTMLElement
  declare readonly hasContentTarget: boolean
  declare isOpenValue: boolean
  declare DOMKeydownListener: (event: KeyboardEvent) => void

  connect() {
    this.DOMKeydownListener = this.onDOMKeydown.bind(this)
    useClickOutside(this, { element: this.contentTarget })
  }

  open() {
    this.isOpenValue = true

    setTimeout(() => {
      this.onOpenFocusedElement().focus()
    }, ON_OPEN_FOCUS_DELAY)
  }

  onOpenFocusedElement() {
    const focusableElements = getFocusableElements(this.contentTarget)
    return focusableElements[0]
  }

  close() {
    this.isOpenValue = false
  }

  onDOMKeydown(event: KeyboardEvent) {
    if (!this.isOpenValue) return

    const key = event.key

    if (key === 'Escape') {
      this.close()
    } else if (key === 'Tab') {
      const focusableElements = getFocusableElements(this.contentTarget)

      const firstElement = focusableElements[0]
      const lastElement = focusableElements[focusableElements.length - 1]

      // If Shift + Tab pressed on first element, go to last element
      if (event.shiftKey && document.activeElement === firstElement) {
        event.preventDefault()
        lastElement.focus()
      }
      // If Tab pressed on last element, go to first element
      else if (!event.shiftKey && document.activeElement === lastElement) {
        event.preventDefault()
        firstElement.focus()
      }
    }
  }

  isOpenValueChanged(isOpen: boolean, previousIsOpen: boolean) {
    if (isOpen) {
      openWithOverlay(this.contentTarget.id)

      showContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentTarget,
      })

      this.setupEventListeners()
    } else {
      closeWithOverlay(this.contentTarget.id)

      hideContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentTarget,
      })

      this.cleanupEventListeners()

      // Only focus trigger when is previously opened
      if (previousIsOpen) {
        focusTrigger(this.triggerTarget)
      }
    }
  }

  setupEventListeners() {
    document.addEventListener('keydown', this.DOMKeydownListener)
  }

  cleanupEventListeners() {
    document.removeEventListener('keydown', this.DOMKeydownListener)
  }

  disconnect() {
    this.cleanupEventListeners()
  }
}
