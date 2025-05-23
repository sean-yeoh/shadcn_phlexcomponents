import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['trigger', 'content']
  static values = {
    selected: String,
  }

  declare readonly triggerTargets: HTMLButtonElement[]
  declare readonly contentTargets: HTMLElement[]
  declare triggers: HTMLElement[]
  declare selectedValue: string | undefined

  connect() {
    this.triggers = this.triggerTargets.filter((t) => !t.disabled)

    if (!this.selectedValue) {
      this.selectedValue = this.triggerTargets[0].dataset.value
    }
  }

  setActiveTab(event: MouseEvent) {
    const target = (event.currentTarget || event.target) as HTMLElement

    if (target) this.selectedValue = target.dataset.value
  }

  setActiveToPrev(event: KeyboardEvent) {
    const trigger = (event.currentTarget || event.target) as HTMLElement
    const index = this.triggers.indexOf(trigger)
    let prevIndex = index - 1

    if (index === 0) {
      prevIndex = this.triggers.length - 1
    }

    this.selectedValue = this.triggers[prevIndex].dataset.value
    this.triggers[prevIndex].focus()
  }

  setActiveToNext(event: KeyboardEvent) {
    const trigger = (event.currentTarget || event.target) as HTMLElement
    const index = this.triggers.indexOf(trigger)
    let nextIndex = index + 1

    if (index === this.triggers.length - 1) {
      nextIndex = 0
    }

    this.selectedValue = this.triggers[nextIndex].dataset.value
    this.triggers[nextIndex].focus()
  }

  selectedValueChanged(value: string) {
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
