import { Controller } from '@hotwired/stimulus'

const FormFieldController = class extends Controller {
  static name = 'form-field'

  connect() {
    const hintContainer = this.element.querySelector('[data-remove-label]')
    const labelContainer = this.element.querySelector('[data-remove-hint]')

    if (hintContainer) {
      const label = hintContainer.querySelector('label') as HTMLElement
      const hint = hintContainer.querySelector('p') as HTMLElement
      label.remove()
      hintContainer.replaceWith(hint)
    }

    if (labelContainer) {
      const hint = labelContainer.querySelector('p') as HTMLElement
      const label = labelContainer.querySelector('label') as HTMLElement
      hint.remove()
      labelContainer.replaceWith(label)
    }
  }
}

type FormField = InstanceType<typeof FormFieldController>

export { FormFieldController }
export type { FormField }
