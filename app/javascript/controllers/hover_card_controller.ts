import { Controller } from '@hotwired/stimulus'
import { useHover } from 'stimulus-use'
import { initFloatingUi } from '../utils/floating_ui'
import { showContent, hideContent } from '../utils'

const HoverCardController = class extends Controller<HTMLElement> {
  // targets
  static targets = ['trigger', 'content', 'contentContainer']
  declare readonly triggerTarget: HTMLElement
  declare readonly contentTarget: HTMLElement
  declare readonly contentContainerTarget: HTMLElement

  // values
  static values = {
    isOpen: Boolean,
  }
  declare isOpenValue: boolean

  // custom properties
  declare closeTimeout: number
  declare DOMKeydownListener: (event: KeyboardEvent) => void
  declare cleanup: () => void

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
    }
  }
}

type HoverCard = InstanceType<typeof HoverCardController>

export { HoverCardController }
export type { HoverCard }
