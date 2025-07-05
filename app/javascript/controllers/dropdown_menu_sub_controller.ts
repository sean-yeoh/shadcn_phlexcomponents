import { Controller } from '@hotwired/stimulus'
import {
  initFloatingUi,
  ON_OPEN_FOCUS_DELAY,
  getSameLevelItems,
  showContent,
  hideContent,
  getStimulusInstance,
} from '../utils'

const DropdownMenuSubController = class extends Controller<HTMLElement> {
  // targets
  static targets = ['trigger', 'contentContainer', 'content']
  declare readonly triggerTarget: HTMLElement
  declare readonly contentContainerTarget: HTMLElement
  declare readonly contentTarget: HTMLElement

  // values
  static values = {
    isOpen: Boolean,
  }
  declare isOpenValue: boolean

  // custom properties
  declare closeTimeout: number
  declare items: HTMLElement[]
  declare DOMKeydownListener: (event: KeyboardEvent) => void
  declare cleanup: () => void

  connect() {
    this.items = getSameLevelItems({
      content: this.contentTarget,
      items: Array.from(
        this.contentTarget.querySelectorAll(
          '[data-dropdown-menu-target="item"], [data-dropdown-menu-sub-target="trigger"]',
        ),
      ),
      closestContentSelector: '[data-dropdown-menu-sub-target="content"]',
    })
  }

  open(event: MouseEvent | KeyboardEvent | null = null) {
    clearTimeout(this.closeTimeout)
    this.isOpenValue = true

    setTimeout(() => {
      if (event instanceof KeyboardEvent) {
        const key = event.key

        if (['ArrowRight', 'Enter', ' '].includes(key)) {
          this.focusItemByIndex(null, 0)
        }
      }
    }, ON_OPEN_FOCUS_DELAY)
  }

  close() {
    this.closeTimeout = window.setTimeout(() => {
      this.isOpenValue = false
    }, 250)
  }

  closeOnLeftKeydown() {
    this.closeImmediately()
    this.triggerTarget.focus()
  }

  focusItemByIndex(event: KeyboardEvent | null, index: number | null) {
    if (event) {
      const key = event.key

      if (key === 'ArrowUp') {
        this.items[this.items.length - 1].focus()
      } else {
        this.items[0].focus()
      }
    } else if (index !== null) {
      this.items[index].focus()
    }
  }

  closeParentSubMenu() {
    const parentContent = this.triggerTarget.closest(
      '[data-dropdown-menu-sub-target="content"]',
    )

    if (parentContent) {
      const subMenu = parentContent.closest(
        '[data-shadcn-phlexcomponents="dropdown-menu-sub"]',
      ) as HTMLElement

      if (subMenu) {
        const subMenuController = getStimulusInstance<DropdownMenuSub>(
          'dropdown-menu-sub',
          subMenu,
        )

        if (subMenuController) {
          subMenuController.closeImmediately()
          setTimeout(() => {
            subMenuController.triggerTarget.focus()
          }, 100)
        }
      }
    }
  }

  closeImmediately() {
    this.isOpenValue = false
  }

  isOpenValueChanged(isOpen: boolean) {
    if (isOpen) {
      showContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
      })

      this.cleanup = initFloatingUi({
        referenceElement: this.triggerTarget,
        floatingElement: this.contentContainerTarget,
        side: this.contentTarget.dataset.side,
        align: this.contentTarget.dataset.align,
        sideOffset: -2,
      })
    } else {
      this.closeTimeout = window.setTimeout(() => {
        hideContent({
          trigger: this.triggerTarget,
          content: this.contentTarget,
          contentContainer: this.contentContainerTarget,
        })
      })

      this.cleanupEventListeners()
    }
  }

  disconnect() {
    this.cleanupEventListeners()
  }

  protected cleanupEventListeners() {
    if (this.cleanup) this.cleanup()
  }
}

type DropdownMenuSub = InstanceType<typeof DropdownMenuSubController>

export { DropdownMenuSubController }
export type { DropdownMenuSub }
