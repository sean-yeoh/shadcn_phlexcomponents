import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['trigger', 'content']

  connect() {
    this.DOMClickListener = this.onDOMClick.bind(this)
    this.DOMKeydownListener = this.onDOMKeydown.bind(this)

    this.focusableElements = this.contentTarget.querySelectorAll(
      'button, [href], input:not([type="hidden"]), select, textarea, [tabindex]:not([tabindex="-1"])',
    )

    this.firstElement = this.focusableElements[0]
    this.lastElement = this.focusableElements[this.focusableElements.length - 1]
    this.contentElement = document.querySelector(`#${this.contentTarget.id}`)
  }

  open() {
    this.showOverlay()
    this.contentElement.classList.remove('hidden')
    this.contentElement.dataset.state = 'open'
    this.triggerTarget.ariaExpanded = true
    this.setupEventListeners()
    this.addInert()

    if (window.innerHeight < document.documentElement.scrollHeight) {
      document.body.dataset.scrollLocked = 1
    }
    document.body.appendChild(this.contentElement)
    this.firstElement.focus() // must be after appendChild
  }

  close() {
    this.contentElement.dataset.state = 'closed'
    this.triggerTarget.ariaExpanded = false
    this.cleanupEventListeners()
    this.removeInert()
    this.element.appendChild(this.contentElement)

    setTimeout(() => {
      this.contentElement.classList.add('hidden')
    }, 100)

    setTimeout(() => {
      delete document.body.dataset.scrollLocked
      this.removeOverlay()
    }, 150)

    this.focusTrigger()
  }

  focusTrigger() {
    if (this.triggerTarget.dataset.asChild === 'false') {
      this.triggerTarget.firstElementChild.focus()
    } else {
      this.triggerTarget.focus()
    }
  }

  isOpen() {
    return this.triggerTarget.ariaExpanded === 'true'
  }

  showOverlay() {
    const elem = document.createElement('div')
    elem.classList.add(
      'fixed',
      'inset-0',
      'z-50',
      'bg-black/80',
      'data-[state=open]:animate-in',
      'data-[state=closed]:animate-out',
      'data-[state=closed]:fade-out-0',
      'data-[state=open]:fade-in-0',
      'pointer-events-auto',
    )
    elem.dataset.state = 'open'
    elem.ariaHidden = true
    elem.dataset.overlay = true
    document.body.appendChild(elem)
  }

  removeOverlay() {
    if (document.querySelector('[data-overlay]')) {
      document.querySelector('[data-overlay]').remove()
    }
  }

  // Global listeners
  onDOMClick(event) {
    if (!this.isOpen()) return

    const target = event.target
    const trigger = event.target.closest(
      '[data-shadcn-phlexcomponents--sheet-target="trigger"]',
    )

    if (trigger) return

    const close = target.closest(
      '[data-action*="shadcn-phlexcomponents--sheet#close"]',
    )

    if (
      close ||
      (target.dataset.action &&
        target.dataset.action.includes('shadcn-phlexcomponents--sheet#close'))
    )
      this.close()

    if (this.contentElement.contains(event.target)) return

    this.close()
  }

  onDOMKeydown(event) {
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

  setupEventListeners() {
    document.addEventListener('click', this.DOMClickListener)
    document.addEventListener('keydown', this.DOMKeydownListener)
  }

  cleanupEventListeners() {
    document.removeEventListener('click', this.DOMClickListener)
    document.removeEventListener('keydown', this.DOMKeydownListener)
  }

  addInert() {
    Array.from(document.body.children)
      .filter((el) => el !== this.contentElement)
      .forEach((el) => el.setAttribute('inert', ''))
  }

  removeInert() {
    Array.from(document.body.children)
      .filter((el) => el.hasAttribute('inert'))
      .forEach((el) => el.removeAttribute('inert'))
  }
}
