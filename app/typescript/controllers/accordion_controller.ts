import { Controller } from '@hotwired/stimulus'
import {
  showContent,
  hideContent,
  getNextEnabledIndex,
  getPreviousEnabledIndex,
} from '../utils'

const AccordionController = class extends Controller<HTMLElement> {
  static name = 'accordion'

  // targets
  static targets = ['item', 'trigger', 'content']
  declare itemTargets: HTMLElement[]
  declare triggerTargets: HTMLButtonElement[]
  declare contentTargets: HTMLElement[]

  // values
  static values = { openItems: Array }
  declare openItemsValue: string[]

  // custom properties
  declare multiple: boolean

  connect() {
    this.multiple = this.element.dataset.multiple === 'true'
  }

  contentTargetConnected(content: HTMLElement) {
    setTimeout(() => {
      this.setContentHeight(content)
    }, 100)
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
    const key = event.key

    const focusableTriggers = this.triggerTargets.filter(
      (trigger) => !trigger.disabled,
    )

    const index = focusableTriggers.indexOf(trigger)
    let newIndex = 0

    if (key === 'ArrowUp') {
      newIndex = getPreviousEnabledIndex({
        items: focusableTriggers,
        currentIndex: index,
        wrapAround: true,
      })
    } else {
      newIndex = getNextEnabledIndex({
        items: focusableTriggers,
        currentIndex: index,
        wrapAround: true,
      })
    }

    focusableTriggers[newIndex].focus()
  }

  openItemsValueChanged(openItems: string[]) {
    this.itemTargets.forEach((item) => {
      const itemValue = item.dataset.value as string

      const trigger = this.triggerTargets.find((trigger) =>
        item.contains(trigger),
      ) as HTMLElement
      const content = this.contentTargets.find((content) =>
        item.contains(content),
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

  protected setContentHeight(element: HTMLElement) {
    const height =
      this.getContentHeight(element) || element.getBoundingClientRect().height
    element.style.setProperty('--radix-accordion-content-height', `${height}px`)
  }

  getContentHeight(el: HTMLElement) {
    const clone = el.cloneNode(true) as HTMLElement
    Object.assign(clone.style, {
      display: 'block',
      position: 'absolute',
      visibility: 'hidden',
    })

    document.body.appendChild(clone)
    const height = clone.getBoundingClientRect().height
    document.body.removeChild(clone)

    return height
  }
}

type Accordion = InstanceType<typeof AccordionController>

export { AccordionController }
export type { Accordion }
