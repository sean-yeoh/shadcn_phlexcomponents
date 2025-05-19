import { FOCUS_DELAY, initFloatingUi, showOverlay, hideOverlay } from '../utils'
import { Calendar } from 'vanilla-calendar-pro'
import PopoverController from './popover_controller'
import dayjs from 'dayjs'
import 'imask'
import customParseFormat from 'dayjs/plugin/customParseFormat'
import utc from 'dayjs/plugin/utc'
dayjs.extend(customParseFormat)
dayjs.extend(utc)

const IMask = window.IMask

export default class extends PopoverController {
  static targets = [
    'trigger',
    'triggerText',
    'contentWrapper',
    'content',
    'input',
    'startDateHiddenInput',
    'endDateHiddenInput',
    'inputContainer',
    'calendar',
  ]

  static values = {
    startDate: String,
    endDate: String,
  }

  connect() {
    super.connect()

    this.format = this.element.dataset.format
    const settings = this.getSettings()
    settings.selectedDates = []
    const startDate = this.element.dataset.startDate
    const endDate = this.element.dataset.endDate

    this.delimiter = ' - '
    this.onClickDateListener = this.onClickDate.bind(this)

    if (startDate && dayjs(startDate).isValid()) {
      const date = dayjs(startDate).format('YYYY-MM-DD')
      settings.selectedDates.push(date)
      this.startDateValue = date
    }

    if (endDate && dayjs(endDate).isValid()) {
      const date = dayjs(endDate).format('YYYY-MM-DD')
      settings.selectedDates.push(date)
      this.endDateValue = date
    }

    this.calendar = new Calendar(this.calendarTarget, {
      enableJumpToSelectedDate: true,
      ...settings,
      onClickDate: this.onClickDateListener,
    })

    this.calendar.init()

    if (this.hasInputTarget) {
      IMask(this.inputTarget, {
        mask: `${this.format.replace(/[^\/]/g, '0')}${
          this.delimiter
        }${this.format.replace(/[^\/]/g, '0')}`,
      })
    }

    this.calendarTarget.removeAttribute('tabindex')
  }

  resetChanges() {
    const dates = this.calendar.context.selectedDates
    const startDate = dates[0]
    const endDate = dates[1]
    let datesDisplay = ''

    if (startDate) {
      datesDisplay = `${dayjs(startDate).format(this.format)}${this.delimiter}`
    }

    if (endDate) {
      datesDisplay = `${datesDisplay}${dayjs(endDate).format(this.format)}`
    }

    this.inputTarget.value = datesDisplay
    this.inputContainerTarget.dataset.focus = false
  }

  changeDate(event) {
    const value = event.target.value
    const dates = value.split(this.delimiter).filter((d) => d.length > 0)

    if (dates.length > 0) {
      const startDate = dates[0]
      const endDate = dates[1]
      let selectedDates = this.calendar.context.selectedDates

      if (dayjs(startDate, this.format, true).isValid()) {
        const dayjsDate = dayjs(value, this.format).format('YYYY-MM-DD')
        selectedDates[0] = dayjsDate
      }

      if (dayjs(endDate, this.format, true).isValid()) {
        const dayjsDate = dayjs(endDate, this.format).format('YYYY-MM-DD')
        selectedDates[1] = dayjsDate
      }

      selectedDates = selectedDates.filter((d) => !!d)

      this.calendar.set({
        selectedDates: selectedDates,
      })
      if (selectedDates[0]) {
        this.startDateValue = selectedDates[0]
      }
      if (selectedDates[1]) {
        this.endDateValue = selectedDates[1]
      }
    } else {
      this.calendar.set({
        selectedDates: [],
      })
      this.startDateValue = ''
      this.endDateValue = ''
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
      this.contentTarget.dataset.width = contentWidth

      this.contentTarget.style.maxWidth = `${contentWidth}px`
      this.contentTarget.style.minWidth = `${contentWidth}px`
    }

    showOverlay('md:hidden')
  }

  focusCalendar() {
    const focusableElements = this.contentTarget.querySelectorAll(
      'button, [href], input:not([type="hidden"]), select, textarea, [tabindex]:not([tabindex="-1"])',
    )

    const selectedElement = Array.from(focusableElements).find(
      (e) => e.ariaSelected,
    )

    const currentElement = this.contentTarget.querySelector('[aria-current]')

    if (selectedElement) {
      selectedElement.focus()
    } else if (currentElement) {
      currentElement.firstElementChild.focus()
    }
  }

