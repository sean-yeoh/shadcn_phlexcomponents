import DialogController from './dialog_controller'

export default class extends DialogController {
  onDOMClick(event: MouseEvent) {
    if (!this.isOpen()) return

    const target = event.target as HTMLElement
    const trigger = target.closest('[data-alert-dialog-target="trigger"]')

    if (trigger) return

    const close = target.closest('[data-action*="alert-dialog#close"]')

    if (
      close ||
      (target.dataset.action &&
        target.dataset.action.includes('alert-dialog#close'))
    )
      this.close()
  }
}
