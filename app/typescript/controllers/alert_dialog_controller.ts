import Dialog from './dialog_controller'

const AlertDialog = class extends Dialog {
  static name = 'alert-dialog'

  protected onDOMClick() {
    return
  }
}

export default AlertDialog
