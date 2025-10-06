import { Controller } from '@hotwired/stimulus'

const LoadingButton = class extends Controller<HTMLButtonElement> {
  static name = 'loading-button'

  connect() {
    const el = this.element
    const form = el.closest('form')

    if (form && form.dataset.turbo === 'false') {
      form.addEventListener('submit', () => {
        form.ariaBusy = 'true'
        el.disabled = true
      })
    }
  }
}

export default LoadingButton
