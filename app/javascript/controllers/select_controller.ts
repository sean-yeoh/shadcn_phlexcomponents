import { useClickOutside } from 'stimulus-use'
import { onKeydown, focusItemByIndex } from './dropdown_menu_controller'
import {
  getSameLevelItems,
  focusTrigger,
  initFloatingUi,
  hideContent,
  showContent,
  lockScroll,
  unlockScroll,
  onClickOutside,
  setGroupLabelsId,
  getNextEnabledIndex,
  getPreviousEnabledIndex,
  focusElement,
} from '../utils'
import { Controller } from '@hotwired/stimulus'

const SelectController = class extends Controller<HTMLElement> {
  // targets
  static targets = [
    'trigger',
    'contentContainer',
    'content',
    'item',
    'triggerText',
    'group',
    'select',
  ]
  declare readonly triggerTarget: HTMLElement
  declare readonly contentContainerTarget: HTMLElement
  declare readonly contentTarget: HTMLElement
  declare readonly itemTargets: HTMLElement[]
  declare triggerTextTarget: HTMLElement
  declare groupTargets: HTMLElement[]
  declare selectTarget: HTMLSelectElement

  // values
  static values = {
    isOpen: Boolean,
    selected: String,
  }
  declare isOpenValue: boolean
  declare selectedValue: string

  // custom properties
  declare searchString: string
  declare searchTimeout: number
  declare itemsInnerText: string[]
  declare items: HTMLElement[]
  declare DOMKeydownListener: (event: KeyboardEvent) => void
  declare cleanup: () => void

  connect() {
    this.items = getSameLevelItems({
      content: this.contentTarget,
      items: this.itemTargets,
      closestContentSelector: '[data-select-target="content"]',
    })
    this.itemsInnerText = this.items.map((i) => i.innerText.trim())
    this.searchString = ''
    useClickOutside(this, { element: this.contentTarget, dispatchEvent: false })
    this.DOMKeydownListener = this.onDOMKeydown.bind(this)
    setGroupLabelsId(this)
  }

  toggle(event: MouseEvent) {
    if (this.isOpenValue) {
      this.close()
    } else {
      this.open(event)
    }
  }

  open(event: MouseEvent | KeyboardEvent) {
    this.isOpenValue = true

    let elementToFocus = null as HTMLElement | null

    if (this.selectedValue) {
      const item = this.itemTargets.find(
        (i) => i.dataset.value === this.selectedValue,
      )

      if (item && !item.dataset.disabled) {
        elementToFocus = item
      }
    }

    if (!elementToFocus) {
      if (event instanceof KeyboardEvent) {
        const key = event.key

        if (['ArrowDown', 'Enter', ' '].includes(key)) {
          elementToFocus = this.items[0]
        }
      } else {
        elementToFocus = this.contentTarget
      }
    }

    focusElement(elementToFocus)
  }

  close() {
    this.isOpenValue = false
  }

  onItemFocus(event: FocusEvent) {
    const item = event.currentTarget as HTMLElement
    item.tabIndex = 0
  }

  onItemBlur(event: FocusEvent) {
    const item = event.currentTarget as HTMLElement
    item.tabIndex = -1
  }

  focusItemByIndex(
    event: KeyboardEvent | null = null,
    index: number | null = null,
  ) {
    focusItemByIndex(this, event, index)
  }

  focusItem(event: MouseEvent | KeyboardEvent) {
    const item = event.currentTarget as HTMLElement
    const index = this.items.indexOf(item)

    if (event instanceof KeyboardEvent) {
      const key = event.key
      let newIndex = 0

      if (key === 'ArrowUp') {
        newIndex = getPreviousEnabledIndex({
          items: this.items,
          currentIndex: index,
          wrapAround: false,
        })
      } else {
        newIndex = getNextEnabledIndex({
          items: this.items,
          currentIndex: index,
          wrapAround: false,
        })
      }

      this.items[newIndex].focus()
    } else {
      // item mouseover event
      this.items[index].focus()
    }
  }

  focusContent() {
    this.contentTarget.focus()
  }

  select(event: MouseEvent | KeyboardEvent) {
    const item = event.currentTarget as HTMLElement
    const value = item.dataset.value as string
    this.selectedValue = value
    this.close()
  }

  clickOutside(event: MouseEvent) {
    onClickOutside(this, event)
  }

  isOpenValueChanged(isOpen: boolean, previousIsOpen: boolean) {
    if (isOpen) {
      lockScroll(this.contentTarget.id)

      showContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
        setEqualWidth: true,
      })

      this.cleanup = initFloatingUi({
        referenceElement: this.triggerTarget,
        floatingElement: this.contentContainerTarget,
        side: this.contentTarget.dataset.side,
        align: this.contentTarget.dataset.align,
        sideOffset: 4,
      })

      this.setupEventListeners()
    } else {
      unlockScroll(this.contentTarget.id)

      hideContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
      })

      if (previousIsOpen) {
        focusTrigger(this.triggerTarget)
      }

      this.cleanupEventListeners()
    }
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

  disconnect() {
    this.cleanupEventListeners()
  }

  protected onDOMKeydown(event: KeyboardEvent) {
    if (!this.isOpenValue) return

    onKeydown(this, event)

    const { key, altKey, ctrlKey, metaKey } = event

    if (
      key === 'Backspace' ||
      key === 'Clear' ||
      (key.length === 1 && key !== ' ' && !altKey && !ctrlKey && !metaKey)
    ) {
      this.handleSearch(key)
    }
  }

  protected setupEventListeners() {
    document.addEventListener('keydown', this.DOMKeydownListener)
  }

  protected cleanupEventListeners() {
    if (this.cleanup) this.cleanup()
    document.removeEventListener('keydown', this.DOMKeydownListener)
  }

  // https://www.w3.org/WAI/ARIA/apg/patterns/combobox/examples/combobox-select-only/
  protected handleSearch(char: string) {
    const searchString = this.getSearchString(char)
    const focusedItem = this.items.find(
      (item) => document.activeElement === item,
    )
    const focusedIndex = focusedItem ? this.items.indexOf(focusedItem) : 0
    const searchIndex = this.getIndexByLetter(searchString, focusedIndex + 1)

    // if a match was found, go to it
    if (searchIndex >= 0) {
      this.focusItemByIndex(null, searchIndex)
    }
    // if no matches, clear the timeout and search string
    else {
      window.clearTimeout(this.searchTimeout)
      this.searchString = ''
    }
  }

  protected filterItemsInnerText(items: string[], filter: string) {
    return items.filter((item) => {
      const matches = item.toLowerCase().indexOf(filter.toLowerCase()) === 0
      return matches
    })
  }

  protected getSearchString(char: string) {
    // reset typing timeout and start new timeout
    // this allows us to make multiple-letter matches, like a native select
    if (typeof this.searchTimeout === 'number') {
      window.clearTimeout(this.searchTimeout)
    }

    this.searchTimeout = window.setTimeout(() => {
      this.searchString = ''
    }, 500)

    // add most recent letter to saved search string
    this.searchString += char
    return this.searchString
  }

  // return the index of an option from an array of options, based on a search string
  // if the filter is multiple iterations of the same letter (e.g "aaa"), then cycle through first-letter matches
  protected getIndexByLetter(filter: string, startIndex: number) {
    const orderedItems = [
      ...this.itemsInnerText.slice(startIndex),
      ...this.itemsInnerText.slice(0, startIndex),
    ]

    const firstMatch = this.filterItemsInnerText(orderedItems, filter)[0]

    const allSameLetter = (array: string[]) =>
      array.every((letter) => letter === array[0])

    // first check if there is an exact match for the typed string
    if (firstMatch) {
      const index = this.itemsInnerText.indexOf(firstMatch)
      return index
    }

    // if the same letter is being repeated, cycle through first-letter matches
    else if (allSameLetter(filter.split(''))) {
      const matches = this.filterItemsInnerText(orderedItems, filter[0])
      const index = this.itemsInnerText.indexOf(matches[0])
      return index
    }

    // if no matches, return -1
    else {
      return -1
    }
  }
}

type Select = InstanceType<typeof SelectController>

export { SelectController }
export type { Select }
