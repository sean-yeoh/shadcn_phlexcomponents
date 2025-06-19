import { Controller } from '@hotwired/stimulus'
import { useClickOutside, useDebounce } from 'stimulus-use'
import Fuse from 'fuse.js'
import { ON_OPEN_FOCUS_DELAY } from '../utils'

export default class extends Controller<HTMLElement> {
  static targets = [
    'trigger',
    'content',
    'item',
    'triggerText',
    'group',
    'label',
    'searchInput',
    'results',
    'empty',
    'list',
  ]

  static values = {
    isOpen: Boolean,
    filteredItemIndexes: Array,
  }

  static debounces = ['search']

  declare readonly emptyTarget: HTMLElement
  declare readonly triggerTarget: HTMLElement
  declare readonly listTarget: HTMLElement
  declare readonly groupTargets: HTMLElement[]
  declare readonly hasEmptyTarget: boolean
  declare readonly contentTarget: HTMLElement
  declare readonly searchInputTarget: HTMLInputElement
  declare readonly itemTargets: HTMLInputElement[]
  declare items: HTMLElement[]
  declare filteredItemIndexesValue: number[]
  declare itemsInnerText: string[]
  declare filteredItems: HTMLElement[]
  declare fuse: Fuse<string>
  declare isOpenValue: boolean
  declare resultsTarget: HTMLElement
  declare DOMKeydownListener: (event: KeyboardEvent) => void
  declare scrollingViaKeyboard: boolean
  declare keyboardScrollTimeout: number

  connect() {
    this.DOMKeydownListener = this.onDOMKeydown.bind(this)
    useClickOutside(this, { element: this.contentTarget })
    useDebounce(this)
    this.items = this.itemTargets.filter(
      (i) => i.dataset.disabled === undefined,
    )
    this.itemsInnerText = this.items.map((i) => i.innerText.trim())
    this.setAriaLabelledby()
    this.setItemsGroupIds()
    this.fuse = new Fuse(this.items.map((i) => i.innerText.trim()))
    this.filteredItemIndexesValue = Array.from(
      { length: this.items.length },
      (_, i) => i,
    )

    this.filteredItems = this.items
  }

  setItemsGroupIds() {
    this.items.forEach((item, index) => {
      const parent = item.parentElement

      if (parent?.dataset[`${this.identifier}Target`] === 'group') {
        item.dataset.groupId = parent.getAttribute('aria-labelledby') as string
      }
    })
  }

  setAriaLabelledby() {
    this.groupTargets.forEach((g) => {
      const label = g.querySelector(
        `[data-${this.identifier}-target="label"]`,
      ) as HTMLElement

      if (label) {
        label.id = g.getAttribute('aria-labelledby') as string
      }
    })
  }

  scrollToItem(index: number) {
    const item = this.filteredItems[index]
    const containerRect = this.contentTarget.getBoundingClientRect()
    const itemRect = item.getBoundingClientRect()
    const listRect = this.listTarget.getBoundingClientRect()
    let newScrollTop = null as number | null

    const maxScrollTop =
      this.listTarget.scrollHeight - this.listTarget.clientHeight

    // scroll to bottom
    if (itemRect.bottom - containerRect.bottom > 0) {
      if (index === this.filteredItems.length - 1) {
        newScrollTop = maxScrollTop
      } else {
        newScrollTop =
          this.listTarget.scrollTop + (itemRect.bottom - containerRect.bottom)
      }
    } else if (listRect.top - itemRect.top > 0) {
      // scroll to top
      if (index === 0) {
        newScrollTop = 0
      } else {
        newScrollTop = this.listTarget.scrollTop - (listRect.top - itemRect.top)
      }
    }

    if (newScrollTop !== null) {
      this.scrollingViaKeyboard = true

      if (newScrollTop >= 0 && newScrollTop <= maxScrollTop) {
        this.listTarget.scrollTop = newScrollTop
      }

      // Clear the flag after scroll settles
      clearTimeout(this.keyboardScrollTimeout)
      this.keyboardScrollTimeout = window.setTimeout(() => {
        this.scrollingViaKeyboard = false
      }, 200)
    }
  }

  highlightItem(
    event: MouseEvent | KeyboardEvent | null = null,
    index: number | null = null,
  ) {
    if (event !== null) {
      if (event instanceof KeyboardEvent) {
        const key = event.key
        const item = this.filteredItems.find(
          (i) => i.dataset.highlighted === 'true',
        )

        if (item) {
          const index = this.filteredItems.indexOf(item)

          let newIndex = 0
          if (key === 'ArrowUp') {
            newIndex = index - 1

            if (newIndex < 0) {
              newIndex = 0
            }
          } else {
            newIndex = index + 1

            if (newIndex > this.filteredItems.length - 1) {
              newIndex = this.filteredItems.length - 1
            }
          }

          this.highlightItemByIndex(newIndex)
          this.scrollToItem(newIndex)
        } else {
          if (key === 'ArrowUp') {
            this.highlightItemByIndex(this.filteredItems.length - 1)
          } else {
            this.highlightItemByIndex(0)
          }
        }
      } else {
        // mouse event
        if (this.scrollingViaKeyboard) {
          event.stopImmediatePropagation()
          return
        } else {
          const item = event.currentTarget as HTMLElement
          const index = this.filteredItems.indexOf(item)
          this.highlightItemByIndex(index)
        }
      }
    } else if (index !== null) {
      this.highlightItemByIndex(index)
    }
  }

