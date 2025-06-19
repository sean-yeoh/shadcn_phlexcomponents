import DropdownMenuRootController from './dropdown_menu_root_controller'

export default class extends DropdownMenuRootController {
  static targets = [
    'trigger',
    'contentContainer',
    'content',
    'item',
    'triggerText',
    'group',
    'label',
    'select',
  ]

  static values = {
    isOpen: Boolean,
    selected: String,
    setEqualWidth: { type: Boolean, default: true },
    closestContentSelector: {
      type: String,
      default: '[data-select-target="content"]',
    },
  }

  declare selectedValue: string
  declare searchString: string
  declare searchTimeout: number
  declare groupTargets: HTMLElement[]
  declare triggerTextTarget: HTMLElement
  declare selectTarget: HTMLSelectElement
  declare itemsInnerText: string[]

  connect() {
    super.connect()
    this.itemsInnerText = this.items.map((i) => i.innerText.trim())
    this.setAriaLabelledby()
    this.searchString = ''
  }

  setAriaLabelledby() {
    this.groupTargets.forEach((g) => {
      const label = g.querySelector(
        '[data-select-target="label"]',
      ) as HTMLElement

      if (label) {
        label.id = g.getAttribute('aria-labelledby') as string
      }
    })
  }

  onOpenFocusedElement(event: MouseEvent | KeyboardEvent) {
    let itemIndex = null as number | null

    if (this.selectedValue) {
      const item = this.itemTargets.find(
        (i) => i.dataset.value === this.selectedValue,
      )

      if (item && !item.dataset.disabled) {
        itemIndex = this.items.indexOf(item)
      }
    } else {
      if (event instanceof KeyboardEvent) {
        const key = event.key

        if (['ArrowDown', 'Enter', ' '].includes(key)) {
          itemIndex = 0
        }
      }
    }

    if (itemIndex !== null) {
      return this.items[itemIndex]
    } else {
      return this.contentTarget
    }
  }

  onSelect(event: MouseEvent | KeyboardEvent) {
    const item = event.currentTarget as HTMLElement
    const value = item.dataset.value as string
    this.selectedValue = value
  }

  onDOMKeydown(event: KeyboardEvent) {
    super.onDOMKeydown(event)

    const { key, altKey, ctrlKey, metaKey } = event

    if (
      key === 'Backspace' ||
      key === 'Clear' ||
      (key.length === 1 && key !== ' ' && !altKey && !ctrlKey && !metaKey)
    ) {
      this.handleSearch(key)
    }
  }

  // https://www.w3.org/WAI/ARIA/apg/patterns/combobox/examples/combobox-select-only/
  handleSearch(char: string) {
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

  filterItemsInnerText(items: string[], filter: string) {
    return items.filter((item) => {
      const matches = item.toLowerCase().indexOf(filter.toLowerCase()) === 0
      return matches
    })
  }

  getSearchString(char: string) {
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
  getIndexByLetter(filter: string, startIndex: number) {
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
}
