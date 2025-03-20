import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['image', 'fallback']

  connect() {
    if (!this.isLoaded()) {
      if (this.hasFallbackTarget) {
        this.fallbackTarget.classList.remove('hidden')
      }

      if (this.hasImageTarget) {
        this.imageTarget.classList.add('hidden')
      }
    }
  }

  isLoaded() {
    if (!this.hasImageTarget) return false

    return this.imageTarget.complete
  }
}
