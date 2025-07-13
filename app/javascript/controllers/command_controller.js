import hotkeys from 'hotkeys-js';
import { Controller } from '@hotwired/stimulus';
import { showContent, hideContent, focusTrigger, ON_OPEN_FOCUS_DELAY, setGroupLabelsId, } from '../utils';
import { scrollToItem, highlightItem, highlightItemByIndex, filteredItemsChanged, setItemsGroupId, search, clearRemoteResults, resetState, hideError, showList, } from '../utils/command';
import { useDebounce, useClickOutside } from 'stimulus-use';
import Fuse from 'fuse.js';
const CommandController = class extends Controller {
    // targets
    static targets = [
        'trigger',
        'content',
        'overlay',
        'item',
        'group',
        'searchInput',
        'list',
        'listContainer',
        'empty',
        'modifierKey',
        'loading',
        'error',
    ];
    // values
    static values = {
        isOpen: Boolean,
        filteredItemIndexes: Array,
        searchUrl: String,
    };
    static debounces = ['search'];
    connect() {
        this.orderedItems = [...this.itemTargets];
        this.itemsInnerText = this.orderedItems.map((i) => i.innerText.trim());
        this.fuse = new Fuse(this.itemsInnerText);
        this.filteredItemIndexesValue = Array.from({ length: this.itemTargets.length }, (_, i) => i);
        this.isLoading = false;
        this.filteredItems = this.itemTargets;
        this.isDirty = false;
        this.searchPath = this.element.dataset.searchPath;
        setGroupLabelsId(this);
        setItemsGroupId(this);
        useDebounce(this);
        useClickOutside(this, { element: this.contentTarget, dispatchEvent: false });
        this.hotkeyListener = this.onHotkeyPressed.bind(this);
        this.DOMKeydownListener = this.onDOMKeydown.bind(this);
        this.setupHotkeys();
        this.replaceModifierKeyIcon();
    }
    open() {
        this.isOpenValue = true;
        this.highlightItemByIndex(0);
        setTimeout(() => {
            this.searchInputTarget.focus();
        }, ON_OPEN_FOCUS_DELAY);
    }
    close() {
        this.isOpenValue = false;
        resetState(this);
    }
    scrollToItem(index) {
        scrollToItem(this, index);
    }
    highlightItem(event = null, index = null) {
        highlightItem(this, event, index);
    }
    highlightItemByIndex(index) {
        highlightItemByIndex(this, index);
    }
    select(event) {
        let value = null;
        if (event instanceof KeyboardEvent) {
            const item = this.filteredItems.find((i) => i.dataset.highlighted === 'true');
            if (item) {
                value = item.dataset.value;
            }
        }
        else {
            // mouse event
            const item = event.currentTarget;
            value = item.dataset.value;
        }
        if (value) {
            window.Turbo.visit(value);
            this.close();
        }
    }
    inputKeydown(event) {
        if (event.key === ' ' && this.searchInputTarget.value.length === 0) {
            event.preventDefault();
        }
        hideError(this);
        showList(this);
    }
    search(event) {
        this.isDirty = true;
        clearRemoteResults(this);
        search(this, event);
    }
    clickOutside() {
        this.close();
    }
    isOpenValueChanged(isOpen, previousIsOpen) {
        if (isOpen) {
            showContent({
                trigger: this.triggerTarget,
                content: this.contentTarget,
                contentContainer: this.contentTarget,
                overlay: this.overlayTarget,
            });
            this.setupEventListeners();
        }
        else {
            hideContent({
                trigger: this.triggerTarget,
                content: this.contentTarget,
                contentContainer: this.contentTarget,
                overlay: this.overlayTarget,
            });
            if (previousIsOpen) {
                focusTrigger(this.triggerTarget);
            }
            this.cleanupEventListeners();
        }
    }
    filteredItemIndexesValueChanged(filteredItemIndexes) {
        filteredItemsChanged(this, filteredItemIndexes);
    }
    disconnect() {
        this.cleanupEventListeners();
        resetState(this);
        if (this.keybinds) {
            hotkeys.unbind(this.keybinds);
        }
    }
    setupHotkeys() {
        const modifierKey = this.element.dataset.modifierKey;
        const shortcutKey = this.element.dataset.shortcutKey;
        let keybinds = '';
        if (modifierKey && shortcutKey) {
            keybinds = `${modifierKey}+${shortcutKey}`;
            if (modifierKey === 'ctrl') {
                keybinds += `,cmd-${shortcutKey}`;
            }
        }
        else if (shortcutKey) {
            keybinds = shortcutKey;
        }
        this.keybinds = keybinds;
        hotkeys(keybinds, this.hotkeyListener);
    }
    onHotkeyPressed(event) {
        event.preventDefault();
        this.open();
    }
    replaceModifierKeyIcon() {
        if (this.hasModifierKeyTarget && this.isMac()) {
            this.modifierKeyTarget.innerHTML = '⌘';
        }
    }
    isMac() {
        const navigator = window.navigator;
        if (navigator.userAgentData) {
            return navigator.userAgentData.platform === 'macOS';
        }
        // Fallback to traditional methods
        return navigator.platform.toUpperCase().indexOf('MAC') >= 0;
    }
    onDOMKeydown(event) {
        if (!this.isOpenValue)
            return;
        const key = event.key;
        if (['Tab', 'Enter'].includes(key))
            event.preventDefault();
        if (key === 'Escape') {
            this.close();
        }
    }
    setupEventListeners() {
        document.addEventListener('keydown', this.DOMKeydownListener);
    }
    cleanupEventListeners() {
        document.removeEventListener('keydown', this.DOMKeydownListener);
        if (this.abortController) {
            this.abortController.abort();
        }
    }
};
export { CommandController };
