import { Command } from '../controllers/command_controller'
import {
  Combobox,
  ComboboxController,
} from '../controllers/combobox_controller'
import { getNextEnabledIndex, getPreviousEnabledIndex } from '.'

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

    // 5. Move remote items to the end
    const remoteItems = Array.from(
      controller.element.querySelectorAll(
        `[data-shadcn-phlexcomponents="${controller.identifier}-item"][data-remote='true']`,
      ),
    )
    remoteItems.forEach((i) => {
      const isInsideGroup =
        i.parentElement?.dataset?.shadcnPhlexcomponents ===
        `${controller.identifier}-group`

      if (isInsideGroup) {
        const isRemoteGroup = i.parentElement.dataset.remote === 'true'

        // Move group to last
        if (isRemoteGroup) {
          controller.listTarget.appendChild(i.parentElement)
        }
      } else {
        // Move item to last
        controller.listTarget.appendChild(i)
      }
    })

    // 6. Assign filteredItems based on the order it is displayed in the DOM
    controller.filteredItems = Array.from(
      controller.listTarget.querySelectorAll(
        `[data-${controller.identifier}-target=item][aria-hidden=false]`,
      ),
    )

    // 7. Highlight first item
    controller.highlightItemByIndex(0)

    // 8. Toggle visibility of empty
    if (controller.isDirty && !controller.isLoading) {
      if (controller.filteredItems.length > 0) {
        hideEmpty(controller)
      } else {
        showEmpty(controller)
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
      hideSelectedRemoteItems(controller)
      showLoading(controller)
      hideList(controller)
      hideEmpty(controller)
      controller.filteredItemIndexesValue = filteredItemIndexes
      performRemoteSearch(controller, value)
    } else {
      controller.filteredItemIndexesValue = filteredItemIndexes
    }
  } else {
    if (controller.searchPath) {
      showSelectedRemoteItems(controller)
    }
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
    showList(controller)
  } catch (error) {
    if (error instanceof Error && error.name !== 'AbortError') {
      console.error('Remote search error:', error)
      showError(controller)
    }
  } finally {
    hideLoading(controller)
  }
}

const renderRemoteResults = (
  controller: Command | Combobox,
  data: { html: string; group?: string }[],
) => {
  console.log('data', data)
  data.forEach((item) => {
    const tempDiv = document.createElement('div')
    tempDiv.innerHTML = item.html
    const itemEl = tempDiv.firstElementChild as HTMLElement
    itemEl.dataset.remote = 'true'
    itemEl.ariaHidden = 'false'

    if (controller instanceof ComboboxController) {
      // Don't append same item
      if (controller.selectedValue === itemEl.dataset.value) {
        const item = controller.itemTargets.find(
          (i) => i.dataset.value === controller.selectedValue,
        )
        if (item) {
          item.classList.remove('hidden')
          item.ariaHidden = 'false'
        }

        return
      }
    }

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

  console.log('controller.filteredItems', controller.filteredItems)
  if (controller.filteredItems.length > 0) {
    hideEmpty(controller)
  } else {
    showEmpty(controller)
  }
}

const clearRemoteResults = (controller: Command | Combobox) => {
  const remoteGroups = Array.from(
    controller.element.querySelectorAll(
      `[data-shadcn-phlexcomponents="${controller.identifier}-group"][data-remote='true']`,
    ),
  )

  remoteGroups.forEach((g) => {
    const containsSelected = g.querySelector('[aria-selected="true"]')

    if (!containsSelected) {
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

const resetState = (controller: Command | Combobox) => {
  controller.searchInputTarget.value = ''

  if (controller.searchPath) {
    clearRemoteResults(controller)
    showSelectedRemoteItems(controller)
  }

  controller.filteredItemIndexesValue = Array.from(
    { length: controller.orderedItems.length },
    (_, i) => i,
  )
}

const showLoading = (controller: Command | Combobox) => {
  controller.isLoading = true
  controller.loadingTarget.classList.remove('hidden')
}

const hideLoading = (controller: Command | Combobox) => {
  controller.isLoading = false
  controller.loadingTarget.classList.add('hidden')
}

const showList = (controller: Command | Combobox) => {
  controller.listTarget.classList.remove('hidden')
}

const hideList = (controller: Command | Combobox) => {
  controller.listTarget.classList.add('hidden')
}

const showError = (controller: Command | Combobox) => {
  controller.errorTarget.classList.remove('hidden')
}

const hideError = (controller: Command | Combobox) => {
  controller.errorTarget.classList.add('hidden')
}

const showEmpty = (controller: Command | Combobox) => {
  controller.emptyTarget.classList.remove('hidden')
}

const hideEmpty = (controller: Command | Combobox) => {
  controller.emptyTarget.classList.add('hidden')
}

const showSelectedRemoteItems = (controller: Command | Combobox) => {
  const remoteItems = Array.from(
    controller.element.querySelectorAll(
      `[data-shadcn-phlexcomponents="${controller.identifier}-item"][data-remote='true']`,
    ),
  )

  remoteItems.forEach((i) => {
    const isInsideGroup =
      i.parentElement?.dataset?.shadcnPhlexcomponents ===
      `${controller.identifier}-group`

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

const hideSelectedRemoteItems = (controller: Command | Combobox) => {
  const remoteItems = Array.from(
    controller.element.querySelectorAll(
      `[data-shadcn-phlexcomponents="${controller.identifier}-item"][data-remote='true']`,
    ),
  )

  remoteItems.forEach((i) => {
    const isInsideGroup =
      i.parentElement?.dataset?.shadcnPhlexcomponents ===
      `${controller.identifier}-group`

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

export {
  scrollToItem,
  highlightItem,
  highlightItemByIndex,
  filteredItemsChanged,
  setItemsGroupId,
  search,
  performRemoteSearch,
  clearRemoteResults,
  resetState,
  showLoading,
  hideLoading,
  showList,
  hideList,
  showError,
  hideError,
  showEmpty,
  hideEmpty,
  showSelectedRemoteItems,
  hideSelectedRemoteItems,
}
