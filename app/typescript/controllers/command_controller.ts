import hotkeys from 'hotkeys-js'
import { Controller } from '@hotwired/stimulus'
import {
  showContent,
  hideContent,
  focusTrigger,
  ON_OPEN_FOCUS_DELAY,
  setGroupLabelsId,
} from '../utils'
import {
  scrollToItem,
  highlightItem,
  highlightItemByIndex,
  filteredItemsChanged,
  setItemsGroupId,
  search,
  clearRemoteResults,
  resetState,
  hideError,
  showList,
} from '../utils/command'
import { useDebounce, useClickOutside } from 'stimulus-use'
import Fuse from 'fuse.js'

declare global {
  interface Window {
    Turbo: {
      visit: (path: string) => void
    }
  }
}

const CommandController = class extends Controller<HTMLElement> {
  static name = 'command'

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
  ]
  declare readonly triggerTarget: HTMLElement
  declare readonly contentTarget: HTMLElement
  declare readonly overlayTarget: HTMLElement
  declare readonly itemTargets: HTMLInputElement[]
  declare readonly groupTargets: HTMLElement[]
  declare readonly searchInputTarget: HTMLInputElement
  declare readonly listTarget: HTMLElement
  declare readonly listContainerTarget: HTMLElement
  declare readonly emptyTarget: HTMLElement
  declare readonly modifierKeyTarget: HTMLElement
  declare readonly hasModifierKeyTarget: boolean
  declare readonly loadingTarget: HTMLElement
  declare readonly errorTarget: HTMLElement

  // values
  static values = {
    isOpen: Boolean,
    filteredItemIndexes: Array,
    searchUrl: String,
  }
  declare isOpenValue: boolean
  declare filteredItemIndexesValue: number[]

  // custom properties
  declare trigger: HTMLElement
  declare orderedItems: HTMLElement[]
  declare itemsInnerText: string[]
  declare filteredItems: HTMLElement[]
  declare fuse: Fuse<string>
  declare scrollingViaKeyboard: boolean
  declare keyboardScrollTimeout: number
  declare modifierKey?: string
  declare shortcutKey?: string
  declare keybinds: string
  declare abortController?: AbortController
  declare searchPath?: string
  declare isDirty: boolean
  declare isLoading: boolean
  declare hotkeyListener: (event: KeyboardEvent) => void
  declare DOMKeydownListener: (event: KeyboardEvent) => void
  declare DOMClickListener: (event: MouseEvent) => void

  static debounces = ['search']

  connect() {
    this.orderedItems = [...this.itemTargets]
    this.itemsInnerText = this.orderedItems.map((i) => i.innerText.trim())
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
    this.hotkeyListener = this.onHotkeyPressed.bind(this)
    this.DOMKeydownListener = this.onDOMKeydown.bind(this)
    this.setupHotkeys()
    this.replaceModifierKeyIcon()
  }

  open() {
    this.isOpenValue = true
    this.highlightItemByIndex(0)

    setTimeout(() => {
      this.searchInputTarget.focus()
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
    let value = null as null | string

    if (event instanceof KeyboardEvent) {
      const item = this.filteredItems.find(
        (i) => i.dataset.highlighted === 'true',
      )

      if (item) {
        value = item.dataset.value as string
      }
    } else {
      // mouse event
      const item = event.currentTarget as HTMLElement
      value = item.dataset.value as string
    }

    if (value) {
      window.Turbo.visit(value)
      this.close()
    }
  }

  inputKeydown(event: KeyboardEvent) {
    if (event.key === ' ' && this.searchInputTarget.value.length === 0) {
      event.preventDefault()
    }

    hideError(this)
    showList(this)
  }

  search(event: InputEvent) {
    this.isDirty = true
    clearRemoteResults(this)
    search(this, event)
  }

  clickOutside() {
    this.close()
  }

  isOpenValueChanged(isOpen: boolean, previousIsOpen: boolean) {
    if (isOpen) {
      showContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentTarget,
        overlay: this.overlayTarget,
      })

      this.setupEventListeners()
    } else {
      hideContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentTarget,
        overlay: this.overlayTarget,
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

    if (this.keybinds) {
      hotkeys.unbind(this.keybinds)
    }
  }

  protected setupHotkeys() {
    const modifierKey = this.element.dataset.modifierKey
    const shortcutKey = this.element.dataset.shortcutKey

    let keybinds = ''

    if (modifierKey && shortcutKey) {
      keybinds = `${modifierKey}+${shortcutKey}`

      if (modifierKey === 'ctrl') {
        keybinds += `,cmd-${shortcutKey}`
      }
    } else if (shortcutKey) {
      keybinds = shortcutKey
    }

    this.keybinds = keybinds
    hotkeys(keybinds, this.hotkeyListener)
  }

  protected onHotkeyPressed(event: KeyboardEvent) {
    event.preventDefault()
    this.open()
  }

  protected replaceModifierKeyIcon() {
    if (this.hasModifierKeyTarget && this.isMac()) {
      this.modifierKeyTarget.innerHTML = '⌘'
    }
  }

  protected isMac() {
    const navigator = window.navigator as unknown as {
      platform: string
      userAgentData: {
        platform: string
      }
    }

    if (navigator.userAgentData) {
      return navigator.userAgentData.platform === 'macOS'
    }

    // Fallback to traditional methods
    return navigator.platform.toUpperCase().indexOf('MAC') >= 0
  }

  protected onDOMKeydown(event: KeyboardEvent) {
    if (!this.isOpenValue) return

    const key = event.key

    if (['Tab', 'Enter'].includes(key)) event.preventDefault()

    if (key === 'Escape') {
      this.close()
    }
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
}

type Command = InstanceType<typeof CommandController>

export { CommandController }
export type { Command }
