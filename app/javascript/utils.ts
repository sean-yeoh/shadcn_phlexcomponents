import {
  computePosition,
  flip,
  shift,
  offset,
  autoUpdate,
  size,
  Placement,
  Middleware,
  arrow,
} from '@floating-ui/dom'

import type { DropdownMenu } from './controllers/dropdown_menu_controller'
import type { Select } from './controllers/select_controller'
import type { Popover } from './controllers/popover_controller'
import type { Command } from './controllers/command_controller'
import type { Combobox } from './controllers/combobox_controller'
import type { Dialog } from './controllers/dialog_controller'
import type { AlertDialog } from './controllers/alert_dialog_controller'
import type { HoverCard } from './controllers/hover_card_controller'
import type { Tooltip } from './controllers/tooltip_controller'
import type { DatePicker } from './controllers/date_picker_controller'
import type { DateRangePicker } from './controllers/date_range_picker_controller'

const ANIMATION_OUT_DELAY = 100
const ON_OPEN_FOCUS_DELAY = 100
const ON_CLOSE_FOCUS_DELAY = 50

const OPPOSITE_SIDE = {
  top: 'bottom',
  right: 'left',
  bottom: 'top',
  left: 'right',
}

const ARROW_TRANSFORM_ORIGIN = {
  top: '',
  right: '0 0',
  bottom: 'center 0',
  left: '100% 0',
}

const ARROW_TRANSFORM = {
  top: 'translateY(100%)',
  right: 'translateY(50%) rotate(90deg) translateX(-50%)',
  bottom: `rotate(180deg)`,
  left: 'translateY(50%) rotate(-90deg) translateX(50%)',
}

const getScrollbarWidth = () => {
  // Create a temporary div container and append it into the body
  const outer = document.createElement('div')
  outer.style.visibility = 'hidden'
  outer.style.overflow = 'scroll' // force scrollbars
  outer.style.width = '100px'
  outer.style.position = 'absolute'
  outer.style.top = '-9999px'
  document.body.appendChild(outer)

  // Create an inner div and place it inside the outer div
  const inner = document.createElement('div')
  inner.style.width = '100%'
  outer.appendChild(inner)

  // Calculate the scrollbar width
  const scrollbarWidth = outer.offsetWidth - inner.offsetWidth

  // Clean up
  outer.remove()

  return scrollbarWidth
}

const lockScroll = (contentId: string) => {
  if (window.innerHeight < document.documentElement.scrollHeight) {
    document.body.dataset.scrollLocked = '1'
    document.body.classList.add(
      'data-[scroll-locked]:pointer-events-none',
      'data-[scroll-locked]:!overflow-hidden',
      'data-[scroll-locked]:!relative',
      'data-[scroll-locked]:px-0',
      'data-[scroll-locked]:pt-0',
      'data-[scroll-locked]:ml-0',
      'data-[scroll-locked]:mt-0',
    )
    document.body.style.marginRight = `${getScrollbarWidth()}px`

    const contentIdsString =
      document.body.dataset.scrollLockedContentIds || '[]'
    const contentIds = JSON.parse(contentIdsString)

    contentIds.push(contentId)
    document.body.dataset.scrollLockedContentIds = JSON.stringify(contentIds)
  }
}

const unlockScroll = (contentId: string) => {
  const contentIdsString = document.body.dataset.scrollLockedContentIds || '[]'
  const contentIds = JSON.parse(contentIdsString)
  const newContentIds = contentIds.filter((id: string) => id !== contentId)
  document.body.dataset.scrollLockedContentIds = JSON.stringify(newContentIds)

  if (newContentIds.length === 0) {
    delete document.body.dataset.scrollLocked
    document.body.classList.remove(
      'data-[scroll-locked]:pointer-events-none',
      'data-[scroll-locked]:!overflow-hidden',
      'data-[scroll-locked]:!relative',
      'data-[scroll-locked]:px-0',
      'data-[scroll-locked]:pt-0',
      'data-[scroll-locked]:ml-0',
      'data-[scroll-locked]:mt-0',
    )

    document.body.style.marginRight = ''
  }
}

