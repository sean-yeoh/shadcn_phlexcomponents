import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['trigger', 'content', 'close']

  connect() {
    this.contentTarget.dataset.state = this.isOpen() ? 'open' : 'closed'
    this.clickListener = this.onClick.bind(this)
    this.keydownListener = this.onKeydown.bind(this)

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
    document.body.dataset.scrollLocked = 1
    this.setupEventListeners()

    document.body.appendChild(this.contentElement)
    this.firstElement.focus()
    this.addInert()
  }

  close() {
    this.contentElement.dataset.state = 'closed'
    this.triggerTarget.ariaExpanded = false

    setTimeout(() => {
      this.contentElement.classList.add('hidden')
    }, 100)

    setTimeout(() => {
      delete document.body.dataset.scrollLocked
      this.removeOverlay()
    }, 150)

    this.cleanupEventListeners()

    this.removeInert()
    this.element.appendChild(this.contentElement)

    if (this.triggerTarget.nodeName === 'DIV') {
      this.triggerTarget.firstElementChild.focus()
    } else {
      this.triggerTarget.focus()
    }
  }

  toggle() {
    if (this.isOpen()) {
      this.close()
    } else {
      this.open()
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
    document.querySelector('[data-overlay]').remove()
  }

  // Global listeners
  onClick(event) {
    if (!this.isOpen()) return

    if (
      event.target.dataset.action &&
      event.target.dataset.action.includes(
        'shadcn-phlexcomponents--alert-dialog#toggle',
      )
    )
      return

    const close = event.target.closest(
      '[data-action*="shadcn-phlexcomponents--alert-dialog#close"]',
    )

    if (
      close ||
      (event.target.dataset.action &&
        event.target.dataset.action.includes(
          'shadcn-phlexcomponents--alert-dialog#close',
        ))
    )
      this.close()
  }

  onKeydown(event) {
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
    document.addEventListener('click', this.clickListener)
    document.addEventListener('keydown', this.keydownListener)
  }

  cleanupEventListeners() {
    document.removeEventListener('click', this.clickListener)
    document.removeEventListener('keydown', this.keydownListener)
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
