import {
  ON_OPEN_FOCUS_DELAY,
  lockScroll,
  showContent,
  initFloatingUi,
  unlockScroll,
  hideContent,
  focusTrigger,
} from '../utils'
import CommandRootController from './command_root_controller'

export default class extends CommandRootController {
  static targets = [
    'trigger',
    'contentContainer',
    'content',
    'item',
    'triggerText',
    'group',
    'label',
    'hiddenInput',
    'searchInput',
    'results',
    'empty',
  ]

  static values = {
    isOpen: Boolean,
    selected: String,
    filteredItemIndexes: Array,
  }

  declare readonly contentContainerTarget: HTMLElement
  declare readonly triggerTextTarget: HTMLElement
  declare readonly hiddenInputTarget: HTMLInputElement
  declare selectedValue: string
  declare cleanup: () => void

  open() {
    this.isOpenValue = true
    this.highlightItemByIndex(0)

    let index = 0

    if (this.selectedValue) {
      const item = this.itemTargets.find(
        (i) => i.dataset.value === this.selectedValue,
      )

      if (item && !item.dataset.disabled) {
        index = this.items.indexOf(item)
      }
    }

    this.highlightItemByIndex(index)

    setTimeout(() => {
      this.searchInputTarget.focus()
    }, ON_OPEN_FOCUS_DELAY)
  }

  toggle() {
    if (this.isOpenValue) {
      this.close()
    } else {
      this.open()
    }
  }

  onSelect(value: string): void {
    this.selectedValue = value
  }

  selectedValueChanged(value: string) {
    const item = this.itemTargets.find((i) => i.dataset.value === value)

    if (item) {
      this.triggerTextTarget.textContent = item.textContent

      this.itemTargets.forEach((i) => {
        if (i.dataset.value === value) {
          i.setAttribute('aria-selected', 'true')
        } else {
          i.setAttribute('aria-selected', 'false')
        }
      })

      this.hiddenInputTarget.value = value
    }

    this.triggerTarget.dataset.hasValue = `${!!value && value.length > 0}`

    const placeholder = this.triggerTarget.dataset.placeholder

    if (placeholder && this.triggerTarget.dataset.hasValue === 'false') {
      this.triggerTextTarget.textContent = placeholder
    }
  }

  isOpenValueChanged(isOpen: boolean, previousIsOpen: boolean) {
    if (isOpen) {
      lockScroll()

      showContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
        setEqualWidth: true,
      })

      this.cleanup = initFloatingUi({
        referenceElement: this.triggerTarget,
        floatingElement: this.contentContainerTarget,
        side: this.contentTarget.dataset.side,
        align: this.contentTarget.dataset.align,
        sideOffset: 4,
      })

      this.setupEventListeners()
    } else {
      unlockScroll()

      hideContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
      })

      this.cleanupEventListeners()

      // Only focus trigger when is previously opened
      if (previousIsOpen) {
        focusTrigger(this.triggerTarget)
      }
    }
  }

  clickOutside(event: MouseEvent) {
    const target = event.target as HTMLElement
    // Let #toggle to handle state when clicked on trigger
    if (target === this.triggerTarget) return
    if (this.triggerTarget.contains(target)) return

    this.close()
  }
}
