import { DialogController } from "./dialog_controller";
const AlertDialogController = class extends DialogController {
  static name = "alert-dialog";
  onDOMClick() {
    return;
  }
};
export { AlertDialogController };
