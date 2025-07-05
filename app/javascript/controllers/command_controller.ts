import hotkeys from 'hotkeys-js'
import { Combobox } from './combobox_controller'
import { Controller } from '@hotwired/stimulus'
import {
  showContent,
  hideContent,
  focusTrigger,
  ON_OPEN_FOCUS_DELAY,
  setGroupLabelsId,
  getNextEnabledIndex,
  getPreviousEnabledIndex,
} from '../utils'
import { useDebounce, useClickOutside } from 'stimulus-use'
import Fuse from 'fuse.js'

const scrollToItem = (controller: Command | Combobox, index: number) => {
  const item = controller.filteredItems[index]
  const itemRect = item.getBoundingClientRect()
  const listContainerRect =
    controller.listContainerTarget.getBoundingClientRect()
  let newScrollTop = null as number | null

  const maxScrollTop =
    controller.listContainerTarget.scrollHeight -
    controller.listContainerTarget.clientHeight

  // scroll to bottom
  if (itemRect.bottom - listContainerRect.bottom > 0) {
    if (index === controller.filteredItems.length - 1) {
      newScrollTop = maxScrollTop
    } else {
      newScrollTop =
        controller.listContainerTarget.scrollTop +
        (itemRect.bottom - listContainerRect.bottom)
    }
  } else if (listContainerRect.top - itemRect.top > 0) {
    // scroll to top
    if (index === 0) {
      newScrollTop = 0
    } else {
      newScrollTop =
        controller.listContainerTarget.scrollTop -
        (listContainerRect.top - itemRect.top)
    }
  }

  if (newScrollTop !== null) {
    controller.scrollingViaKeyboard = true

    if (newScrollTop >= 0 && newScrollTop <= maxScrollTop) {
      controller.listContainerTarget.scrollTop = newScrollTop
    }

    // Clear the flag after scroll settles
    clearTimeout(controller.keyboardScrollTimeout)
    controller.keyboardScrollTimeout = window.setTimeout(() => {
      controller.scrollingViaKeyboard = false
    }, 200)
  }
}

const highlightItem = (
  controller: Command | Combobox,
  event: MouseEvent | KeyboardEvent | null = null,
  index: number | null = null,
) => {
  if (event !== null) {
    if (event instanceof KeyboardEvent) {
      const key = event.key
      const item = controller.filteredItems.find(
        (i) => i.dataset.highlighted === 'true',
      )

      if (item) {
        const index = controller.filteredItems.indexOf(item)

        let newIndex = 0
        if (key === 'ArrowUp') {
          newIndex = getPreviousEnabledIndex({
            items: controller.filteredItems,
            currentIndex: index,
            filterFn: (item: HTMLElement) =>
              item.dataset.disabled === undefined,
            wrapAround: false,
          })
        } else {
          newIndex = getNextEnabledIndex({
            items: controller.filteredItems,
            currentIndex: index,
            filterFn: (item: HTMLElement) =>
              item.dataset.disabled === undefined,
            wrapAround: false,
          })
        }

        controller.highlightItemByIndex(newIndex)
        controller.scrollToItem(newIndex)
      } else {
        if (key === 'ArrowUp') {
          controller.highlightItemByIndex(controller.filteredItems.length - 1)
        } else {
          controller.highlightItemByIndex(0)
        }
      }
    } else {
      // mouse event
      if (controller.scrollingViaKeyboard) {
        event.stopImmediatePropagation()
        return
      } else {
        const item = event.currentTarget as HTMLElement
        const index = controller.filteredItems.indexOf(item)
        controller.highlightItemByIndex(index)
      }
    }
  } else if (index !== null) {
    controller.highlightItemByIndex(index)
  }
}

const highlightItemByIndex = (
  controller: Command | Combobox,
  index: number,
) => {
  controller.filteredItems.forEach((item, i) => {
    if (i === index) {
      item.dataset.highlighted = 'true'
    } else {
      item.dataset.highlighted = 'false'
    }
  })
}

