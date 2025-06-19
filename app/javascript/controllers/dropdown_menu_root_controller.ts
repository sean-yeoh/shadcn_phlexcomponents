import { Controller } from '@hotwired/stimulus'
import { useClickOutside } from 'stimulus-use'
import {
  getSameLevelItems,
  ON_OPEN_FOCUS_DELAY,
  lockScroll,
  unlockScroll,
  showContent,
  hideContent,
  initFloatingUi,
  focusTrigger,
} from '../utils'

export default class extends Controller<HTMLElement> {
  static targets = ['trigger', 'contentContainer', 'content', 'item']
  static values = {
    isOpen: Boolean,
    setEqualWidth: { type: Boolean, default: false },
    closestContentSelector: { type: String, default: '' },
  }

  declare isOpenValue: boolean
  declare setEqualWidthValue: boolean
  declare closestContentSelectorValue: string
  declare readonly triggerTarget: HTMLElement
  declare readonly contentContainerTarget: HTMLElement
  declare readonly contentTarget: HTMLElement
  declare readonly itemTargets: HTMLElement[]
  declare items: HTMLElement[]
  declare DOMKeydownListener: (event: KeyboardEvent) => void
  declare cleanup: () => void

  connect() {
    this.DOMKeydownListener = this.onDOMKeydown.bind(this)
    this.items = getSameLevelItems({
      content: this.contentTarget,
      items: this.itemTargets,
      closestContentSelector: this.closestContentSelectorValue,
    })
    useClickOutside(this, { element: this.contentTarget, dispatchEvent: false })
  }

  toggle(event: MouseEvent) {
    if (this.isOpenValue) {
      this.close()
    } else {
      this.open(event)
    }
  }

  open(event: MouseEvent | KeyboardEvent) {
    this.isOpenValue = true
    this.onOpen(event)

    setTimeout(() => {
      this.onOpenFocusedElement(event).focus()
    }, ON_OPEN_FOCUS_DELAY)
  }

  onOpen(_event: MouseEvent | KeyboardEvent) {}

  onOpenFocusedElement(event: MouseEvent | KeyboardEvent) {
    let itemIndex = null as number | null

    if (event instanceof KeyboardEvent) {
      const key = event.key

      if (['ArrowDown', 'Enter', ' '].includes(key)) {
        itemIndex = 0
      }
    }

    if (itemIndex !== null) {
      return this.items[itemIndex]
    } else {
      return this.contentTarget
    }
  }

  close() {
    this.isOpenValue = false
    this.onClose()
  }

  onClose() {}

  onItemFocus(event: FocusEvent) {
    const item = event.currentTarget as HTMLElement
    item.tabIndex = 0
  }

  onItemBlur(event: FocusEvent) {
    const item = event.currentTarget as HTMLElement
    item.tabIndex = -1
  }

  focusItemByIndex(
    event: KeyboardEvent | null = null,
    index: number | null = null,
  ) {
    if (event !== null) {
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

  focusItem(event: MouseEvent | KeyboardEvent) {
    let item = event.currentTarget as HTMLElement
    const index = this.items.indexOf(item)

    if (event instanceof KeyboardEvent) {
      const key = event.key
      let newIndex = 0

      if (key === 'ArrowUp') {
        newIndex = index - 1

        if (newIndex < 0) {
          newIndex = 0
        }
      } else {
        newIndex = index + 1

        if (newIndex > this.items.length - 1) {
          newIndex = this.items.length - 1
        }
      }

      this.items[newIndex].focus()
    } else {
      // item mouseover event
      this.items[index].focus()
    }
  }

  focusContent(event: MouseEvent) {
    const item = event.currentTarget as HTMLElement
    const content = item.closest(
      this.closestContentSelectorValue,
    ) as HTMLElement
    content.focus()
  }

  select(event: MouseEvent | KeyboardEvent) {
    if (!this.isOpenValue) return

    this.onSelect(event)
    this.close()
  }

  onSelect(_event: MouseEvent | KeyboardEvent) {}

  isOpenValueChanged(isOpen: boolean, previousIsOpen: boolean) {
    if (isOpen) {
      lockScroll()

      showContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
        setEqualWidth: this.setEqualWidthValue,
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
    const target = event.target
    // Let #toggle to handle state when clicked on trigger
    if (target === this.triggerTarget) return

    this.close()
  }

  onDOMKeydown(event: KeyboardEvent) {
    if (!this.isOpenValue) return

    const key = event.key

    if (['Tab', 'Enter', ' '].includes(key)) event.preventDefault()

    if (key === 'Home') {
      this.focusItemByIndex(null, 0)
    } else if (key === 'End') {
      this.focusItemByIndex(null, this.items.length - 1)
    } else if (key === 'Escape') {
      this.close()
    }
  }

  setupEventListeners() {
    document.addEventListener('keydown', this.DOMKeydownListener)
  }

  cleanupEventListeners() {
    if (this.cleanup) this.cleanup()
    document.removeEventListener('keydown', this.DOMKeydownListener)
  }

  disconnect() {
    this.cleanupEventListeners()
  }
}
