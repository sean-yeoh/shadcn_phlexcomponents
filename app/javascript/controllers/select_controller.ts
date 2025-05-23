import { Controller } from '@hotwired/stimulus'
import {
  ANIMATION_OUT_DELAY,
  FOCUS_DELAY,
  lockScroll,
  unlockScroll,
  initFloatingUi,
  focusTrigger,
} from '../utils'

export default class extends Controller<HTMLElement> {
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

  declare readonly triggerTarget: HTMLElement
  declare readonly contentWrapperTarget: HTMLElement
  declare readonly contentTarget: HTMLElement
  declare readonly itemTargets: HTMLElement[]
  declare readonly triggerTextTarget: HTMLElement
  declare readonly groupTargets: HTMLElement[]
  declare readonly labelTargets: HTMLElement[]
  declare readonly selectTarget: HTMLSelectElement
  declare selectedValue: string
  declare DOMClickListener: (event: MouseEvent) => void
  declare DOMKeydownListener: (event: KeyboardEvent) => void
  declare items: HTMLElement[]
  declare search: string
  declare searchTimer: number | null
  declare resetSearchTimer: number | null
  declare cleanup: () => void

  connect() {
    this.DOMClickListener = this.onDOMClick.bind(this)
    this.DOMKeydownListener = this.onDOMKeydown.bind(this)

    this.setAriaLabelledby()

    this.items = Array.from(
      this.element.querySelectorAll(
        '[data-select-target="item"]:not([data-disabled])',
      ),
    )

    this.search = ''
    this.searchTimer = null
    this.resetSearchTimer = null
  }

  toggle() {
    if (this.isOpen()) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    lockScroll()
    const triggerWidth = this.triggerTarget.offsetWidth
    this.contentWrapperTarget.classList.remove('hidden')

    const contentWrapperWidth = this.contentWrapperTarget.offsetWidth

    if (contentWrapperWidth < triggerWidth) {
      this.contentWrapperTarget.style.width = `${triggerWidth}px`
    }

    this.triggerTarget.ariaExpanded = 'true'
    this.contentTarget.dataset.state = 'open'

    setTimeout(() => {
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
    }, FOCUS_DELAY * 1.25)

    this.setupEventListeners()
    this.cleanup = initFloatingUi(
      this.triggerTarget,
      this.contentWrapperTarget,
      'bottom',
    )
  }

  close() {
    unlockScroll()
    this.contentTarget.dataset.state = 'closed'
    this.triggerTarget.ariaExpanded = 'false'
    this.cleanup()
    this.cleanupEventListeners()

    setTimeout(() => {
      this.contentWrapperTarget.classList.add('hidden')
    }, ANIMATION_OUT_DELAY)

    focusTrigger(this.triggerTarget)
  }

  setAriaLabelledby() {
    this.groupTargets.forEach((g) => {
      const label = g.querySelector(
        '[data-select-target="label"]',
      ) as HTMLElement

      if (label.textContent) {
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

  focusItem(event: MouseEvent | null = null, index: number | null = null) {
    let itemIndex = index

    if (event) {
      const item = (event.currentTarget || event.target) as HTMLElement
      itemIndex = this.items.indexOf(item)
    }

    const item = this.items[itemIndex as number]
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

  focusPrevItem(event: KeyboardEvent) {
    const item = (event.currentTarget || event.target) as HTMLElement
    const index = this.items.indexOf(item)

    if (index - 1 >= 0) {
      this.focusItem(null, index - 1)
    }
  }

  focusNextItem(event: KeyboardEvent) {
    const item = (event.currentTarget || event.target) as HTMLElement
    const index = this.items.indexOf(item)

    if (index + 1 < this.items.length) {
      this.focusItem(null, index + 1)
    }
  }

  selectItem(event: MouseEvent | KeyboardEvent) {
    const item = (event.currentTarget || event.target) as HTMLElement
    const value = item.dataset.value as string
    this.selectedValue = value
    this.close()
  }

  focusContent() {
    this.items.forEach((item) => {
      item.blur()
    })

    this.contentTarget.focus()
  }

  selectedValueChanged(value: string) {
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

    this.triggerTarget.dataset.hasValue = `${!!value && value.length > 0}`

    const placeholder = this.triggerTarget.dataset.placeholder

    if (placeholder && this.triggerTarget.dataset.hasValue === 'false') {
      this.triggerTextTarget.textContent = placeholder
    }
  }

  handleSearchChange(search: string) {
    const item = this.items.find((i) =>
      i.innerText.toLowerCase().startsWith(search.toLowerCase()),
    )

    if (item) {
      item.focus()
    }
  }

  handleSearch(key: string) {
    const search = this.search + key
    this.search = search

    if (this.searchTimer) window.clearTimeout(this.searchTimer)

    if (this.resetSearchTimer) window.clearTimeout(this.resetSearchTimer)

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
  onDOMClick(event: MouseEvent) {
    if (!this.isOpen()) return
    if (this.element.contains(event.target as HTMLElement)) return

    this.close()
  }

  onDOMKeydown(event: KeyboardEvent) {
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
    if (this.searchTimer) window.clearTimeout(this.searchTimer)
    if (this.resetSearchTimer) window.clearTimeout(this.resetSearchTimer)
  }
}
