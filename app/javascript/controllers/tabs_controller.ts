import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['trigger', 'content']
  static values = {
    active: String,
  }

  declare readonly triggerTargets: HTMLButtonElement[]
  declare readonly contentTargets: HTMLElement[]
  declare activeValue: string | undefined

  connect() {
    if (!this.activeValue) {
      this.activeValue = this.triggerTargets[0].dataset.value
    }
  }

  setActiveTab(event: MouseEvent | KeyboardEvent) {
    const target = event.currentTarget as HTMLButtonElement

    if (event instanceof MouseEvent) {
      this.activeValue = target.dataset.value
    } else {
      const key = event.key

      const focusableTriggers = this.triggerTargets.filter(
        (t) => !t.disabled,
      ) as HTMLButtonElement[]

      const index = focusableTriggers.indexOf(target)
      let newIndex = 0

      if (key === 'ArrowLeft') {
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

      this.activeValue = focusableTriggers[newIndex].dataset.value
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
