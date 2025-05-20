import { Controller } from '@hotwired/stimulus'
import {
  ANIMATION_OUT_DELAY,
  FOCUS_DELAY,
  lockScroll,
  unlockScroll,
  initFloatingUi,
  focusTrigger,
} from '../utils'

export default class extends Controller {
  static targets = ['trigger', 'contentWrapper', 'content', 'item']

  connect() {
    this.DOMClickListener = this.onDOMClick.bind(this)
    this.DOMKeydownListener = this.onDOMKeydown.bind(this)
    this.items = this.itemTargets.filter(
      (item) => item.dataset.disabled === undefined,
    )
  }

  toggle(event) {
    const key = event.key

    if (this.isOpen()) {
      this.close()
    } else {
      this.open()
    }

    if (event.currentTarget === this.triggerTarget) {
      if (['ArrowDown', 'Enter', ' '].includes(key)) {
        setTimeout(() => {
          this.focusItem(null, 0)
        }, FOCUS_DELAY)
      }
    }
  }

  isOpen() {
    return this.triggerTarget.ariaExpanded === 'true'
  }

  open() {
    lockScroll()
    this.contentWrapperTarget.classList.remove('hidden')
    this.triggerTarget.ariaExpanded = true
    this.triggerTarget.dataset.state = 'open'
    this.contentTarget.dataset.state = 'open'

    setTimeout(() => {
      this.focusContent()
    }, FOCUS_DELAY * 1.25)

    this.setupEventListeners()

    this.cleanup = initFloatingUi(
      this.triggerTarget,
      this.contentWrapperTarget,
      this.element.dataset.side,
    )
  }

  close() {
    unlockScroll()
    this.triggerTarget.ariaExpanded = false
    this.triggerTarget.dataset.state = 'closed'
    this.contentTarget.dataset.state = 'closed'
    this.cleanup()
    this.cleanupEventListeners()

    setTimeout(() => {
      this.contentWrapperTarget.classList.add('hidden')
    }, ANIMATION_OUT_DELAY)

    focusTrigger(this.triggerTarget)
  }

  focusItem(event = null, index = null) {
    let itemIndex = index

    if (event) {
      const item = event.currentTarget || event.target
      itemIndex = this.items.indexOf(item)
    }

    this.items.forEach((item, index) => {
      if (index === itemIndex) {
        item.tabIndex = 0
        item.focus()
      } else {
        item.tabIndex = -1
      }
    })
  }

  focusFirstItem() {
    this.focusItem(null, 0)
  }

  focusLastItem() {
    this.focusItem(null, this.items.length - 1)
  }

  focusNextItem(event) {
    const item = event.currentTarget || event.target
    const index = this.items.indexOf(item)
    if (index === this.items.length - 1) return

    this.focusItem(null, index + 1)
  }

  focusPrevItem(event) {
    const item = event.currentTarget
    const index = this.items.indexOf(item)
    if (index === 0) return

    this.focusItem(null, index - 1)
  }

  focusContent() {
    this.items.forEach((item) => {
      item.blur()
    })

    this.contentTarget.focus()
  }

  selectItem(event) {
    if (!this.isOpen()) return

    const key = event.key
    const item = event.currentTarget || event.target

    if (key === 'Enter' || key === ' ') {
      item.click()
    }

    this.close()
  }

  // Global listeners
  onDOMClick(event) {
    if (!this.isOpen()) return
    if (this.element.contains(event.target)) return

    this.close()
  }

  onDOMKeydown(event) {
    if (!this.isOpen()) return

    const key = event.key

    if (['Tab', 'Enter', ' '].includes(key)) event.preventDefault()

    if (key === 'Escape') {
      this.close()
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
