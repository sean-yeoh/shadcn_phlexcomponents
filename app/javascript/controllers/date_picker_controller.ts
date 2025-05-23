import {
  FOCUS_DELAY,
  initFloatingUi,
  showOverlay,
  hideOverlay,
  lockScroll,
  unlockScroll,
} from '../utils'
import { Calendar } from 'vanilla-calendar-pro'
import Inputmask from 'inputmask'
import PopoverController from './popover_controller'
import dayjs from 'dayjs'
import customParseFormat from 'dayjs/plugin/customParseFormat'
import utc from 'dayjs/plugin/utc'
dayjs.extend(customParseFormat)
dayjs.extend(utc)

export default class extends PopoverController {
  static targets = [
    'trigger',
    'triggerText',
    'contentWrapper',
    'content',
    'input',
    'hiddenInput',
    'inputContainer',
    'calendar',
  ]

  static values = {
    date: String,
  }

  declare readonly triggerTarget: HTMLElement
  declare readonly triggerTextTarget: HTMLElement
  declare readonly contentWrapperTarget: HTMLElement
  declare readonly contentTarget: HTMLElement
  declare readonly inputTarget: HTMLInputElement
  declare readonly hiddenInputTarget: HTMLInputElement
  declare readonly inputContainerTarget: HTMLElement
  declare readonly calendarTarget: HTMLElement
  declare onClickDateListener: (event: any, self: any) => void
  declare format: string
  declare dateValue: string
  declare calendar: Calendar
  declare readonly hasInputTarget: boolean
  declare readonly hasTriggerTextTarget: boolean

  connect() {
    super.connect()

    const date = this.element.dataset.value
    this.format = this.element.dataset.format || 'YYYY-MM-DD'

    const settings = this.getSettings()
    settings.type = 'default'

    this.onClickDateListener = this.onClickDate.bind(this)

    if (date && dayjs(date).isValid()) {
      const dayjsDate = dayjs(date).format('YYYY-MM-DD')
      settings.selectedDates = [dayjsDate]
      this.dateValue = dayjsDate
    }

    this.calendar = new Calendar(this.calendarTarget, {
      enableJumpToSelectedDate: true,
      ...settings,
      onClickDate: this.onClickDateListener,
    })

    this.calendar.init()

    if (this.hasInputTarget) {
      const im = new Inputmask(this.format.replace(/[^\/]/g, '9'), {
        showMaskOnHover: false,
      })
      im.mask(this.inputTarget)
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
      const dayjsDate = dayjs(value, this.format).format('YYYY-MM-DD')
      this.calendar.set({
        selectedDates: [dayjsDate],
      })
      this.dateValue = dayjsDate
    }
  }

  onOpen() {
    setTimeout(() => {
      this.focusCalendar()
    }, FOCUS_DELAY * 1.5)

    this.cleanup = initFloatingUi(
      this.hasInputTarget ? this.inputTarget : this.triggerTarget,
      this.contentWrapperTarget,
      'bottom-start',
    )

    if (!this.contentTarget.dataset.width) {
      const contentWidth = this.contentTarget.offsetWidth
      this.contentTarget.dataset.width = `${contentWidth}`

      this.contentTarget.style.maxWidth = `${contentWidth}px`
      this.contentTarget.style.minWidth = `${contentWidth}px`
    }

    if (window.innerWidth <= 640) {
      lockScroll()
    }
    showOverlay('md:hidden')
  }

  focusCalendar() {
    const focusableElements = this.contentTarget.querySelectorAll(
      'button, [href], input:not([type="hidden"]), select, textarea, [tabindex]:not([tabindex="-1"])',
    )

    const selectedElement = Array.from(focusableElements).find(
      (e) => e.ariaSelected,
    ) as HTMLElement

    const currentElement = this.contentTarget.querySelector(
      '[aria-current]',
    ) as HTMLElement

    if (selectedElement) {
      selectedElement.focus()
    } else if (currentElement) {
      const firstElementChild = currentElement.firstElementChild as HTMLElement
      firstElementChild.focus()
    }
  }

  getSettings() {
    try {
      return JSON.parse(this.element.dataset.settings || '')
    } catch {
      return {}
    }
  }

  onDOMKeydown(event: KeyboardEvent) {
    if (!this.isOpen()) return

    const key = event.key

    const focusableElements = Array.from(
      this.contentTarget.querySelectorAll(
        'button, [href], input:not([type="hidden"]), select, textarea, [tabindex]:not([tabindex="-1"])',
      ),
    ) as HTMLElement[]

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

  onDOMClick(event: MouseEvent) {
    if (!this.isOpen()) return
    const target = event.target as HTMLElement
    if (this.element.contains(target)) return

    // Fix bug with clicking/pressing on Month/Year button will cause popover to close
    // Fix bug with clicking/pressing on Month/Year button will cause popover to close
    if (
      target.dataset.vcMonth ||
      target.dataset.vcYear ||
      target.dataset.vcYearsYear ||
      target.dataset.vcMonthsMonth ||
      target.dataset.vcArrow ||
      target.dataset.vcGrid
    )
      return

    this.close()
  }

  setContainerFocus() {
    this.inputContainerTarget.dataset.focus = 'true'
  }

  onClose() {
    hideOverlay()
    if (window.innerWidth <= 640) {
      unlockScroll()
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
