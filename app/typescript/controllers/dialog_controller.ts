import { Controller } from '@hotwired/stimulus'
import {
  focusElement,
  focusTrigger,
  showContent,
  hideContent,
  getFocusableElements,
  anyNestedComponentsOpen,
  handleTabNavigation,
} from '../utils'

const DialogController = class extends Controller<HTMLElement> {
  static name = 'dialog'

  // targets
  static targets = ['trigger', 'content', 'overlay']
  declare readonly triggerTarget: HTMLElement
  declare readonly contentTarget: HTMLElement
  declare readonly overlayTarget: HTMLElement

  // values
  static values = {
    isOpen: Boolean,
  }
  declare isOpenValue: boolean

  // custom properties
  declare trigger: HTMLElement
  declare DOMKeydownListener: (event: KeyboardEvent) => void
  declare DOMClickListener: (event: MouseEvent) => void

  connect() {
    this.DOMKeydownListener = this.onDOMKeydown.bind(this)
    this.DOMClickListener = this.onDOMClick.bind(this)
  }

  open() {
    this.isOpenValue = true
  }

  close() {
    this.isOpenValue = false
  }

  isOpenValueChanged(isOpen: boolean, previousIsOpen: boolean) {
    if (isOpen) {
      showContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentTarget,
        appendToBody: true,
        overlay: this.overlayTarget,
      })

      const focusableElements = getFocusableElements(this.contentTarget)
      focusElement(focusableElements[0])

      this.setupEventListeners()
    } else {
      hideContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentTarget,
        overlay: this.overlayTarget,
      })

      if (previousIsOpen) {
        focusTrigger(this.triggerTarget)
      }

      this.cleanupEventListeners()
    }
  }

  disconnect() {
    this.cleanupEventListeners()
  }

  protected onDOMClick(event: MouseEvent) {
    if (!this.isOpenValue) return

    const target = event.target as HTMLElement
    if (target === this.triggerTarget) return
    if (this.contentTarget.contains(target)) return

    const shouldClose = !anyNestedComponentsOpen(this.contentTarget)
    if (shouldClose) this.close()
  }

  onDOMKeydown(event: KeyboardEvent) {
    if (!this.isOpenValue) return

    const key = event.key

    if (key === 'Escape') {
      const shouldClose = !anyNestedComponentsOpen(this.contentTarget)
      if (shouldClose) this.close()
    } else if (key === 'Tab') {
      handleTabNavigation(this.contentTarget, event)
    }
  }

  setupEventListeners() {
    document.addEventListener('keydown', this.DOMKeydownListener)
    document.addEventListener('pointerdown', this.DOMClickListener)
  }

  cleanupEventListeners() {
    document.removeEventListener('keydown', this.DOMKeydownListener)
    document.removeEventListener('pointerdown', this.DOMClickListener)
  }
}

type Dialog = InstanceType<typeof DialogController>

export { DialogController }
export type { Dialog }
