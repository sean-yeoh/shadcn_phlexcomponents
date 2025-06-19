import { Controller } from '@hotwired/stimulus'
import { hideContent, showContent } from '@shadcn_phlexcomponents/utils'

export default class extends Controller {
  static targets = ['trigger', 'content']
  static values = {
    isOpen: Boolean,
  }

  declare readonly triggerTarget: HTMLElement
  declare readonly contentTarget: HTMLElement
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