const filteredItemsChanged = (
  controller: Command | Combobox,
  filteredItemIndexes: number[],
) => {
  if (controller.orderedItems) {
    const filteredItems = filteredItemIndexes.map(
      (i) => controller.orderedItems[i],
    )

    // 1. Toggle visibility of items
    controller.orderedItems.forEach((item) => {
      if (filteredItems.includes(item)) {
        item.ariaHidden = 'false'
        item.classList.remove('hidden')
      } else {
        item.ariaHidden = 'true'
        item.classList.add('hidden')
      }
    })

    // 2. Get groups based on order of filtered items
    const groupIds = filteredItems.map((item) => item.dataset.groupId)
    const uniqueGroupIds = [...new Set(groupIds)].filter((groupId) => !!groupId)
    const orderedGroups = uniqueGroupIds.map((groupId) => {
      return controller.listTarget.querySelector(
        `[aria-labelledby=${groupId}]`,
      ) as HTMLElement
    })

    // 3. Append items and groups based on filtered items
    const appendedGroupIds = [] as string[]

    filteredItems.forEach((item) => {
      const groupId = item.dataset.groupId

      if (groupId) {
        const group = orderedGroups.find(
          (g) => g.getAttribute('aria-labelledby') === groupId,
        )

        if (group) {
          group.appendChild(item)

          if (!appendedGroupIds.includes(groupId)) {
            controller.listTarget.appendChild(group)
            appendedGroupIds.push(groupId)
          }
        }
      } else {
        controller.listTarget.appendChild(item)
      }
    })

    // 4. Toggle visibility of groups
    controller.groupTargets.forEach((group) => {
      const itemsCount = group.querySelectorAll(
        `[data-${controller.identifier}-target=item][aria-hidden=false]`,
      ).length
      if (itemsCount > 0) {
        group.classList.remove('hidden')
      } else {
        group.classList.add('hidden')
      }
    })

    // 5. Assign filteredItems based on the order it is displayed in the DOM
    controller.filteredItems = Array.from(
      controller.listTarget.querySelectorAll(
        `[data-${controller.identifier}-target=item][aria-hidden=false]`,
      ),
    )

    // 6. Highlight first item
    controller.highlightItemByIndex(0)

    // 7. Toggle visibility of empty
    if (controller.isDirty && !controller.isLoading) {
      if (controller.filteredItems.length > 0) {
        controller.hideEmpty()
      } else {
        controller.showEmpty()
      }
    }
  }
}

const setItemsGroupId = (controller: Command | Combobox) => {
  controller.itemTargets.forEach((item) => {
    const parent = item.parentElement

    if (parent?.dataset[`${controller.identifier}Target`] === 'group') {
      item.dataset.groupId = parent.getAttribute('aria-labelledby') as string
    }
  })
}

const search = (controller: Command | Combobox, event: InputEvent) => {
  const input = event.target as HTMLInputElement
  const value = input.value.trim()

  if (value.length > 0) {
    const results = controller.fuse.search(value)

    // Don't show disabled items when filtering
    let filteredItemIndexes = results.map((result) => result.refIndex)
    filteredItemIndexes = filteredItemIndexes.filter((index) => {
      const item = controller.orderedItems[index]
      return item.dataset.disabled === undefined
    })

    if (controller.searchPath) {
      controller.filteredItemIndexesValue = filteredItemIndexes
      controller.showLoading()
      controller.hideList()
      performRemoteSearch(controller, value)
    } else {
      controller.filteredItemIndexesValue = filteredItemIndexes
    }
  } else {
    controller.filteredItemIndexesValue = Array.from(
      { length: controller.orderedItems.length },
      (_, i) => i,
    )
  }
}

