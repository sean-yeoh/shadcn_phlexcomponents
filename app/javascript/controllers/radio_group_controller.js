import { Controller } from '@hotwired/stimulus';
const RadioGroupController = class extends Controller {
    // targets
    static targets = ['item', 'input', 'indicator'];
    // values
    static values = {
        selected: String,
    };
    connect() {
        if (!this.selectedValue) {
            this.itemTargets[0].tabIndex = 0;
        }
    }
    select(event) {
        const item = event.currentTarget;
        this.selectedValue = item.dataset.value;
    }
    selectItem(event) {
        const focusableItems = this.itemTargets.filter((t) => !t.disabled);
        const item = event.currentTarget;
        const index = focusableItems.indexOf(item);
        const key = event.key;
        let newIndex = 0;
        if (['ArrowUp', 'ArrowLeft'].includes(key)) {
            newIndex = index - 1;
            if (newIndex < 0) {
                newIndex = focusableItems.length - 1;
            }
        }
        else {
            newIndex = index + 1;
            if (newIndex > focusableItems.length - 1) {
                newIndex = 0;
            }
        }
        this.selectedValue = focusableItems[newIndex].dataset.value;
    }
    preventDefault(event) {
        event.preventDefault();
    }
    focusItem() {
        const item = this.itemTargets.find((i) => i.dataset.value === this.selectedValue);
        if (!item)
            return;
        // Focus first item that is not disabled and allow it to be focused
        if (item.disabled) {
            item.tabIndex = -1;
            const focusableItems = this.itemTargets.filter((t) => !t.disabled);
            if (focusableItems.length > 0) {
                focusableItems[0].focus();
                focusableItems[0].tabIndex = 0;
            }
        }
        else {
            item.focus();
        }
    }
    selectedValueChanged(value) {
        this.itemTargets.forEach((item) => {
            const input = item.querySelector('[data-radio-group-target="input"]');
            const indicator = item.querySelector('[data-radio-group-target="indicator"]');
            if (value === item.dataset.value) {
                input.checked = true;
                item.tabIndex = 0;
                item.ariaChecked = 'true';
                item.dataset.state = 'checked';
                indicator.classList.remove('hidden');
            }
            else {
                input.checked = false;
                item.tabIndex = -1;
                item.ariaChecked = 'false';
                item.dataset.state = 'unchecked';
                indicator.classList.add('hidden');
            }
        });
        this.focusItem();
    }
};
export { RadioGroupController };
