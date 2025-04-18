import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['item']
  static values = {
    selected: String,
  }

  connect() {
    if (!this.selectedValue) {
      this.itemTargets[0].tabIndex = 0
    }

    this.items = this.itemTargets.filter((i) => !i.disabled)
  }

  setChecked(event) {
    const item = event.currentTarget
    this.selectedValue = item.dataset.value
  }

  preventDefault(event) {
    event.preventDefault()
  }

  setCheckedToNext(event) {
    const item = event.currentTarget
    const index = this.items.indexOf(item)
    let nextIndex = index + 1

    if (index === this.items.length - 1) {
      nextIndex = 0
    }

    this.selectedValue = this.items[nextIndex].dataset.value
  }

  setCheckedToPrev(event) {
    const item = event.currentTarget
    const index = this.items.indexOf(item)
    let prevIndex = index - 1

    if (index === 0) {
      prevIndex = this.items.length - 1
    }

    this.selectedValue = this.items[prevIndex].dataset.value
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

  selectedValueChanged(value) {
    this.itemTargets.forEach((item) => {
      const input = item.querySelector('[data-input]')

      if (value === item.dataset.value) {
        input.checked = true
        item.tabIndex = 0
        item.ariaChecked = true
        item.dataset.checked = true
      } else {
        input.checked = false
        item.tabIndex = -1
        item.ariaChecked = false
        item.dataset.checked = false
      }
    })

    this.focusItem()
  }
}