  highlightItemByIndex(index: number) {
    this.filteredItems.forEach((item, i) => {
      if (i === index) {
        item.dataset.highlighted = 'true'
      } else {
        item.dataset.highlighted = 'false'
      }
    })
  }

  open() {
    this.isOpenValue = true
    this.highlightItemByIndex(0)

    setTimeout(() => {
      this.searchInputTarget.focus()
    }, ON_OPEN_FOCUS_DELAY)
  }

  close() {
    this.isOpenValue = false
    this.searchInputTarget.value = ''
    this.filteredItemIndexesValue = Array.from(
      { length: this.items.length },
      (_, i) => i,
    )
  }

  select(event: MouseEvent | KeyboardEvent) {
    if (!this.isOpenValue) return

    if (event instanceof KeyboardEvent) {
      const item = this.filteredItems.find(
        (i) => i.dataset.highlighted === 'true',
      )

      if (item) {
        this.onSelect(item.dataset.value as string)
        this.close()
      }
    } else {
      // mouse event
      const item = event.currentTarget as HTMLElement
      this.onSelect(item.dataset.value as string)
      this.close()
    }
  }

  onSelect(value: string) {}

  onDOMKeydown(event: KeyboardEvent) {
    if (!this.isOpenValue) return

    const key = event.key

    if (['Tab', 'Enter', ' '].includes(key)) event.preventDefault()

    if (key === 'Escape') {
      this.close()
    }
  }

  setupEventListeners() {
    document.addEventListener('keydown', this.DOMKeydownListener)
  }

  cleanupEventListeners() {
    document.removeEventListener('keydown', this.DOMKeydownListener)
  }

  disconnect() {
    this.cleanupEventListeners()
  }

  search(event: InputEvent) {
    const input = event.target as HTMLInputElement
    const value = input.value

    if (value.length > 0) {
      const results = this.fuse.search(value)

      this.filteredItemIndexesValue = results.map((result) => result.refIndex)
    } else {
      this.filteredItemIndexesValue = Array.from(
        { length: this.items.length },
        (_, i) => i,
      )
    }
  }

  filteredItemIndexesValueChanged(filteredItemIndexes: number[]) {
    if (this.items) {
      const filteredItems = filteredItemIndexes.map((i) => this.items[i])

      // 1. Toggle visibility of items
      this.items.forEach((item) => {
        if (filteredItems.includes(item)) {
          item.ariaHidden = 'false'
          item.classList.remove('hidden')
        } else {
          item.ariaHidden = 'true'
          item.classList.add('hidden')
        }
      })

      // 2. Get groups based on order of filtered items
      const groupIds = filteredItems.map((item) => item.dataset.groupId)
      const uniqueGroupIds = [...new Set(groupIds)].filter(
        (groupId) => !!groupId,
      )
      const orderedGroups = uniqueGroupIds.map((groupId) => {
        return this.resultsTarget.querySelector(
          `[aria-labelledby=${groupId}]`,
        ) as HTMLElement
      })

      // 3. Append items and groups based on filtered items
      const appendedGroupIds = [] as string[]

      filteredItems.forEach((item, index) => {
        const groupId = item.dataset.groupId

        if (groupId) {
          const group = orderedGroups.find(
            (g) => g.getAttribute('aria-labelledby') === groupId,
          )

          if (group) {
            group.appendChild(item)

            if (!appendedGroupIds.includes(groupId)) {
              this.resultsTarget.appendChild(group)
              appendedGroupIds.push(groupId)
            }
          }
        } else {
          this.resultsTarget.appendChild(item)
        }
      })

      // 4. Toggle visibility of groups
      this.groupTargets.forEach((group) => {
        const itemsCount = group.querySelectorAll(
          `[data-${this.identifier}-target=item][aria-hidden=false]`,
        ).length
        if (itemsCount > 0) {
          group.classList.remove('hidden')
        } else {
          group.classList.add('hidden')
        }
      })

      // 5. Assign filteredItems based on the order it is displayed in the DOM
      this.filteredItems = Array.from(
        this.resultsTarget.querySelectorAll(
          `[data-${this.identifier}-target=item][aria-hidden=false]`,
        ),
      )

      // 6. Highlight first item
      this.highlightItemByIndex(0)

      // 7. Toggle visibility of empty
      if (this.hasEmptyTarget) {
        if (this.filteredItems.length > 0) {
          this.emptyTarget.classList.add('hidden')
        } else {
          this.emptyTarget.classList.remove('hidden')
        }
      }
    }
  }
}
