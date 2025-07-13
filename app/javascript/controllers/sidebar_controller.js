import { Controller } from '@hotwired/stimulus';
export default class default_1 extends Controller {
    static targets = ['panel', 'panelOffset'];
    connect() {
        this.width = this.element.offsetWidth;
    }
    toggle() {
        if (this.isOpen()) {
            this.close();
        }
        else {
            this.open();
        }
    }
    open() {
        this.element.dataset.state = 'expanded';
        this.element.dataset.collapsible = '';
        this.panelTarget.style.removeProperty('left');
        this.panelOffsetTarget.style.removeProperty('width');
    }
    close() {
        this.element.dataset.state = 'collapsed';
        this.element.dataset.collapsible = 'offcanvas';
        this.panelTarget.style.left = `-${this.width}px`;
        this.panelOffsetTarget.style.width = `${0}`;
    }
    isOpen() {
        return this.element.dataset.state === 'expanded';
    }
}
