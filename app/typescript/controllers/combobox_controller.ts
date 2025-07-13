import {
  ON_OPEN_FOCUS_DELAY,
  lockScroll,
  showContent,
  unlockScroll,
  hideContent,
  focusTrigger,
  setGroupLabelsId,
  onClickOutside,
} from '../utils'
import { initFloatingUi } from '../utils/floating_ui'
import { Controller } from '@hotwired/stimulus'
import Fuse from 'fuse.js'
import {
  scrollToItem,
  highlightItem,
  highlightItemByIndex,
  filteredItemsChanged,
  setItemsGroupId,
  search,
  clearRemoteResults,
  resetState,
} from '../utils/command'

import { useClickOutside, useDebounce } from 'stimulus-use'

const ComboboxController = class extends Controller<HTMLElement> {
  // targets
  static targets = [
    'trigger',
    'triggerText',
    'contentContainer',
    'content',
    'item',
    'group',
    'hiddenInput',
    'searchInput',
    'list',
    'listContainer',
    'empty',
    'loading',
    'error',
  ]
  declare readonly triggerTarget: HTMLElement
  declare readonly triggerTextTarget: HTMLElement
  declare readonly contentContainerTarget: HTMLElement
  declare readonly contentTarget: HTMLElement
  declare readonly itemTargets: HTMLElement[]
  declare readonly groupTargets: HTMLElement[]
  declare readonly hiddenInputTarget: HTMLInputElement
  declare readonly searchInputTarget: HTMLInputElement
  declare readonly listTarget: HTMLElement
  declare readonly listContainerTarget: HTMLElement
  declare readonly emptyTarget: HTMLElement
  declare readonly loadingTarget: HTMLElement
  declare readonly errorTarget: HTMLElement

  // values
  static values = {
    isOpen: Boolean,
    selected: String,
    filteredItemIndexes: Array,
  }
  declare isOpenValue: boolean
  declare selectedValue: string
  declare filteredItemIndexesValue: number[]

  // custom properties
  declare orderedItems: HTMLElement[]
  declare itemsInnerText: string[]
  declare filteredItems: HTMLElement[]
  declare fuse: Fuse<string>
  declare scrollingViaKeyboard: boolean
  declare keyboardScrollTimeout: number
  declare abortController?: AbortController
  declare searchPath?: string
  declare isDirty: boolean
  declare isLoading: boolean
  declare DOMKeydownListener: (event: KeyboardEvent) => void
  declare cleanup: () => void

  static debounces = ['search']

  connect() {
    this.orderedItems = [...this.itemTargets]
    this.itemsInnerText = this.itemTargets.map((i) => i.innerText.trim())
    this.fuse = new Fuse(this.itemsInnerText)
    this.filteredItemIndexesValue = Array.from(
      { length: this.itemTargets.length },
      (_, i) => i,
    )
    this.isLoading = false
    this.filteredItems = this.itemTargets
    this.isDirty = false
    this.searchPath = this.element.dataset.searchPath
    setGroupLabelsId(this)
    setItemsGroupId(this)
    useDebounce(this)
    useClickOutside(this, { element: this.contentTarget, dispatchEvent: false })
    this.DOMKeydownListener = this.onDOMKeydown.bind(this)
  }

  toggle() {
    if (this.isOpenValue) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.isOpenValue = true

    setTimeout(() => {
      this.searchInputTarget.focus()

      let index = 0
      if (this.selectedValue) {
        const item = this.filteredItems.find(
          (i) => i.dataset.value === this.selectedValue,
        )

        if (item && !item.dataset.disabled) {
          index = this.filteredItems.indexOf(item)
        }
      }

      this.highlightItemByIndex(index)
    }, ON_OPEN_FOCUS_DELAY)
  }

  close() {
    this.isOpenValue = false
    resetState(this)
  }

  scrollToItem(index: number) {
    scrollToItem(this, index)
  }

  highlightItem(
    event: MouseEvent | KeyboardEvent | null = null,
    index: number | null = null,
  ) {
    highlightItem(this, event, index)
  }

  highlightItemByIndex(index: number) {
    highlightItemByIndex(this, index)
  }

  select(event: MouseEvent | KeyboardEvent) {
    let item = undefined as HTMLElement | undefined

    if (event instanceof KeyboardEvent) {
      item = this.filteredItems.find((i) => i.dataset.highlighted === 'true')
    } else {
      // mouse event
      item = event.currentTarget as HTMLElement
    }

    if (item) {
      this.selectedValue = item.dataset.value as string

      // setTimeout is needed for selectedValueChanged to finish executing
      setTimeout(() => {
        this.close()
      }, 100)
    }
  }

  inputKeydown(event: KeyboardEvent) {
    if (event.key === ' ' && this.searchInputTarget.value.length === 0) {
      event.preventDefault()
    }

    this.hideError()
    this.showList()
  }

  search(event: InputEvent) {
    this.isDirty = true
    clearRemoteResults(this)
    search(this, event)
  }

  clickOutside(event: MouseEvent) {
    onClickOutside(this, event)
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
      lockScroll(this.contentTarget.id)

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
      unlockScroll(this.contentTarget.id)

      hideContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentContainerTarget,
      })

      if (previousIsOpen) {
        focusTrigger(this.triggerTarget)
      }

      this.cleanupEventListeners()
    }
  }

  filteredItemIndexesValueChanged(filteredItemIndexes: number[]) {
    filteredItemsChanged(this, filteredItemIndexes)
  }

  disconnect() {
    this.cleanupEventListeners()
    resetState(this)
  }

  showLoading() {
    this.isLoading = true
    this.loadingTarget.classList.remove('hidden')
  }

  hideLoading() {
    this.isLoading = false
    this.loadingTarget.classList.add('hidden')
  }

  showList() {
    this.listTarget.classList.remove('hidden')
  }

  hideList() {
    this.listTarget.classList.add('hidden')
  }

  showError() {
    this.errorTarget.classList.remove('hidden')
  }

  hideError() {
    this.errorTarget.classList.add('hidden')
  }

  showEmpty() {
    this.emptyTarget.classList.remove('hidden')
  }

  hideEmpty() {
    this.emptyTarget.classList.add('hidden')
  }

  showSelectedRemoteItems() {
    const remoteItems = Array.from(
      this.element.querySelectorAll(
        `[data-shadcn-phlexcomponents="${this.identifier}-item"][data-remote='true']`,
      ),
    )

    remoteItems.forEach((i) => {
      const isInsideGroup =
        i.parentElement?.dataset?.shadcnPhlexcomponents ===
        `${this.identifier}-group`

      if (isInsideGroup) {
        const isRemoteGroup = i.parentElement.dataset.remote === 'true'

        if (isRemoteGroup) {
          i.parentElement.classList.remove('hidden')
        }
      }

      i.ariaHidden = 'false'
      i.classList.remove('hidden')
    })
  }

  hideSelectedRemoteItems() {
    const remoteItems = Array.from(
      this.element.querySelectorAll(
        `[data-shadcn-phlexcomponents="${this.identifier}-item"][data-remote='true']`,
      ),
    )

    remoteItems.forEach((i) => {
      const isInsideGroup =
        i.parentElement?.dataset?.shadcnPhlexcomponents ===
        `${this.identifier}-group`

      if (isInsideGroup) {
        const isRemoteGroup = i.parentElement.dataset.remote === 'true'

        if (isRemoteGroup) {
          i.parentElement.classList.add('hidden')
        }
      }

      i.ariaHidden = 'true'
      i.classList.add('hidden')
    })
  }

  protected setupEventListeners() {
    document.addEventListener('keydown', this.DOMKeydownListener)
  }

  protected cleanupEventListeners() {
    document.removeEventListener('keydown', this.DOMKeydownListener)

    if (this.abortController) {
      this.abortController.abort()
    }
  }

  protected onDOMKeydown(event: KeyboardEvent) {
    if (!this.isOpenValue) return

    const key = event.key

    if (['Tab', 'Enter'].includes(key)) event.preventDefault()

    if (key === 'Escape') {
      this.close()
    }
  }
}

type Combobox = InstanceType<typeof ComboboxController>

export { ComboboxController }
export type { Combobox }
