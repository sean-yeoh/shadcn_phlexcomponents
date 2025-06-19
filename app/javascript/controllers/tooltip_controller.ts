import { Controller } from '@hotwired/stimulus'
import { useHover } from 'stimulus-use'
import { initFloatingUi, ANIMATION_OUT_DELAY } from '../utils'

export default class extends Controller<HTMLElement> {
  static targets = ['trigger', 'content', 'contentContainer', 'arrow']
  static values = {
    isOpen: Boolean,
  }

  declare isOpenValue: boolean
  declare readonly triggerTarget: HTMLElement
  declare readonly contentTarget: HTMLElement
  declare readonly contentContainerTarget: HTMLElement
  declare readonly arrowTarget: HTMLElement
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

  onDOMKeydown(event: KeyboardEvent) {
    if (!this.isOpenValue) return

    const key = event.key

    if (['Escape', 'Enter', ' '].includes(key)) {
      event.preventDefault()
      event.stopImmediatePropagation()
      this.closeImmediately()
    }
  }

  isOpenValueChanged(isOpen: boolean) {
    if (isOpen) {
      this.contentContainerTarget.classList.remove('hidden')
      this.contentTarget.dataset.state = 'open'
      this.setupEventListeners()

      this.cleanup = initFloatingUi({
        referenceElement: this.triggerTarget,
        floatingElement: this.contentContainerTarget,
        arrowElement: this.arrowTarget,
        side: this.contentTarget.dataset.side,
        align: this.contentTarget.dataset.align,
        sideOffset: 8,
      })
    } else {
      this.contentTarget.dataset.state = 'closed'
      this.cleanupEventListeners()

      setTimeout(() => {
        this.contentContainerTarget.classList.add('hidden')
      }, ANIMATION_OUT_DELAY)
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
