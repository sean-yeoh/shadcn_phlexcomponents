import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['indicator']

  static values = {
    percent: Number,
  }

  declare readonly indicatorTarget: HTMLElement
  declare percentValue: number

  percentValueChanged(value: number) {
    this.element.setAttribute('aria-valuenow', `${value}`)
    this.indicatorTarget.style.transform = `translateX(-${100 - value}%)`
  }
}
