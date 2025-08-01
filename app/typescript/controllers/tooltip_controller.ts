import { Controller } from '@hotwired/stimulus'
import { useHover } from 'stimulus-use'
import { initFloatingUi } from '../utils/floating_ui'
import { showContent, hideContent } from '../utils'

const TooltipController = class extends Controller<HTMLElement> {
  static name = 'tooltip'

  // targets
  static targets = ['trigger', 'content', 'contentContainer', 'arrow']
  declare readonly triggerTarget: HTMLElement
  declare readonly contentTarget: HTMLElement
  declare readonly contentContainerTarget: HTMLElement
  declare readonly arrowTarget: HTMLElement

  // values
  static values = {
    isOpen: Boolean,
  }
  declare isOpenValue: boolean

  // custom properties
  declare closeTimeout: number
  declare cleanup: () => void
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

  closeImmediately() {
    this.isOpenValue = false
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
        arrowElement: this.arrowTarget,
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

  protected onDOMKeydown(event: KeyboardEvent) {
    if (!this.isOpenValue) return

    const key = event.key

    if (['Escape', 'Enter', ' '].includes(key)) {
      event.preventDefault()
      event.stopImmediatePropagation()
      this.closeImmediately()
    }
  }

  protected setupEventListeners() {
    document.addEventListener('keydown', this.DOMKeydownListener)
  }

  protected cleanupEventListeners() {
    if (this.cleanup) this.cleanup()
    document.removeEventListener('keydown', this.DOMKeydownListener)
  }
}

type Tooltip = InstanceType<typeof TooltipController>

export { TooltipController }
export type { Tooltip }
