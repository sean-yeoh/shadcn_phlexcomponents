import { Controller } from '@hotwired/stimulus';
export default class extends Controller {
    connect() {
        this.sidebarId = this.element.dataset.sidebarId;
    }
    toggle() {
        const sidebar = this.application.getControllerForElementAndIdentifier(document.querySelector(`#${this.sidebarId}`), 'sidebar');
        if (sidebar) {
            sidebar.toggle();
        }
    }
}
