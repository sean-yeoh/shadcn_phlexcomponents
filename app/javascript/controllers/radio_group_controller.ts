import { Controller } from '@hotwired/stimulus'

export default class extends Controller<HTMLElement> {
  static targets = ['item']
  static values = {
    selected: String,
  }

  declare readonly itemTargets: HTMLInputElement[]
  declare selectedValue: string
  declare items: HTMLInputElement[]

  declare DOMClickListener: (event: MouseEvent) => void
  declare DOMKeydownListener: (event: KeyboardEvent) => void
  declare focusableElements: HTMLElement[]
  declare firstElement: HTMLElement
  declare lastElement: HTMLElement
  declare cleanup: () => void

  connect() {
    if (!this.selectedValue) {
      this.itemTargets[0].tabIndex = 0
    }

    this.items = this.itemTargets.filter((i) => !i.disabled)
  }

  setChecked(event: MouseEvent) {
    const item = event.currentTarget as HTMLInputElement
    this.selectedValue = item.dataset.value as string
  }

  preventDefault(event: KeyboardEvent) {
    event.preventDefault()
  }

  setCheckedToNext(event: KeyboardEvent) {
    const item = event.currentTarget as HTMLInputElement
    const index = this.items.indexOf(item)
    let nextIndex = index + 1

    if (index === this.items.length - 1) {
      nextIndex = 0
    }

    this.selectedValue = this.items[nextIndex].dataset.value as string
  }

  setCheckedToPrev(event: KeyboardEvent) {
    const item = event.currentTarget as HTMLInputElement
    const index = this.items.indexOf(item)
    let prevIndex = index - 1

    if (index === 0) {
      prevIndex = this.items.length - 1
    }

    this.selectedValue = this.items[prevIndex].dataset.value as string
  }

  focusItem() {
    const item = this.itemTargets.find(
      (i) => i.dataset.value === this.selectedValue,
    )

    if (!item) return

    // Focus first item that is not disabled and allow it to be focused
    if (item.disabled) {
      item.tabIndex = -1
      const items = this.items || this.itemTargets.filter((i) => !i.disabled)

      if (items.length > 0) {
        items[0].focus()
        items[0].tabIndex = 0
      }
    } else {
      item.focus()
    }
  }

  selectedValueChanged(value: string) {
    this.itemTargets.forEach((item) => {
      const input = item.querySelector('[data-input]') as HTMLInputElement

      if (value === item.dataset.value) {
        input.checked = true
        item.tabIndex = 0
        item.ariaChecked = 'true'
        item.dataset.checked = 'true'
      } else {
        input.checked = false
        item.tabIndex = -1
        item.ariaChecked = 'false'
        item.dataset.checked = 'false'
      }
    })

    this.focusItem()
  }
}