const initFloatingUi = ({
  referenceElement,
  floatingElement,
  side = 'bottom',
  align = 'center',
  sideOffset = 0,
  alignOffset = 0,
  arrowElement,
}: {
  referenceElement: HTMLElement
  floatingElement: HTMLElement
  side?: string
  align?: string
  sideOffset?: number
  alignOffset?: number
  offsetPx?: number
  arrowElement?: HTMLElement
}) => {
  let placement = `${side}-${align}`
  placement = placement.replace(/-center/g, '')

  let arrowHeight = 0,
    arrowWidth = 0

  if (arrowElement) {
    const rect = arrowElement.getBoundingClientRect()
    arrowWidth = rect.width
    arrowHeight = rect.height
  }

  const middleware = [
    transformOrigin({ arrowHeight, arrowWidth }),
    offset({ mainAxis: sideOffset, alignmentAxis: alignOffset }),
    size({
      apply: ({ elements, rects, availableWidth, availableHeight }) => {
        const { width: anchorWidth, height: anchorHeight } = rects.reference
        const contentStyle = elements.floating.style
        contentStyle.setProperty(
          '--radix-popper-available-width',
          `${availableWidth}px`,
        )
        contentStyle.setProperty(
          '--radix-popper-available-height',
          `${availableHeight}px`,
        )
        contentStyle.setProperty(
          '--radix-popper-anchor-width',
          `${anchorWidth}px`,
        )
        contentStyle.setProperty(
          '--radix-popper-anchor-height',
          `${anchorHeight}px`,
        )
      },
    }),
  ]

  const flipMiddleware = flip({
    // Ensure we flip to the perpendicular axis if it doesn't fit
    // on narrow viewports.
    crossAxis: 'alignment',
    fallbackAxisSideDirection: 'end', // or 'start'
  })
  const shiftMiddleware = shift()

  // Prioritize flip over shift for edge-aligned placements only.
  if (placement.includes('-')) {
    middleware.push(flipMiddleware, shiftMiddleware)
  } else {
    middleware.push(shiftMiddleware, flipMiddleware)
  }

  if (arrowElement) {
    middleware.push(arrow({ element: arrowElement, padding: 0 }))
  }

  return autoUpdate(referenceElement, floatingElement, () => {
    computePosition(referenceElement, floatingElement, {
      placement: placement as Placement,
      strategy: 'fixed',
      middleware,
    }).then(({ middlewareData, x, y }) => {
      const arrowX = middlewareData.arrow?.x
      const arrowY = middlewareData.arrow?.y
      const cannotCenterArrow = middlewareData.arrow?.centerOffset !== 0

      floatingElement.style.setProperty(
        '--radix-popper-transform-origin',
        `${middlewareData.transformOrigin?.x} ${middlewareData.transformOrigin?.y}`,
      )
      if (arrowElement) {
        const baseSide = OPPOSITE_SIDE[side as keyof typeof OPPOSITE_SIDE]

        const arrowStyle = {
          position: 'absolute',
          left: arrowX ? `${arrowX}px` : undefined,
          top: arrowY ? `${arrowY}px` : undefined,
          [baseSide]: 0,
          transformOrigin:
            ARROW_TRANSFORM_ORIGIN[side as keyof typeof ARROW_TRANSFORM_ORIGIN],
          transform: ARROW_TRANSFORM[side as keyof typeof ARROW_TRANSFORM],
          visibility: cannotCenterArrow ? 'hidden' : undefined,
        }

        Object.assign(arrowElement.style, arrowStyle)
      }
      Object.assign(floatingElement.style, {
        left: `${x}px`,
        top: `${y}px`,
      })
    })
  })
}

const transformOrigin = (options: {
  arrowWidth: number
  arrowHeight: number
}): Middleware => {
  return {
    name: 'transformOrigin',
    options,
    fn(data) {
      const { placement, rects, middlewareData } = data
      const cannotCenterArrow = middlewareData.arrow?.centerOffset !== 0
      const isArrowHidden = cannotCenterArrow
      const arrowWidth = isArrowHidden ? 0 : options.arrowWidth
      const arrowHeight = isArrowHidden ? 0 : options.arrowHeight

      const [placedSide, placedAlign] = getSideAndAlignFromPlacement(placement)
      const noArrowAlign = { start: '0%', center: '50%', end: '100%' }[
        placedAlign
      ] as string

      const arrowXCenter = (middlewareData.arrow?.x ?? 0) + arrowWidth / 2
      const arrowYCenter = (middlewareData.arrow?.y ?? 0) + arrowHeight / 2

      let x = ''
      let y = ''

      if (placedSide === 'bottom') {
        x = isArrowHidden ? noArrowAlign : `${arrowXCenter}px`
        y = `${-arrowHeight}px`
      } else if (placedSide === 'top') {
        x = isArrowHidden ? noArrowAlign : `${arrowXCenter}px`
        y = `${rects.floating.height + arrowHeight}px`
      } else if (placedSide === 'right') {
        x = `${-arrowHeight}px`
        y = isArrowHidden ? noArrowAlign : `${arrowYCenter}px`
      } else if (placedSide === 'left') {
        x = `${rects.floating.width + arrowHeight}px`
        y = isArrowHidden ? noArrowAlign : `${arrowYCenter}px`
      }
      return { data: { x, y } }
    },
  }
}

