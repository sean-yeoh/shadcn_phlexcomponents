import { Controller } from '@hotwired/stimulus'
import { useHover } from 'stimulus-use'
import { initFloatingUi, showContent, hideContent } from '../utils'

export default class extends Controller<HTMLElement> {
  static targets = ['trigger', 'content', 'contentContainer']
  static values = {
    isOpen: Boolean,
  }

  declare isOpenValue: boolean
  declare readonly triggerTarget: HTMLElement
  declare readonly contentTarget: HTMLElement
  declare readonly contentContainerTarget: HTMLElement
  declare cleanup: () => void
  declare closeTimeout: number
  declare DOMKeydownListener: (event: KeyboardEvent) => void

  connect() {
    this.DOMKeydownListener = this.onDOMKeydown.bind(this)
    useHover(this, { element: this.triggerTarget, dispatchEvent: false })
  }

  open() {
    window.clearTimeout(this.closeTimeout)
    this.isOpenValue = true
  }

  close() {
    this.closeTimeout = window.setTimeout(() => {
      this.isOpenValue = false
    }, 250)
  }

  // for useHover
  mouseEnter() {
    this.open()
  }

  // for useHover
  mouseLeave() {
    this.close()
  }

  setupEventListeners() {
    document.addEventListener('keydown', this.DOMKeydownListener)
  }

  cleanupEventListeners() {
    if (this.cleanup) this.cleanup()
    document.removeEventListener('keydown', this.DOMKeydownListener)
  }

  onDOMKeydown(event: KeyboardEvent) {
    if (!this.isOpenValue) return

    const key = event.key

    if (key === 'Escape') {
      this.close()
    }
  }

  isOpenValueChanged(isOpen: boolean) {
    if (isOpen) {
      showContent({
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
      })

      this.setupEventListeners()

      this.cleanup = initFloatingUi({
        referenceElement: this.triggerTarget,
        floatingElement: this.contentContainerTarget,
        side: this.contentTarget.dataset.side,
        align: this.contentTarget.dataset.align,
        sideOffset: 4,
      })
    } else {
      hideContent({
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
      })

      this.cleanupEventListeners()
    }
  }

  disconnect() {
    this.cleanupEventListeners()
  }
}
