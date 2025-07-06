import { Controller } from '@hotwired/stimulus'
import { useClickOutside } from 'stimulus-use'
import { initFloatingUi } from '../utils/floating_ui'
import {
  focusTrigger,
  getFocusableElements,
  showContent,
  hideContent,
  onClickOutside,
  handleTabNavigation,
  focusElement,
} from '../utils'

const PopoverController = class extends Controller<HTMLElement> {
  // targets
  static targets = ['trigger', 'contentContainer', 'content']
  declare readonly triggerTarget: HTMLElement
  declare readonly contentContainerTarget: HTMLElement
  declare readonly contentTarget: HTMLElement

  // values
  static values = { isOpen: Boolean }
  declare isOpenValue: boolean

  // custom properties
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
  }

  close() {
    this.isOpenValue = false
  }

  clickOutside(event: MouseEvent) {
    onClickOutside(this, event)
  }

  isOpenValueChanged(isOpen: boolean, previousIsOpen: boolean) {
    if (isOpen) {
      showContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
      })

      this.cleanup = initFloatingUi({
        referenceElement: this.triggerTarget,
        floatingElement: this.contentContainerTarget,
        side: this.contentTarget.dataset.side,
        align: this.contentTarget.dataset.align,
        sideOffset: 4,
      })

      const focusableElements = getFocusableElements(this.contentTarget)
      focusElement(focusableElements[0])

      this.setupEventListeners()
    } else {
      hideContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
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

  protected setupEventListeners() {
    document.addEventListener('keydown', this.DOMKeydownListener)
  }

  protected cleanupEventListeners() {
    if (this.cleanup) this.cleanup()
    document.removeEventListener('keydown', this.DOMKeydownListener)
  }

  protected onDOMKeydown(event: KeyboardEvent) {
    if (!this.isOpenValue) return

    const key = event.key

    if (key === 'Escape') {
      this.close()
    } else if (key === 'Tab') {
      handleTabNavigation(this.contentTarget, event)
    }
  }
}

type Popover = InstanceType<typeof PopoverController>

export { PopoverController }
export type { Popover }
