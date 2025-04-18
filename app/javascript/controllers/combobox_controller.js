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
    'itemCheckIcon',
    'select',
    'searchInput',
  ]

  static values = {
    selected: String,
  }

  connect() {
    this.contentTarget.dataset.state = this.isOpen() ? 'open' : 'closed'
    this.clickOutsideListener = this.onClickOutside.bind(this)
    this.comboboxKeydownListener = this.onComboboxKeydown.bind(this)
    this.searchInputKeydownListener = this.debounce(
      this.onSearchInputKeydown.bind(this),
      100,
    )

    this.items = [
      ...this.element.querySelectorAll(
        '[data-shadcn-phlexcomponents--combobox-target="item"]:not([data-disabled])',
      ),
    ]
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

    this.searchInputTarget.focus()

    if (this.selectedValue) {
      const item = this.itemTargets.find(
        (i) => i.dataset.value === this.selectedValue,
      )
      const index = this.items.indexOf(item)
      if (index > -1) {
        this.highlightItem(index)
      }
    } else {
      this.highlightItem(0)
    }

    this.triggerTarget.ariaExpanded = true
    this.contentTarget.dataset.state = 'open'

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

  isOpen() {
    return this.triggerTarget.ariaExpanded === 'true'
  }

  highlightItem(selectedIndex) {
    const item = this.items[selectedIndex]
    console.log('this.highlightItem', item)
    item.dataset.selected = true

    this.items.forEach((item, index) => {
      if (index !== selectedIndex) item.dataset.selected = false
    })
  }

  currentHighlightedIndex() {
    console.log('item')
    const item = this.items.find((i) => i.dataset.selected === 'true')
    return this.items.indexOf(item)
    console.log('item', item)

    // if (item) {
    //   return this.items.indexOf(item)
    // }

    // return 0
  }

  debounce(callback, wait) {
    let timeoutId = null
    return (...args) => {
      window.clearTimeout(timeoutId)
      timeoutId = window.setTimeout(() => {
        callback.apply(null, args)
      }, wait)
    }
  }

  onSearchInputKeydown(event) {
    // console.log('search ecet', event)
    this.filterItems()
  }

  onArrowUpKeydown(event) {
    const index = this.currentHighlightedIndex()
    console.log('onArrowUpKeydown index', index)

    if (index > 0) {
      this.highlightItem(index - 1)
    }

    event.preventDefault()
  }

  onArrowDownKeydown(event) {
    const index = this.currentHighlightedIndex()

    console.log('onArrowDownKeydown index', index)

    console.log('index + 1 < this.items.length', index + 1 < this.items.length)
    if (index + 1 < this.items.length) {
      this.highlightItem(index + 1)
    }

    event.preventDefault()
  }

  selectItem(event) {
    const index = this.currentHighlightedIndex()
    const item = this.items[index]
    item.click()
    event.preventDefault()
  }

  filterItems = () => {
    const search = this.searchInputTarget.value
    const filteredItems = this.items.filter((i) =>
      i.innerText.toLowerCase().includes(search),
    )

    this.items.forEach((i) => {
      if (filteredItems.includes(i)) {
        i.classList.remove('hidden')
      } else {
        i.classList.add('hidden')
      }
    })

    this.highlightItem(this.filterItems[0])
  }

  onItemClick(event) {
    const item = event.currentTarget
    const value = item.dataset.value
    this.selectedValue = value
    this.close()
  }

  onMouseOver(event) {
    const item = event.currentTarget
    const index = this.items.indexOf(item)
    this.highlightItem(index)
  }

  selectedValueChanged(value) {
    const item = this.itemTargets.find((i) => i.dataset.value === value)

    this.itemCheckIconTargets.forEach((i) => {
      i.classList.add('hidden')
    })

    if (item) {
      this.triggerTextTarget.innerText = item.innerText

      const checkIcon = item.querySelector(
        '[data-shadcn-phlexcomponents--combobox-target="itemCheckIcon"]',
      )
      if (value.length > 0) checkIcon.classList.remove('hidden')

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
        this.triggerTextTarget.innerText = hasPlaceholder
      }
    }
  }

  // Global listeners
  onClickOutside(event) {
    const htmlFor = event.target.htmlFor

    if (htmlFor === this.triggerTarget.id) return
    if (event.target) if (this.element.contains(event.target)) return

    this.close()
  }

  onComboboxKeydown(event) {
    if (!this.isOpen()) return

    const key = event.key
    if (key === 'Tab') event.preventDefault()

    if (key === 'Escape') {
      this.close()
    }
  }

  setupEventListeners() {
    document.addEventListener('click', this.clickOutsideListener)
    document.addEventListener('keydown', this.comboboxKeydownListener)
    document.addEventListener('keydown', this.searchInputKeydownListener)
  }

  cleanupEventListeners() {
    document.removeEventListener('click', this.clickOutsideListener)
    document.removeEventListener('keydown', this.comboboxKeydownListener)
    document.removeEventListener('keydown', this.searchInputKeydownListener)
  }
}
