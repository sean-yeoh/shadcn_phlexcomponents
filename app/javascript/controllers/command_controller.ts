import hotkeys from 'hotkeys-js'
import {
  openWithOverlay,
  showContent,
  closeWithOverlay,
  hideContent,
  focusTrigger,
} from '../utils'
import CommandRootController from './command_root_controller'

declare global {
  interface Window {
    Turbo: any
  }
}

export default class extends CommandRootController {
  static targets = [
    'trigger',
    'content',
    'item',
    'group',
    'label',
    'searchInput',
    'results',
    'empty',
    'modifierKey',
  ]

  declare readonly modifierKeyTarget: HTMLElement
  declare readonly hasModifierKeyTarget: boolean
  declare modifierKey?: string
  declare shortcutKey?: string
  declare resultsTarget: HTMLElement
  declare searchInputTarget: HTMLInputElement
  declare emptyTarget: HTMLElement
  declare filteredItems: HTMLElement[]
  declare hotkeyListener: (event: KeyboardEvent) => void
  declare keybinds: string

  connect() {
    super.connect()
    this.hotkeyListener = this.onHotkeyPressed.bind(this)
    this.setupHotkeys()
    this.replaceModifierKeyIcon()
  }

  setupHotkeys() {
    const modifierKey = this.element.dataset.modifierKey
    const shortcutKey = this.element.dataset.shortcutKey
    let keybinds = ''

    if (modifierKey && shortcutKey) {
      keybinds = `${modifierKey}+${shortcutKey}`

      if (modifierKey === 'ctrl') {
        keybinds + `,cmd-${shortcutKey}`
      }
    } else if (shortcutKey) {
      keybinds = shortcutKey
    }

    this.keybinds = keybinds
    hotkeys(keybinds, this.hotkeyListener)
  }

  onHotkeyPressed(event: KeyboardEvent) {
    event.preventDefault()
    this.open()
  }

  replaceModifierKeyIcon() {
    if (this.hasModifierKeyTarget && this.isMac()) {
      this.modifierKeyTarget.innerHTML = '⌘'
    }
  }

  isMac() {
    const navigator = window.navigator as any

    if (navigator.userAgentData) {
      return navigator.userAgentData.platform === 'macOS'
    }

    // Fallback to traditional methods
    return navigator.platform.toUpperCase().indexOf('MAC') >= 0
  }

  onSelect(value: string) {
    window.Turbo.visit(value)
  }

  disconnect() {
    super.disconnect()

    if (this.keybinds) {
      hotkeys.unbind(this.keybinds)
    }
  }

  isOpenValueChanged(isOpen: boolean, previousIsOpen: boolean) {
    if (isOpen) {
      openWithOverlay(this.contentTarget.id)

      showContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentTarget,
      })

      this.setupEventListeners()
    } else {
      closeWithOverlay(this.contentTarget.id)

      hideContent({
        trigger: this.triggerTarget,
        content: this.contentTarget,
        contentContainer: this.contentTarget,
      })

      this.cleanupEventListeners()

      // Only focus trigger when is previously opened
      if (previousIsOpen) {
        focusTrigger(this.triggerTarget)
      }
    }
  }
}
