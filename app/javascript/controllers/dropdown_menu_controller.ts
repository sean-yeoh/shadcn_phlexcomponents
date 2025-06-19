import DropdownMenuSubController from './dropdown_menu_sub_controller'
import DropdownMenuRootController from './dropdown_menu_root_controller'

export default class extends DropdownMenuRootController {
  static values = {
    isOpen: Boolean,
    setEqualWidth: { type: Boolean, default: false },
    closestContentSelector: {
      type: String,
      default:
        '[data-dropdown-menu-target="content"], [data-dropdown-menu-sub-target="content"]',
    },
  }

  declare DOMKeydownListener: (event: KeyboardEvent) => void
  declare subMenuControllers: DropdownMenuSubController[]

  connect() {
    super.connect()
  }

  onOpen(_event: MouseEvent | KeyboardEvent) {
    // Sub menus are not connected to the DOM yet when dropdown menu is connected.
    // So we initialize them here instead of in connect().
    if (this.subMenuControllers === undefined) {
      let subMenuControllers = [] as DropdownMenuSubController[]

      const subMenus = Array.from(
        this.contentTarget.querySelectorAll(
          '[data-shadcn-phlexcomponents="dropdown-menu-sub"]',
        ),
      )

      subMenus.forEach((subMenu) => {
        const subMenuController =
          window.Stimulus.getControllerForElementAndIdentifier(
            subMenu,
            'dropdown-menu-sub',
          ) as DropdownMenuSubController

        if (subMenuController) {
          subMenuControllers.push(subMenuController)
        }
      })

      this.subMenuControllers = subMenuControllers
    }
  }

  focusItem(event: MouseEvent | KeyboardEvent) {
    const item = event.currentTarget as HTMLElement
    let items = [] as HTMLElement[]
    const content = item.closest(
      this.closestContentSelectorValue,
    ) as HTMLElement

    const isSubMenu =
      content.dataset.shadcnPhlexcomponents === 'dropdown-menu-sub-content'

    if (isSubMenu) {
      const subMenu = content.closest(
        '[data-shadcn-phlexcomponents="dropdown-menu-sub"]',
      )
      const subMenuController = this.subMenuControllers.find(
        (subMenuController) => subMenuController.element == subMenu,
      )
      if (subMenuController) {
        items = subMenuController.items
      }
    } else {
      items = this.items
    }

    let index = items.indexOf(item)

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
        if (newIndex > items.length - 1) {
          newIndex = items.length - 1
        }
      }

      items[newIndex].focus()
    } else {
      // item mouseover event
      items[index].focus()
    }

    // Close submenus on the same level
    const subMenusInContent = Array.from(
      content.querySelectorAll(
        '[data-shadcn-phlexcomponents="dropdown-menu-sub"]',
      ),
    ) as HTMLElement[]

    subMenusInContent.forEach((subMenu) => {
      const subMenuController = this.subMenuControllers.find(
        (subMenuController) => subMenuController.element == subMenu,
      )

      if (subMenuController) {
        subMenuController.closeImmediately()
      }
    })
  }

  onClose() {
    this.subMenuControllers.forEach((subMenuController) => {
      subMenuController.closeImmediately()
    })
  }

  onSelect(event: MouseEvent | KeyboardEvent) {
    if (event instanceof KeyboardEvent) {
      const key = event.key
      const item = (event.currentTarget || event.target) as HTMLElement

      // For rails button_to
      if (item && (key === 'Enter' || key === ' ')) {
        item.click()
      }
    }
  }
}
