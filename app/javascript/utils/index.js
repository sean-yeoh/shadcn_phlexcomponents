const ANIMATION_OUT_DELAY = 100;
const ON_OPEN_FOCUS_DELAY = 100;
const ON_CLOSE_FOCUS_DELAY = 50;
const getScrollbarWidth = () => {
    // Create a temporary div container and append it into the body
    const outer = document.createElement('div');
    outer.style.visibility = 'hidden';
    outer.style.overflow = 'scroll'; // force scrollbars
    outer.style.width = '100px';
    outer.style.position = 'absolute';
    outer.style.top = '-9999px';
    document.body.appendChild(outer);
    // Create an inner div and place it inside the outer div
    const inner = document.createElement('div');
    inner.style.width = '100%';
    outer.appendChild(inner);
    // Calculate the scrollbar width
    const scrollbarWidth = outer.offsetWidth - inner.offsetWidth;
    // Clean up
    outer.remove();
    return scrollbarWidth;
};
const lockScroll = (contentId) => {
    if (window.innerHeight < document.documentElement.scrollHeight) {
        document.body.dataset.scrollLocked = '1';
        document.body.classList.add('data-[scroll-locked]:pointer-events-none', 'data-[scroll-locked]:!overflow-hidden', 'data-[scroll-locked]:!relative', 'data-[scroll-locked]:px-0', 'data-[scroll-locked]:pt-0', 'data-[scroll-locked]:ml-0', 'data-[scroll-locked]:mt-0');
        document.body.style.marginRight = `${getScrollbarWidth()}px`;
        const contentIdsString = document.body.dataset.scrollLockedContentIds || '[]';
        const contentIds = JSON.parse(contentIdsString);
        contentIds.push(contentId);
        document.body.dataset.scrollLockedContentIds = JSON.stringify(contentIds);
    }
};
const unlockScroll = (contentId) => {
    const contentIdsString = document.body.dataset.scrollLockedContentIds || '[]';
    const contentIds = JSON.parse(contentIdsString);
    const newContentIds = contentIds.filter((id) => id !== contentId);
    document.body.dataset.scrollLockedContentIds = JSON.stringify(newContentIds);
    if (newContentIds.length === 0) {
        delete document.body.dataset.scrollLocked;
        document.body.classList.remove('data-[scroll-locked]:pointer-events-none', 'data-[scroll-locked]:!overflow-hidden', 'data-[scroll-locked]:!relative', 'data-[scroll-locked]:px-0', 'data-[scroll-locked]:pt-0', 'data-[scroll-locked]:ml-0', 'data-[scroll-locked]:mt-0');
        document.body.style.marginRight = '';
    }
};
const focusTrigger = (triggerTarget) => {
    setTimeout(() => {
        if (triggerTarget.dataset.asChild === 'false') {
            const childElement = triggerTarget.firstElementChild;
            if (childElement) {
                childElement.focus();
            }
        }
        else {
            triggerTarget.focus();
        }
    }, ON_CLOSE_FOCUS_DELAY);
};
const focusElement = (element) => {
    setTimeout(() => {
        if (element) {
            element.focus();
        }
    }, ON_OPEN_FOCUS_DELAY);
};
const getFocusableElements = (container) => {
    return Array.from(container.querySelectorAll('button, [href], input:not([type="hidden"]), select:not([tabindex="-1"]), textarea, [tabindex]:not([tabindex="-1"])'));
};
const getSameLevelItems = ({ content, items, closestContentSelector, }) => {
    const sameLevelItems = [];
    items.forEach((i) => {
        if (i.closest(closestContentSelector) === content &&
            i.dataset.disabled === undefined) {
            sameLevelItems.push(i);
        }
    });
    return sameLevelItems;
};
const showContent = ({ trigger, content, contentContainer, setEqualWidth, overlay, }) => {
    contentContainer.style.display = '';
    if (trigger) {
        if (setEqualWidth) {
            const triggerWidth = trigger.offsetWidth;
            const contentContainerWidth = contentContainer.offsetWidth;
            if (contentContainerWidth < triggerWidth) {
                contentContainer.style.width = `${triggerWidth}px`;
            }
        }
        trigger.ariaExpanded = 'true';
        trigger.dataset.state = 'open';
    }
    content.dataset.state = 'open';
    if (overlay) {
        overlay.style.display = '';
        overlay.dataset.state = 'open';
        lockScroll(content.id);
    }
};
const hideContent = ({ trigger, content, contentContainer, overlay, }) => {
    if (trigger) {
        trigger.ariaExpanded = 'false';
        trigger.dataset.state = 'closed';
    }
    content.dataset.state = 'closed';
    setTimeout(() => {
        contentContainer.style.display = 'none';
        if (overlay) {
            overlay.style.display = 'none';
            overlay.dataset.state = 'closed';
            unlockScroll(content.id);
        }
    }, ANIMATION_OUT_DELAY);
};
const getStimulusInstance = (controller, element) => {
    if (!element)
        return;
    return window.Stimulus.getControllerForElementAndIdentifier(element, controller);
};
const anyNestedComponentsOpen = (element) => {
    const components = [];
    const componentNames = [
        'dialog',
        'alert-dialog',
        'dropdown-menu',
        'popover',
        'select',
        'combobox',
        'command',
        'hover-card',
        'tooltip',
        'date-picker',
        'date-range-picker',
    ];
    componentNames.forEach((name) => {
        const triggers = Array.from(element.querySelectorAll(`[data-shadcn-phlexcomponents="${name}-trigger"]`));
        const controllerElements = Array.from(element.querySelectorAll(`[data-controller="${name}"]`));
        controllerElements.forEach((controller) => {
            const stimulusInstance = getStimulusInstance(name, controller);
            if (stimulusInstance) {
                components.push(stimulusInstance);
            }
        });
        triggers.forEach((trigger) => {
            const stimulusInstance = getStimulusInstance(name, document.querySelector(`#${trigger.getAttribute('aria-controls')}`));
            if (stimulusInstance) {
                components.push(stimulusInstance);
            }
        });
    });
    return components.some((c) => c.isOpenValue);
};
const onClickOutside = (controller, event) => {
    const target = event.target;
    // Let trigger handle state
    if (target === controller.triggerTarget)
        return;
    if (controller.triggerTarget.contains(target))
        return;
    controller.close();
};
const setGroupLabelsId = (controller) => {
    controller.groupTargets.forEach((g) => {
        const label = g.querySelector(`[data-shadcn-phlexcomponents="${controller.identifier}-label"]`);
        if (label) {
            label.id = g.getAttribute('aria-labelledby');
        }
    });
};
const getNextEnabledIndex = ({ items, currentIndex, wrapAround, filterFn, }) => {
    let newIndex = null;
    if (filterFn) {
        newIndex = items.findIndex((item, index) => index > currentIndex && filterFn(item));
        if (newIndex === -1) {
            newIndex = currentIndex;
        }
    }
    else {
        newIndex = currentIndex + 1;
    }
    if (newIndex > items.length - 1) {
        if (wrapAround) {
            newIndex = 0;
        }
        else {
            newIndex = items.length - 1;
        }
    }
    return newIndex;
};
const getPreviousEnabledIndex = ({ items, currentIndex, wrapAround, filterFn, }) => {
    let newIndex = null;
    if (filterFn) {
        newIndex = items.findLastIndex((item, index) => index < currentIndex && filterFn(item));
        if (newIndex === -1) {
            newIndex = currentIndex;
        }
    }
    else {
        newIndex = currentIndex - 1;
    }
    if (newIndex < 0) {
        if (wrapAround) {
            newIndex = items.length - 1;
        }
        else {
            newIndex = 0;
        }
    }
    return newIndex;
};
const handleTabNavigation = (element, event) => {
    const focusableElements = getFocusableElements(element);
    const firstElement = focusableElements[0];
    const lastElement = focusableElements[focusableElements.length - 1];
    // If Shift + Tab pressed on first element, go to last element
    if (event.shiftKey && document.activeElement === firstElement) {
        event.preventDefault();
        lastElement.focus();
    }
    // If Tab pressed on last element, go to first element
    else if (!event.shiftKey && document.activeElement === lastElement) {
        event.preventDefault();
        firstElement.focus();
    }
};
export { ANIMATION_OUT_DELAY, ON_CLOSE_FOCUS_DELAY, ON_OPEN_FOCUS_DELAY, lockScroll, unlockScroll, focusTrigger, focusElement, getFocusableElements, getSameLevelItems, showContent, hideContent, getStimulusInstance, anyNestedComponentsOpen, onClickOutside, setGroupLabelsId, getNextEnabledIndex, getPreviousEnabledIndex, handleTabNavigation, };