const performRemoteSearch = async (
  controller: Command | Combobox,
  query: string,
) => {
  // Cancel previous request
  if (controller.abortController) {
    controller.abortController.abort()
  }

  // Create new abort controller
  controller.abortController = new AbortController()

  try {
    const response = await fetch(`${controller.searchPath}?q=${query}`, {
      signal: controller.abortController.signal,
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
    })

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }

    const data = await response.json()
    renderRemoteResults(controller, data)
    controller.showList()
  } catch (error) {
    if (error instanceof Error && error.name !== 'AbortError') {
      console.error('Remote search error:', error)
      controller.showError()
    }
  } finally {
    controller.hideLoading()
  }
}

const renderRemoteResults = (
  controller: Command | Combobox,
  data: { html: string; group?: string }[],
) => {
  data.forEach((item) => {
    const tempDiv = document.createElement('div')
    tempDiv.innerHTML = item.html
    const itemEl = tempDiv.firstElementChild as HTMLElement
    itemEl.dataset.remote = 'true'
    itemEl.ariaHidden = 'false'

    const group = item.group

    if (group) {
      const groupEl = controller.groupTargets.find((g) => {
        const label = g.querySelector(
          `[data-shadcn-phlexcomponents="${controller.identifier}-label"]`,
        ) as HTMLElement
        if (!label) return false
        return label.textContent === group
      })

      if (groupEl) {
        groupEl.classList.remove('hidden')
        groupEl.append(itemEl)
      } else {
        const template = controller.element.querySelector(
          'template',
        ) as HTMLTemplateElement

        const clone = template.content.cloneNode(true) as HTMLElement
        const groupEl = clone.querySelector(
          `[data-shadcn-phlexcomponents="${controller.identifier}-group"]`,
        ) as HTMLElement
        const groupId = crypto.randomUUID()
        const label = clone.querySelector(
          `[data-shadcn-phlexcomponents="${controller.identifier}-label"]`,
        ) as HTMLElement
        label.textContent = group
        label.id = groupId
        groupEl.setAttribute('aria-labelledby', groupId)
        groupEl.dataset.remote = 'true'
        groupEl.append(itemEl)
        controller.listTarget.append(clone)
      }
    } else {
      controller.listTarget.append(itemEl)
    }
  })

  // Update filtered items for keyboard navigation
  controller.filteredItems = Array.from(
    controller.listTarget.querySelectorAll(
      `[data-${controller.identifier}-target="item"][aria-hidden=false]`,
    ),
  )

  controller.highlightItemByIndex(0)

  if (controller.filteredItems.length > 0) {
    controller.hideEmpty()
  } else {
    controller.showEmpty()
  }
}

const clearRemoteResults = (controller: Command | Combobox) => {
  const remoteGroups = Array.from(
    controller.element.querySelectorAll(
      `[data-shadcn-phlexcomponents="${controller.identifier}-group"][data-remote='true']`,
    ),
  )
  remoteGroups.forEach((g) => {
    if (!g.querySelector('[aria-selected="true"]')) {
      g.remove()
    }
  })

  const remoteItems = Array.from(
    controller.element.querySelectorAll(
      `[data-shadcn-phlexcomponents="${controller.identifier}-item"][data-remote='true']:not([aria-selected="true"])`,
    ),
  )

  remoteItems.forEach((i) => i.remove())
}

declare global {
  interface Window {
    Turbo: {
      visit: (path: string) => void
    }
  }
}

const CommandController = class extends Controller<HTMLElement> {
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

    this.hideError()
    this.showList()
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
    this.searchInputTarget.value = ''

    if (this.searchPath) {
      clearRemoteResults(this)
    }

    this.filteredItemIndexesValue = Array.from(
      { length: this.orderedItems.length },
      (_, i) => i,
    )

    if (this.keybinds) {
      hotkeys.unbind(this.keybinds)
    }
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

export {
  CommandController,
  scrollToItem,
  highlightItem,
  highlightItemByIndex,
  filteredItemsChanged,
  setItemsGroupId,
  search,
  performRemoteSearch,
  clearRemoteResults,
}
export type { Command }
