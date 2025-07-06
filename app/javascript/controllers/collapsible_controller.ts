import { Controller } from '@hotwired/stimulus'
import { hideContent, showContent } from '../utils'

const CollapsibleController = class extends Controller {
  // targets
  static targets = ['trigger', 'content']
  declare readonly triggerTarget: HTMLElement
  declare readonly contentTarget: HTMLElement

  // values
  static values = {
    isOpen: Boolean,
  }
  declare isOpenValue: boolean

  toggle() {
    if (this.isOpenValue) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.isOpenValue = true
  }

  close() {
    this.isOpenValue = false
  }

  isOpenValueChanged(isOpen: boolean) {
    if (isOpen) {
      showContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentTarget,
      })
    } else {
      hideContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentTarget,
      })
    }
  }
}

type Collapsible = InstanceType<typeof CollapsibleController>

export { CollapsibleController }
export type { Collapsible }
