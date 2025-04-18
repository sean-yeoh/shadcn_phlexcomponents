import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['image', 'fallback']

  connect() {
    this.imageTarget.onerror = () => {
      if (this.hasFallbackTarget) {
        this.fallbackTarget.classList.remove('hidden')
      }

      this.imageTarget.classList.add('hidden')
    }
  }
}
