import {
  computePosition,
  flip,
  shift,
  offset,
  autoUpdate,
} from '@floating-ui/dom'

const ANIMATION_OUT_DELAY = 125
const FOCUS_DELAY = 100

const getScrollbarWidth = () => {
  // Create a temporary div container and append it into the body
  const outer = document.createElement('div')
  outer.style.visibility = 'hidden'
  outer.style.overflow = 'scroll' // force scrollbars
  outer.style.msOverflowStyle = 'scrollbar' // needed for some older versions of Edge
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

const showOverlay = (classNames = '') => {
  const element = document.createElement('div')
  let defaultClassNames = [
    'fixed',
    'inset-0',
    'z-50',
    'bg-black/80',
    'data-[state=open]:animate-in',
    'data-[state=closed]:animate-out',
    'data-[state=closed]:fade-out-0',
    'data-[state=open]:fade-in-0',
    'pointer-events-auto',
  ]
  defaultClassNames = defaultClassNames.concat(
    classNames.split(' ').filter((c) => !!c),
  )

  element.classList.add(...defaultClassNames)
  element.dataset.state = 'open'
  element.dataset.shadcnPhlexcomponentsOverlay = true
  element.ariaHidden = true
  document.body.appendChild(element)
}

const hideOverlay = () => {
  const element = document.querySelector(
    '[data-shadcn-phlexcomponents-overlay]',
  )

  if (element) {
    element.dataset.state = 'closed'

    setTimeout(() => {
      element.remove()
    }, ANIMATION_OUT_DELAY)
  }
}

const lockScroll = () => {
  if (window.innerHeight < document.documentElement.scrollHeight) {
    document.body.dataset.scrollLocked = 1
    const style = getComputedStyle(document.body)
    const originalMarginRight = style.marginRight
    document.body.dataset.marginRight = originalMarginRight
    document.body.style.marginRight = `${getScrollbarWidth()}px`
  }
}

const unlockScroll = () => {
  if (document.body.dataset.scrollLocked) {
    delete document.body.dataset.scrollLocked
    const originalMarginRight = document.body.dataset.marginRight

    if (parseInt(originalMarginRight) === 0) {
      document.body.style.marginRight = ''
    } else {
      document.body.style.marginRight = originalMarginRight
    }

    delete document.body.dataset.marginRight
  }
}

const addInert = (ignoredElements = []) => {
  Array.from(document.body.children)
    .filter((el) => !ignoredElements.includes(el))
    .forEach((el) => el.setAttribute('inert', ''))
}

const removeInert = () => {
  Array.from(document.body.children)
    .filter((el) => el.hasAttribute('inert'))
    .forEach((el) => el.removeAttribute('inert'))
}

const openWithOverlay = (ignoredElements = []) => {
  showOverlay()
  lockScroll()
  addInert(ignoredElements)
}

const closeWithOverlay = () => {
  hideOverlay()
  unlockScroll()
  removeInert()
}

const hideOnEsc = {
  name: 'hideOnEsc',
  defaultValue: true,
  fn({ hide }) {
    function onKeyDown(event) {
      if (event.keyCode === 27) {
        hide()
      }
    }

    return {
      onShow() {
        document.addEventListener('keydown', onKeyDown)
      },
      onHide() {
        document.removeEventListener('keydown', onKeyDown)
      },
    }
  },
}

const initFloatingUi = (referenceElement, floatingElement, side) => {
  return autoUpdate(referenceElement, floatingElement, () => {
    computePosition(referenceElement, floatingElement, {
      placement: side,
      strategy: 'fixed',
      middleware: [flip(), shift(), offset(4)],
    }).then(({ x, y }) => {
      Object.assign(floatingElement.style, {
        left: `${x}px`,
        top: `${y}px`,
      })
    })
  })
}

const focusTrigger = (triggerTarget) => {
  setTimeout(() => {
    if (triggerTarget.dataset.asChild === 'false') {
      triggerTarget.firstElementChild.focus()
    } else {
      triggerTarget.focus()
    }
  }, FOCUS_DELAY)
}

export {
  ANIMATION_OUT_DELAY,
  FOCUS_DELAY,
  hideOnEsc,
  showOverlay,
  hideOverlay,
  lockScroll,
  unlockScroll,
  addInert,
  removeInert,
  openWithOverlay,
  closeWithOverlay,
  initFloatingUi,
  focusTrigger,
}