function getSideAndAlignFromPlacement(placement: Placement) {
  const [side, align = 'center'] = placement.split('-')
  return [side, align] as const
}

const focusTrigger = (triggerTarget: HTMLElement) => {
  setTimeout(() => {
    if (triggerTarget.dataset.asChild === 'false') {
      const childElement = triggerTarget.firstElementChild as HTMLElement

      if (childElement) {
        childElement.focus()
      }
    } else {
      triggerTarget.focus()
    }
  }, ON_CLOSE_FOCUS_DELAY)
}

const focusElement = (element?: HTMLElement | null) => {
  setTimeout(() => {
    if (element) {
      element.focus()
    }
  }, ON_OPEN_FOCUS_DELAY)
}

const getFocusableElements = (container: HTMLElement) => {
  return Array.from(
    container.querySelectorAll(
      'button, [href], input:not([type="hidden"]), select:not([tabindex="-1"]), textarea, [tabindex]:not([tabindex="-1"])',
    ),
  ) as HTMLElement[]
}

const getSameLevelItems = ({
  content,
  items,
  closestContentSelector,
}: {
  content: HTMLElement
  items: HTMLElement[]
  closestContentSelector: string
}) => {
  const sameLevelItems = [] as HTMLElement[]

  items.forEach((i) => {
    if (
      i.closest(closestContentSelector) === content &&
      i.dataset.disabled === undefined
    ) {
      sameLevelItems.push(i)
    }
  })

  return sameLevelItems
}

const showContent = ({
  trigger,
  content,
  contentContainer,
  setEqualWidth,
  overlay,
}: {
  trigger?: HTMLElement
  content: HTMLElement
  contentContainer: HTMLElement
  overlay?: HTMLElement
  setEqualWidth?: boolean
  appendToBody?: boolean
}) => {
  contentContainer.style.display = ''

  if (trigger) {
    if (setEqualWidth) {
      const triggerWidth = trigger.offsetWidth
      const contentContainerWidth = contentContainer.offsetWidth

      if (contentContainerWidth < triggerWidth) {
        contentContainer.style.width = `${triggerWidth}px`
      }
    }

    trigger.ariaExpanded = 'true'
    trigger.dataset.state = 'open'
  }

  content.dataset.state = 'open'

  if (overlay) {
    overlay.style.display = ''
    overlay.dataset.state = 'open'
    lockScroll(content.id)
  }
}

const hideContent = ({
  trigger,
  content,
  contentContainer,
  overlay,
}: {
  trigger?: HTMLElement
  content: HTMLElement
  contentContainer: HTMLElement
  overlay?: HTMLElement
}) => {
  if (trigger) {
    trigger.ariaExpanded = 'false'
    trigger.dataset.state = 'closed'
  }

  content.dataset.state = 'closed'

  setTimeout(() => {
    contentContainer.style.display = 'none'

    if (overlay) {
      overlay.style.display = 'none'
      overlay.dataset.state = 'closed'
      unlockScroll(content.id)
    }
  }, ANIMATION_OUT_DELAY)
}

const getStimulusInstance = <T>(
  controller: string,
  element: HTMLElement | null,
) => {
  if (!element) return

  return window.Stimulus.getControllerForElementAndIdentifier(
    element,
    controller,
  ) as T
}

type NestedComponent =
  | DropdownMenu
  | Select
  | Popover
  | Command
  | Combobox
  | Dialog
  | AlertDialog
  | HoverCard
  | Tooltip
  | DatePicker
  | DateRangePicker
