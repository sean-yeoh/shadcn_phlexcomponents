import { Controller } from '@hotwired/stimulus'

export default class extends Controller<HTMLButtonElement> {
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
