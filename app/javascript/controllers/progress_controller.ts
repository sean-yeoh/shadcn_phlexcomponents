import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['bar']

  static values = {
    progress: Number,
  }

  declare readonly barTarget: HTMLElement
  declare progressValue: number

  progressValueChanged(value: number) {
    this.element.setAttribute('aria-valuenow', `${value}`)
    this.barTarget.style.transform = `translateX(-${100 - value}%)`
  }
}
