import {
  FOCUS_DELAY,
  initFloatingUi,
  showOverlay,
  hideOverlay,
  lockScroll,
  unlockScroll,
} from '../utils'
import { Calendar } from 'vanilla-calendar-pro'
import 'imask'
import PopoverController from './popover_controller'
import dayjs from 'dayjs'
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
    'hiddenInput',
    'inputContainer',
    'calendar',
  ]

  static values = {
    date: String,
  }

  connect() {
    super.connect()

    const date = this.element.dataset.value
    this.format = this.element.dataset.format

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
      IMask(this.inputTarget, {
        mask: this.format.replace(/[^\/]/g, '0'),
      })
    }

    this.calendarTarget.removeAttribute('tabindex')
  }

  resetChanges() {
    const date = this.calendar.context.selectedDates[0]

    if (date) {
      const formattedDate = dayjs(date).format(this.format)
      this.inputTarget.value = formattedDate
    }

    this.inputContainerTarget.dataset.focus = false
  }

  changeDate(event) {
    const value = event.target.value

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
      this.contentTarget.dataset.width = contentWidth

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
    )

    const currentElement = this.contentTarget.querySelector('[aria-current]')

    if (selectedElement) {
      selectedElement.focus()
    } else if (currentElement) {
      currentElement.firstElementChild.focus()
    }
  }

  getSettings() {
    try {
      return JSON.parse(this.element.dataset.settings)
    } catch {
      return {}
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
    if (window.innerWidth <= 640) {
      unlockScroll()
    }
  }

  onClickDate(self, event) {
    const date = self.context.selectedDates[0]

    if (date) {
      this.dateValue = date
      this.close()
    } else {
      this.dateValue = ''
    }
  }

  dateValueChanged(value) {
    if (value && value.length > 0) {
      const dayjsDate = dayjs(value)
      const formattedDate = dayjsDate.format(this.format)

      if (this.hasInputTarget) this.inputTarget.value = formattedDate
      if (this.hasTriggerTextTarget) {
        this.triggerTarget.dataset.hasValue = true
        this.triggerTextTarget.textContent = formattedDate
      }

      this.hiddenInputTarget.value = dayjsDate.utc().format()
    } else {
      if (this.hasInputTarget) this.inputTarget.value = ''

      if (this.hasTriggerTextTarget) {
        this.triggerTarget.dataset.hasValue = false
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