  getSettings() {
    const defaultSettings = {
      type: 'multiple',
      selectionDatesMode: 'multiple-ranged',
      displayMonthsCount: 2,
      monthsToSwitch: 1,
      displayDatesOutside: false,
    }
    try {
      return {
        ...defaultSettings,
        ...JSON.parse(this.element.dataset.settings),
      }
    } catch {
      return defaultSettings
    }
  }

  onDOMKeydown(event) {
    if (!this.isOpen()) return

    const key = event.key

    const focusableElements = this.contentTarget.querySelectorAll(
      'button, [href], input:not([type="hidden"]), select, textarea, [tabindex]:not([tabindex="-1"])',
    )

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
      ['ArrowUp', 'ArrowDown', 'ArrowRight', 'ArrowLeft'].includes(key)
    ) {
      event.preventDefault()
    }
  }

  onDOMClick(event) {
    if (!this.isOpen()) return
    if (this.element.contains(event.target)) return

    // Fix bug with clicking/pressing on Month/Year button will cause popover to close
    if (
      event.target.dataset.vcMonth ||
      event.target.dataset.vcYear ||
      event.target.dataset.vcYearsYear ||
      event.target.dataset.vcMonthsMonth ||
      event.target.dataset.vcArrow ||
      event.target.dataset.vcGrid
    )
      return

    this.close()
  }

  setContainerFocus() {
    this.inputContainerTarget.dataset.focus = true
  }

  onClose() {
    hideOverlay()
  }

  onClickDate(self, event) {
    const dates = self.context.selectedDates

    if (dates.length > 0) {
      const startDate = dates[0]
      const endDate = dates[1]

      this.startDateValue = startDate

      if (endDate) {
        this.endDateValue = endDate
        this.close()
      } else {
        this.endDateValue = ''
      }
    } else {
      this.startDateValue = ''
      this.endDateValue = ''
    }
  }

  startDateValueChanged(value) {
    const endDate = this.endDateValue
    let datesDisplay = ''

    if (value && value.length > 0) {
      const dayjsDate = dayjs(value)
      const formattedDate = dayjsDate.format(this.format)
      this.startDateHiddenInputTarget.value = dayjsDate.utc().format()

      if (endDate) {
        datesDisplay = `${formattedDate}${this.delimiter}${dayjs(
          endDate,
        ).format(this.format)}`
      } else {
        datesDisplay = `${formattedDate}${this.delimiter}`
      }
    } else {
      this.startDateHiddenInputTarget.value = ''

      if (endDate) {
        datesDisplay = `${this.delimiter}${dayjs(endDate).format(this.format)}`
      }
    }

    if (this.hasInputTarget) this.inputTarget.value = datesDisplay
    if (this.hasTriggerTextTarget) {
      const hasValue = (!!value && value.length > 0) || !!endDate

      this.triggerTarget.dataset.hasValue = hasValue

      if (this.triggerTarget.dataset.placeholder && !hasValue) {
        this.triggerTextTarget.textContent =
          this.triggerTarget.dataset.placeholder
      } else {
        this.triggerTextTarget.textContent = datesDisplay
      }
    }
  }

  endDateValueChanged(value) {
    const startDate = this.startDateValue
    let datesDisplay = ''

    if (value && value.length > 0) {
      const dayjsDate = dayjs(value)
      const formattedDate = dayjsDate.format(this.format)
      this.endDateHiddenInputTarget.value = dayjsDate.utc().format()

      if (startDate) {
        datesDisplay = `${dayjs(startDate).format(this.format)}${
          this.delimiter
        }${formattedDate}`
      } else {
        datesDisplay = `${this.delimiter}${formattedDate}`
      }
    } else {
      this.endDateHiddenInputTarget.value = ''

      if (startDate) {
        datesDisplay = `${dayjs(startDate).format(this.format)}${
          this.delimiter
        }`
      }
    }

    if (this.hasInputTarget) this.inputTarget.value = datesDisplay
    if (this.hasTriggerTextTarget) {
      const hasValue = (!!value && value.length > 0) || !!startDate
      this.triggerTarget.dataset.hasValue = hasValue

      if (this.triggerTarget.dataset.placeholder && !hasValue) {
        this.triggerTextTarget.textContent =
          this.triggerTarget.dataset.placeholder
      } else {
        this.triggerTextTarget.textContent = datesDisplay
      }
    }
  }
}
