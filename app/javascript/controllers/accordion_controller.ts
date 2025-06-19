import { Controller } from '@hotwired/stimulus'
import { showContent, hideContent } from '../utils'

export default class extends Controller<HTMLElement> {
  static targets = ['item']
  static values = { openItems: Array }
  declare itemTargets: HTMLElement[]
  declare multiple: boolean
  declare openItemsValue: string[]

  connect() {
    this.multiple = this.element.dataset.multiple === 'true'

    setTimeout(() => {
      this.itemTargets.forEach((item) => {
        const content = item.querySelector(
          '[data-shadcn-phlexcomponents="accordion-content-container"]',
        ) as HTMLElement
        this.setContentHeight(content)
      })
    }, 250)
  }

  setContentHeight(element: HTMLElement) {
    const height = this.getContentHeight(element)
    element.style.setProperty('--radix-accordion-content-height', `${height}px`)
  }

  getContentHeight(element: HTMLElement) {
    // Store the original styles we need to modify
    const originalStyles = {
      display: element.style.display,
      visibility: element.style.visibility,
      position: element.style.position,
    }

    // Make the element visible but not displayed
    element.style.display = 'block' // or whatever is appropriate (flex, inline, etc.)
    element.style.visibility = 'hidden'
    element.style.position = 'absolute'

    // Get the height
    const height = element.offsetHeight

    // Restore the original styles
    element.style.display = originalStyles.display
    element.style.visibility = originalStyles.visibility
    element.style.position = originalStyles.position

    return height
  }

  toggle(event: MouseEvent) {
    const trigger = event.currentTarget as HTMLElement

    const item = this.itemTargets.find((item) => {
      return item.contains(trigger)
    })

    if (!item) return

    const value = item.dataset.value as string
    const isOpen = this.openItemsValue.includes(value)

    if (isOpen) {
      this.openItemsValue = this.openItemsValue.filter((v) => v !== value)
    } else {
      if (this.multiple) {
        this.openItemsValue = [...this.openItemsValue, value]
      } else {
        this.openItemsValue = [value]
      }
    }
  }

  focusTrigger(event: KeyboardEvent) {
    const trigger = event.currentTarget as HTMLButtonElement
    const key = event.key as 'ArrowUp' | 'ArrowDown'

    let focusableTriggers = this.itemTargets.map((item) => {
      return item.querySelector(
        '[data-shadcn-phlexcomponents="accordion-trigger"]',
      )
    }) as HTMLButtonElement[]

    focusableTriggers = focusableTriggers.filter((trigger) => !trigger.disabled)
    const index = focusableTriggers.indexOf(trigger)
    let newIndex = 0

    if (key === 'ArrowUp') {
      newIndex = index - 1

      if (newIndex < 0) {
        newIndex = focusableTriggers.length - 1
      }
    } else {
      newIndex = index + 1

      if (newIndex > focusableTriggers.length - 1) {
        newIndex = 0
      }
    }

    focusableTriggers[newIndex].focus()
  }

  openItemsValueChanged(openItems: string[]) {
    this.itemTargets.forEach((item) => {
      const itemValue = item.dataset.value as string

      const trigger = item.querySelector(
        '[data-shadcn-phlexcomponents="accordion-trigger"]',
      ) as HTMLElement
      const content = item.querySelector(
        '[data-shadcn-phlexcomponents="accordion-content-container"]',
      ) as HTMLElement

      if (openItems.includes(itemValue)) {
        showContent({
          trigger,
          content: content,
          contentContainer: content,
        })
      } else {
        hideContent({
          trigger,
          content: content,
          contentContainer: content,
        })
      }
    })
  }
}
