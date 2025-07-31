import { DialogController } from './dialog_controller'

const AlertDialogController = class extends DialogController {
  static name = 'alert-dialog'

  protected onDOMClick() {
    return
  }
}

type AlertDialog = InstanceType<typeof AlertDialogController>

export { AlertDialogController }
export type { AlertDialog }
