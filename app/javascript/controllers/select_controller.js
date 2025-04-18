import { Controller } from '@hotwired/stimulus'
import {
  computePosition,
  flip,
  shift,
  offset,
  autoUpdate,
} from '@floating-ui/dom'

export default class extends Controller {
  static targets = [
    'trigger',
    'contentWrapper',
    'content',
    'item',
    'triggerText',
    'group',
    'label',
    'select',
  ]

  static values = {
    selected: String,
  }

  connect() {
    this.DOMClickListener = this.onDOMClick.bind(this)
    this.DOMKeydownListener = this.onDOMKeydown.bind(this)

    this.setAriaLabelledby()

    this.items = [
      ...this.element.querySelectorAll(
        '[data-shadcn-phlexcomponents--select-target="item"]:not([data-disabled])',
      ),
    ]

    this.search = ''
    this.searchTimer = null
    this.resetSearchTimer = null
  }

  // Methods
  toggle() {
    if (this.isOpen()) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    const triggerWidth = this.triggerTarget.offsetWidth
    this.contentWrapperTarget.classList.remove('hidden')

    const contentWrapperWidth = this.contentWrapperTarget.offsetWidth

    if (contentWrapperWidth < triggerWidth) {
      this.contentWrapperTarget.style.width = `${triggerWidth}px`
    }

    this.triggerTarget.ariaExpanded = true
    this.contentTarget.dataset.state = 'open'

    if (this.selectedValue) {
      const item = this.itemTargets.find(
        (i) => i.dataset.value === this.selectedValue,
      )

      if (item && !item.dataset.disabled) {
        item.focus()
      } else {
        this.contentTarget.focus()
      }
    } else {
      this.focusItem(null, 0)
    }

    if (window.innerHeight < document.documentElement.scrollHeight) {
      document.body.dataset.scrollLocked = 1
    }
    this.setupEventListeners()

    this.cleanup = autoUpdate(
      this.triggerTarget,
      this.contentWrapperTarget,
      () => {
        computePosition(this.triggerTarget, this.contentWrapperTarget, {
          placement: 'bottom',
          strategy: 'fixed',
          middleware: [flip(), shift(), offset(4)],
        }).then(({ x, y }) => {
          Object.assign(this.contentWrapperTarget.style, {
            left: `${x}px`,
            top: `${y}px`,
          })
        })
      },
    )
  }

  close() {
    this.contentTarget.dataset.state = 'closed'
    this.triggerTarget.ariaExpanded = false
    this.cleanup()
    this.cleanupEventListeners()
    delete document.body.dataset.scrollLocked

    setTimeout(() => {
      this.contentWrapperTarget.classList.add('hidden')
    }, 100)

    if (this.triggerTarget.nodeName === 'DIV') {
      this.triggerTarget.firstElementChild.focus()
    } else {
      this.triggerTarget.focus()
    }
  }

  setAriaLabelledby() {
    this.groupTargets.forEach((g) => {
      const label = g.querySelector(
        '[data-shadcn-phlexcomponents--select-target="label"]',
      )

      if (label) {
        const ariaId = this.element.dataset.ariaId
        const labelledby = `${ariaId}-${label.textContent
          .toLowerCase()
          .trim()
          .replace(/ /, '-')}`
        label.setAttribute('id', labelledby)
        g.setAttribute('aria-labelledby', labelledby)
      }
    })
  }

  isOpen() {
    return this.triggerTarget.ariaExpanded === 'true'
  }

  focusItem(event = null, index = null) {
    let itemIndex = index

    if (event) {
      const item = event.currentTarget || event.target
      itemIndex = this.items.indexOf(item)
    }

    const item = this.items[itemIndex]
    item.tabIndex = 0
    item.focus()

    this.items.forEach((item, index) => {
      if (index !== itemIndex) {
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

  focusPrevItem(event) {
    const item = event.currentTarget || event.target
    const index = this.items.indexOf(item)

    if (index - 1 >= 0) {
      this.focusItem(null, index - 1)
    }
  }

  focusNextItem(event) {
    const item = event.currentTarget || event.target
    const index = this.items.indexOf(item)

    if (index + 1 < this.items.length) {
      this.focusItem(null, index + 1)
    }
  }

  selectItem(event) {
    const item = event.currentTarget || event.target
    const value = item.dataset.value
    this.selectedValue = value
    this.close()
  }

  focusContent() {
    this.items.forEach((item) => {
      item.blur()
    })

    this.contentTarget.focus()
  }

  selectedValueChanged(value) {
    const item = this.itemTargets.find((i) => i.dataset.value === value)

    if (item) {
      this.triggerTextTarget.textContent = item.textContent

      this.itemTargets.forEach((i) => {
        if (i.dataset.value === value) {
          i.setAttribute('aria-selected', 'true')
        } else {
          i.setAttribute('aria-selected', 'false')
        }
      })

      this.selectTarget.value = value
    }

    delete this.triggerTarget.dataset.placeholder
    const hasPlaceholder = this.triggerTarget.dataset.placeholderText

    if (hasPlaceholder) {
      if (!value || value.length === 0) {
        this.triggerTarget.dataset.placeholder = true
        this.triggerTextTarget.textContent = hasPlaceholder
      }
    }
  }

  handleSearchChange(search) {
    const item = this.items.find((i) =>
      i.textContent.toLowerCase().startsWith(search.toLowerCase()),
    )

    if (item) {
      item.focus()
    }
  }

  handleSearch(key) {
    const search = this.search + key
    this.search = search

    window.clearTimeout(this.searchTimer)
    window.clearTimeout(this.resetSearchTimer)

    if (search !== '') {
      this.searchTimer = window.setTimeout(() => {
        this.handleSearchChange(search)
      }, 150)

      this.resetSearchTimer = window.setTimeout(() => {
        this.search = ''
      }, 300)
    }
  }

  // Global listeners
  onDOMClick(event) {
    const htmlFor = event.target.htmlFor

    if (htmlFor === this.triggerTarget.id) return
    if (event.target) if (this.element.contains(event.target)) return

    this.close()
  }

  onDOMKeydown(event) {
    if (!this.isOpen()) return

    const key = event.key
    const isModifierKey = event.ctrlKey || event.altKey || event.metaKey

    if (key === 'Tab') event.preventDefault()

    if (!isModifierKey && key.length === 1) this.handleSearch(key)

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
    window.clearTimeout(this.searchTimer)
    window.clearTimeout(this.resetSearchTimer)
  }
}
