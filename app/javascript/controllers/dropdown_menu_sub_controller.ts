import { Controller } from '@hotwired/stimulus'
import {
  initFloatingUi,
  ON_OPEN_FOCUS_DELAY,
  getSameLevelItems,
  showContent,
  hideContent,
} from '../utils'

export default class extends Controller<HTMLElement> {
  static targets = ['trigger', 'contentContainer', 'content']

  static values = {
    isOpen: Boolean,
  }

  declare isOpenValue: boolean
  declare readonly triggerTarget: HTMLElement
  declare readonly contentContainerTarget: HTMLElement
  declare readonly contentTarget: HTMLElement
  declare DOMKeydownListener: (event: KeyboardEvent) => void
  declare cleanup: () => void
  declare closeTimeout: number
  declare items: HTMLElement[]

  connect() {
    this.items = getSameLevelItems({
      content: this.contentTarget,
      items: Array.from(
        this.contentTarget.querySelectorAll(
          '[data-dropdown-menu-target="item"], [data-dropdown-menu-sub-target="trigger"]',
        ),
      ),
      closestContentSelector: this.closestContentSelector(),
    })
  }

  closestContentSelector() {
    return '[data-dropdown-menu-sub-target="content"]'
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

  closeOnLeftKeydown(event: KeyboardEvent) {
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
      )

      if (subMenu) {
        const subMenuController =
          window.Stimulus.getControllerForElementAndIdentifier(
            subMenu,
            'dropdown-menu-sub',
          )

        if (subMenuController) {
          // @ts-ignore
          subMenuController.closeImmediately()
          setTimeout(() => {
            // @ts-ignore
            // weird bug where focus goes to body element after closing, and setting focus
            // manually doesn't work
            subMenuController.triggerTarget.focus()
          }, 100)
        }
      }
    }
  }

  closeImmediately() {
    this.isOpenValue = false
  }

  cleanupEventListeners() {
    if (this.cleanup) this.cleanup()
  }

  isOpenValueChanged(isOpen: boolean, previousIsOpen: boolean) {
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
    }
  }

  disconnect() {
    this.cleanupEventListeners()
  }
}
