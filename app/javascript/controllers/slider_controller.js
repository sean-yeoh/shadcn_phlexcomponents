import { Controller } from '@hotwired/stimulus';
import noUiSlider from 'nouislider';
const SliderController = class extends Controller {
    // targets
    static targets = ['slider', 'hiddenInput', 'endHiddenInput'];
    connect() {
        this.range = this.element.dataset.range === 'true';
        this.DOMClickListener = this.onDOMClick.bind(this);
        this.onUpdateValuesListener = this.onUpdateValues.bind(this);
        const options = this.getOptions();
        this.slider = noUiSlider.create(this.sliderTarget, options);
        if (this.element.dataset.disabled === 'true') {
            this.slider.disable();
        }
        if (this.element.dataset.id) {
            const lowerHandle = this.slider.target.querySelector('.noUi-handle-lower');
            if (lowerHandle) {
                lowerHandle.id = this.element.dataset.id;
            }
        }
        this.slider.on('update', this.onUpdateValuesListener);
        document.addEventListener('click', this.DOMClickListener);
    }
    disconnect() {
        document.removeEventListener('click', this.DOMClickListener);
    }
    getOptions() {
        const defaultOptions = {
            connect: this.range ? true : 'lower',
            tooltips: true,
        };
        defaultOptions.range = {
            min: [parseFloat(this.element.dataset.min || '0')],
            max: [parseFloat(this.element.dataset.max || '100')],
        };
        defaultOptions.step = parseFloat(this.element.dataset.step || '1');
        if (this.range) {
            defaultOptions.start = [
                parseFloat(this.element.dataset.value || '0'),
                parseFloat(this.element.dataset.endValue || '0'),
            ];
            defaultOptions.handleAttributes = [
                { 'aria-label': 'lower' },
                { 'aria-label': 'upper' },
            ];
        }
        else {
            defaultOptions.start = [parseFloat(this.element.dataset.value || '0')];
            defaultOptions.handleAttributes = [{ 'aria-label': 'lower' }];
        }
        defaultOptions.orientation = (this.element.dataset.orientation ||
            'horizontal');
        try {
            return {
                ...defaultOptions,
                ...JSON.parse(this.element.dataset.options || ''),
            };
        }
        catch {
            return defaultOptions;
        }
    }
    onUpdateValues(values) {
        this.hiddenInputTarget.value = `${values[0]}`;
        if (this.range && this.hasEndHiddenInputTarget) {
            this.endHiddenInputTarget.value = `${values[1]}`;
        }
    }
    onDOMClick(event) {
        const target = event.target;
        // Focus handle of slider when label is clicked.
        if (target instanceof HTMLLabelElement) {
            const id = target.getAttribute('for');
            if (id === this.element.dataset.id) {
                const handle = document.querySelector(`#${id}`);
                if (handle) {
                    handle.focus();
                }
            }
        }
    }
};
export { SliderController };
