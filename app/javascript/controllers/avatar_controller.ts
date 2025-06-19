import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['image', 'fallback']

  declare readonly imageTarget: HTMLElement
  declare readonly fallbackTarget: HTMLElement
  declare readonly hasFallbackTarget: boolean

  connect() {
    this.imageTarget.onerror = () => {
      if (this.hasFallbackTarget) {
        this.fallbackTarget.classList.remove('hidden')
      }

      this.imageTarget.classList.add('hidden')
    }
  }
}
