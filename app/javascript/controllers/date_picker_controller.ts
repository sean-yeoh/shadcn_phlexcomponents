import {
  initFloatingUi,
  showOverlay,
  hideOverlay,
  lockScroll,
  unlockScroll,
  ON_OPEN_FOCUS_DELAY,
  getFocusableElements,
} from '../utils'
import { Calendar, Options } from 'vanilla-calendar-pro'
import Inputmask from 'inputmask'
import PopoverController from './popover_controller'
import dayjs from 'dayjs'
import customParseFormat from 'dayjs/plugin/customParseFormat'
import utc from 'dayjs/plugin/utc'
dayjs.extend(customParseFormat)
dayjs.extend(utc)

const DAYJS_FORMAT = 'YYYY-MM-DD'

export default class extends PopoverController {
  static targets = [
    'trigger',
    'triggerText',
    'contentContainer',
    'content',
    'input',
    'hiddenInput',
    'inputContainer',
    'calendar',
  ]

  static values = { isOpen: Boolean, date: String }

  declare readonly triggerTextTarget: HTMLElement
  declare readonly inputTarget: HTMLInputElement
  declare readonly hiddenInputTarget: HTMLInputElement
  declare readonly inputContainerTarget: HTMLElement
  declare readonly calendarTarget: HTMLElement
  declare onClickDateListener: (event: any, self: any) => void
  declare format: string
  declare mask: boolean
  declare dateValue: string
  declare calendar: Calendar
  declare readonly hasInputTarget: boolean
  declare readonly hasTriggerTextTarget: boolean

  connect() {
    super.connect()
    this.onClickDateListener = this.onClickDate.bind(this)
    this.format = this.element.dataset.format || 'DD/MM/YYYY'
    this.mask = this.element.dataset.mask === 'true'

    const options = this.getOptions()

    this.calendar = new Calendar(this.calendarTarget, options)
    this.calendar.init()

    if (this.hasInputTarget && this.mask) {
      this.setupInputMask()
    }

    this.calendarTarget.removeAttribute('tabindex')
  }

  inputBlur() {
    let dateDisplay = ''
    const date = this.calendar.context.selectedDates[0]

    if (date) {
      dateDisplay = dayjs(date).format(this.format)
    }

    this.inputTarget.value = dateDisplay
    this.inputContainerTarget.dataset.focus = 'false'
  }

  inputDate(event: KeyboardEvent) {
    const value = (event.target as HTMLInputElement).value

    if (value.length === 0) {
      this.calendar.set({
        selectedDates: [],
      })
      this.dateValue = ''
    }

    if (value.length > 0 && dayjs(value, this.format, true).isValid()) {
      const dayjsDate = dayjs(value, this.format).format(DAYJS_FORMAT)
      this.calendar.set({
        selectedDates: [dayjsDate],
      })
      this.dateValue = dayjsDate
    }
  }

  setContainerFocus() {
    this.inputContainerTarget.dataset.focus = 'true'
  }

  onOpenFocusedElement() {
    const focusableElements = getFocusableElements(this.contentTarget)

    const selectedElement = Array.from(focusableElements).find(
      (e) => e.ariaSelected,
    ) as HTMLElement

    const currentElement = this.contentTarget.querySelector(
      '[aria-current]',
    ) as HTMLElement

    if (selectedElement) {
      return selectedElement
    } else if (currentElement) {
      const firstElementChild = currentElement.firstElementChild as HTMLElement
      return firstElementChild
    } else {
      return focusableElements[0]
    }
  }

  referenceElement() {
    return this.hasInputTarget ? this.inputTarget : this.triggerTarget
  }

  onOpen() {
    if (this.isMobile()) {
      lockScroll()
      showOverlay({ elementId: this.contentTarget.id })
    }

    setTimeout(() => {
      // Prevent width from changing when changing to month/year view
      if (!this.contentTarget.dataset.width) {
        const contentWidth = this.contentTarget.offsetWidth
        this.contentTarget.dataset.width = `${contentWidth}`

        this.contentTarget.style.maxWidth = `${contentWidth}px`
        this.contentTarget.style.minWidth = `${contentWidth}px`
      }

      if (this.isMobile()) {
        // Prevent position from changing when toggling between month/year on mobile
        if (!this.contentTarget.dataset.top) {
          const rect = this.contentTarget.getBoundingClientRect()
          this.contentTarget.dataset.top = `${rect.top}`
          this.contentTarget.style.top = `${rect.top}px`
          this.contentTarget.classList.remove('-translate-y-1/2', 'top-1/2')
        }
      }
    }, ON_OPEN_FOCUS_DELAY)
  }

  onClose() {
    if (this.isMobile()) {
      hideOverlay(this.contentTarget.id)
      unlockScroll()
    }
  }

  // Popover is shown as a dialog on small screens with position: fixed
  isMobile() {
    const styles = window.getComputedStyle(this.contentTarget)
    return styles.position === 'fixed'
  }

  getOptions() {
    let options = {
      type: 'default',
      enableJumpToSelectedDate: true,
      onClickDate: this.onClickDateListener,
    } as Options

    const date = this.element.dataset.value

    if (date && dayjs(date).isValid()) {
      const dayjsDate = dayjs(date).format(DAYJS_FORMAT)
      options.selectedDates = [dayjsDate]
    }

    try {
      options = {
        ...options,
        ...JSON.parse(this.element.dataset.options || ''),
      }
    } catch {
      options = options
    }

    if (options.selectedDates && options.selectedDates.length > 0) {
      this.dateValue = `${options.selectedDates[0]}`
    }

    return options
  }

  onDOMKeydown(event: KeyboardEvent) {
    if (!this.isOpenValue) return

    const key = event.key

    const focusableElements = getFocusableElements(this.contentTarget)

    const firstElement = focusableElements[0]
    const lastElement = focusableElements[focusableElements.length - 1]

    if (key === 'Escape') {
      this.close()
    } else if (key === 'Tab') {
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
    } else if (
      ['ArrowUp', 'ArrowDown', 'ArrowRight', 'ArrowLeft'].includes(key) &&
      document.activeElement != this.inputTarget
    ) {
      event.preventDefault()
    }
  }

  onClickDate(self: Calendar) {
    const date = self.context.selectedDates[0]

    if (date) {
      this.dateValue = date
      this.close()
    } else {
      this.dateValue = ''
    }
  }

  setupInputMask() {
    const im = new Inputmask(this.format.replace(/[^\/]/g, '9'), {
      showMaskOnHover: false,
    })
    im.mask(this.inputTarget)
  }

  dateValueChanged(value: string) {
    if (value && value.length > 0) {
      const dayjsDate = dayjs(value)
      const formattedDate = dayjsDate.format(this.format)

      if (this.hasInputTarget) this.inputTarget.value = formattedDate
      if (this.hasTriggerTextTarget) {
        this.triggerTarget.dataset.hasValue = 'true'
        this.triggerTextTarget.textContent = formattedDate
      }

      this.hiddenInputTarget.value = dayjsDate.utc().format()
    } else {
      if (this.hasInputTarget) this.inputTarget.value = ''

      if (this.hasTriggerTextTarget) {
        this.triggerTarget.dataset.hasValue = 'false'
        if (this.triggerTarget.dataset.placeholder) {
          this.triggerTextTarget.textContent =
            this.triggerTarget.dataset.placeholder
        } else {
          this.triggerTextTarget.textContent = ''
        }
      }

      this.hiddenInputTarget.value = ''
    }
  }
}
