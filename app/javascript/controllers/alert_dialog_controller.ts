import { DialogController } from './dialog_controller'

const AlertDialogController = class extends DialogController {
  protected onDOMClick() {
    return
  }
}

type AlertDialog = InstanceType<typeof AlertDialogController>

export { AlertDialogController }
export type { AlertDialog }
