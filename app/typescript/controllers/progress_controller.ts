import { Controller } from '@hotwired/stimulus'

const Progress = class extends Controller {
  static name = 'progress'

  // targets
  static targets = ['indicator']
  declare readonly indicatorTarget: HTMLElement

  // values
  static values = {
    percent: Number,
  }
  declare percentValue: number

  percentValueChanged(value: number) {
    this.element.setAttribute('aria-valuenow', `${value}`)
    this.indicatorTarget.style.transform = `translateX(-${100 - value}%)`
  }
}

export default Progress
