import { Controller } from '@hotwired/stimulus'

const LoadingButtonController = class extends Controller<HTMLButtonElement> {
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

type LoadingButton = InstanceType<typeof LoadingButtonController>

export { LoadingButtonController }
export type { LoadingButton }
