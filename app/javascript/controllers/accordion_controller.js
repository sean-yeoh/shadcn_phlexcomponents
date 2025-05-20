import { Controller } from '@hotwired/stimulus'
import { ANIMATION_OUT_DELAY } from '../utils'

export default class extends Controller {
  static targets = ['trigger', 'content', 'item']

  connect() {
    this.triggers = this.triggerTargets.filter((t) => !t.disabled)
    this.multiple = this.element.dataset.multiple === 'true'
    const value = JSON.parse(this.element.dataset.value)

    this.itemTargets.forEach((i) => {
      if (value.includes(i.dataset.value)) {
        this.openItem(i)
      } else {
        this.closeItem(i)
      }
    })

    setTimeout(() => {
      this.contentTargets.forEach((c) => {
        this.setContentHeight(c)
      })
    }, 200)
  }

  setContentHeight(element) {
    const height = this.getContentHeight(element)
    element.style.setProperty('--accordion-content-height', `${height}px`)
  }

  getContentHeight(element) {
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

  toggleItem(event) {
    const trigger = event.currentTarget || event.target

    const item = trigger.closest('[data-accordion-target="item"]')

    if (item.dataset.state === 'open') {
      this.closeItem(item)
    } else {
      this.openItem(item)
    }

    if (!this.multiple) {
      this.itemTargets.forEach((i) => {
        if (i !== item) {
          this.closeItem(i)
        }
      })
    }
  }

  openItem(item) {
    const button = item.querySelector('[data-accordion-target="trigger"]')
    const content = item.querySelector('[data-accordion-target="content"]')

    item.dataset.state = 'open'
    button.ariaExpanded = true
    button.dataset.state = 'open'
    content.dataset.state = 'open'
    content.classList.remove('hidden')
  }

  closeItem(item) {
    const button = item.querySelector('[data-accordion-target="trigger"]')
    const content = item.querySelector('[data-accordion-target="content"]')

    item.dataset.state = 'closed'
    button.ariaExpanded = false
    button.dataset.state = 'closed'
    content.dataset.state = 'closed'

    setTimeout(() => {
      content.classList.add('hidden')
    }, ANIMATION_OUT_DELAY)
  }

  focusNext(event) {
    const trigger = event.currentTarget || event.target
    const index = this.triggers.indexOf(trigger)
    let nextIndex = index + 1

    if (index === this.triggers.length - 1) {
      nextIndex = 0
    }

    this.triggers[nextIndex].focus()
  }

  focusPrev(event) {
    const trigger = event.currentTarget || event.target
    const index = this.triggers.indexOf(trigger)
    let prevIndex = index - 1

    if (index === 0) {
      prevIndex = this.triggers.length - 1
    }

    this.triggers[prevIndex].focus()
  }
}
