import { Controller } from '@hotwired/stimulus'
import { useClickOutside } from 'stimulus-use'
import {
  initFloatingUi,
  focusTrigger,
  ON_OPEN_FOCUS_DELAY,
  getFocusableElements,
  showContent,
  hideContent,
} from '../utils'

export default class extends Controller<HTMLElement> {
  static targets = ['trigger', 'contentContainer', 'content']
  static values = { isOpen: Boolean }

  declare isOpenValue: boolean
  declare readonly triggerTarget: HTMLElement
  declare readonly contentContainerTarget: HTMLElement
  declare readonly contentTarget: HTMLElement
  declare DOMKeydownListener: (event: KeyboardEvent) => void
  declare cleanup: () => void

  connect() {
    this.DOMKeydownListener = this.onDOMKeydown.bind(this)
    useClickOutside(this, { element: this.contentTarget, dispatchEvent: false })
  }

  toggle() {
    if (this.isOpenValue) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.isOpenValue = true
    this.onOpen()

    setTimeout(() => {
      this.onOpenFocusedElement().focus()
    }, ON_OPEN_FOCUS_DELAY)
  }

  close() {
    this.isOpenValue = false
    this.onClose()
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

  clickOutside(event: MouseEvent) {
    const target = event.target
    // Let #toggle to handle state when clicked on trigger
    if (target === this.triggerTarget) return

    this.close()
  }

  onOpen() {}

  onOpenFocusedElement() {
    const focusableElements = getFocusableElements(this.contentTarget)
    return focusableElements[0]
  }

  onClose() {}

  referenceElement() {
    return this.triggerTarget
  }

  isOpenValueChanged(isOpen: boolean, previousIsOpen: boolean) {
    if (isOpen === true) {
      showContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
      })

      this.cleanup = initFloatingUi({
        referenceElement: this.referenceElement(),
        floatingElement: this.contentContainerTarget,
        side: this.contentTarget.dataset.side,
        align: this.contentTarget.dataset.align,
        sideOffset: 4,
      })
      this.setupEventListeners()
    } else {
      hideContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
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
    if (this.cleanup) this.cleanup()
    document.removeEventListener('keydown', this.DOMKeydownListener)
  }

  disconnect() {
    this.cleanupEventListeners()
  }
}
