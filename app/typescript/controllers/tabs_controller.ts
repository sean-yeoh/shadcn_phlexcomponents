import { Controller } from '@hotwired/stimulus'
import { getNextEnabledIndex, getPreviousEnabledIndex } from '../utils'

const TabsController = class extends Controller {
  static name = 'tabs'

  // targets
  static targets = ['trigger', 'content']
  declare readonly triggerTargets: HTMLButtonElement[]
  declare readonly contentTargets: HTMLElement[]

  // values
  static values = {
    active: String,
  }
  declare activeValue: string

  connect() {
    if (!this.activeValue) {
      this.activeValue = this.triggerTargets[0].dataset.value as string
    }
  }

  setActiveTab(event: MouseEvent | KeyboardEvent) {
    const target = event.currentTarget as HTMLButtonElement

    if (event instanceof MouseEvent) {
      this.activeValue = target.dataset.value as string
    } else {
      const key = event.key

      const focusableTriggers = this.triggerTargets.filter(
        (t) => !t.disabled,
      ) as HTMLButtonElement[]

      const index = focusableTriggers.indexOf(target)
      let newIndex = 0

      if (key === 'ArrowLeft') {
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

      this.activeValue = focusableTriggers[newIndex].dataset.value as string
      focusableTriggers[newIndex].focus()
    }
  }

  activeValueChanged(value: string) {
    this.triggerTargets.forEach((trigger) => {
      const triggerValue = trigger.dataset.value
      const content = this.contentTargets.find((c) => {
        return c.dataset.value === triggerValue
      })

      if (!content) {
        throw new Error(
          `Could not find TabsContent with value "${triggerValue}"`,
        )
      }

      if (triggerValue === value) {
        trigger.ariaSelected = 'true'
        trigger.tabIndex = 0
        trigger.dataset.state = 'active'
        content.classList.remove('hidden')
      } else {
        trigger.ariaSelected = 'false'
        trigger.tabIndex = -1
        trigger.dataset.state = 'inactive'
        content.classList.add('hidden')
      }
    })
  }
}

type Tabs = InstanceType<typeof TabsController>

export { TabsController }
export type { Tabs }
