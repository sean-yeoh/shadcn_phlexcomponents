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
  limitShift,
} from '@floating-ui/dom'

// https://github.com/radix-ui/primitives/blob/13e76f08f7afdea623aebfd3c55a7e41ae8d8078/packages/react/popper/src/popper.tsx

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
    offset({ mainAxis: sideOffset + arrowHeight, alignmentAxis: alignOffset }),
    shift({
      mainAxis: true,
      crossAxis: false,
      limiter: limitShift(),
    }),
    flip({ crossAxis: 'alignment', fallbackAxisSideDirection: 'end' }),
    transformOrigin({ arrowHeight, arrowWidth }),
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
    arrowElement && arrow({ element: arrowElement, padding: 0 }),
  ]

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

export { initFloatingUi }