const anyNestedComponentsOpen = (element: HTMLElement) => {
  const components = [] as NestedComponent[]

  const componentNames = [
    'dialog',
    'alert-dialog',
    'dropdown-menu',
    'popover',
    'select',
    'combobox',
    'command',
    'hover-card',
    'tooltip',
    'date-picker',
    'date-range-picker',
  ]

  componentNames.forEach((name) => {
    const triggers = Array.from(
      element.querySelectorAll(
        `[data-shadcn-phlexcomponents="${name}-trigger"]`,
      ),
    )

    const controllerElements = Array.from(
      element.querySelectorAll(`[data-controller="${name}"]`),
    ) as HTMLElement[]

    controllerElements.forEach((controller) => {
      const stimulusInstance = getStimulusInstance<NestedComponent>(
        name,
        controller,
      )

      if (stimulusInstance) {
        components.push(stimulusInstance)
      }
    })

    triggers.forEach((trigger) => {
      const stimulusInstance = getStimulusInstance<NestedComponent>(
        name,
        document.querySelector(`#${trigger.getAttribute('aria-controls')}`),
      )

      if (stimulusInstance) {
        components.push(stimulusInstance)
      }
    })
  })

  return components.some((c) => c.isOpenValue)
}

const onClickOutside = (
  controller: DropdownMenu | Select | Popover | Combobox,
  event: MouseEvent,
) => {
  const target = event.target as HTMLElement
  // Let trigger handle state
  if (target === controller.triggerTarget) return
  if (controller.triggerTarget.contains(target)) return

  controller.close()
}

const setGroupLabelsId = (controller: Select | Command | Combobox) => {
  controller.groupTargets.forEach((g) => {
    const label = g.querySelector(
      `[data-shadcn-phlexcomponents="${controller.identifier}-label"]`,
    ) as HTMLElement

    if (label) {
      label.id = g.getAttribute('aria-labelledby') as string
    }
  })
}

const getNextEnabledIndex = ({
  items,
  currentIndex,
  wrapAround,
  filterFn,
}: {
  items: HTMLElement[]
  currentIndex: number
  wrapAround: boolean
  filterFn?: (item: HTMLElement) => boolean
}) => {
  let newIndex = null as number | null

  if (filterFn) {
    newIndex = items.findIndex(
      (item, index) => index > currentIndex && filterFn(item),
    )

    if (newIndex === -1) {
      newIndex = currentIndex
    }
  } else {
    newIndex = currentIndex + 1
  }

  if (newIndex > items.length - 1) {
    if (wrapAround) {
      newIndex = 0
    } else {
      newIndex = items.length - 1
    }
  }

  return newIndex
}

const getPreviousEnabledIndex = ({
  items,
  currentIndex,
  wrapAround,
  filterFn,
}: {
  items: HTMLElement[]
  currentIndex: number
  wrapAround: boolean
  filterFn?: (item: HTMLElement) => boolean
}) => {
  let newIndex = null as number | null

  if (filterFn) {
    newIndex = items.findLastIndex(
      (item, index) => index < currentIndex && filterFn(item),
    )

    if (newIndex === -1) {
      newIndex = currentIndex
    }
  } else {
    newIndex = currentIndex - 1
  }

  if (newIndex < 0) {
    if (wrapAround) {
      newIndex = items.length - 1
    } else {
      newIndex = 0
    }
  }

  return newIndex
}

const handleTabNavigation = (element: HTMLElement, event: KeyboardEvent) => {
  const focusableElements = getFocusableElements(element)
  const firstElement = focusableElements[0]
  const lastElement = focusableElements[focusableElements.length - 1]

  // If Shift + Tab pressed on first element, go to last element
  if (event.shiftKey && document.activeElement === firstElement) {
    event.preventDefault()
    lastElement.focus()
  }
  // If Tab pressed on last element, go to first element
  else if (!event.shiftKey && document.activeElement === lastElement) {
    event.preventDefault()
    firstElement.focus()
  }
}

export {
  ANIMATION_OUT_DELAY,
  ON_CLOSE_FOCUS_DELAY,
  ON_OPEN_FOCUS_DELAY,
  lockScroll,
  unlockScroll,
  initFloatingUi,
  focusTrigger,
  focusElement,
  getFocusableElements,
  getSameLevelItems,
  showContent,
  hideContent,
  getStimulusInstance,
  anyNestedComponentsOpen,
  onClickOutside,
  setGroupLabelsId,
  getNextEnabledIndex,
  getPreviousEnabledIndex,
  handleTabNavigation,
}
