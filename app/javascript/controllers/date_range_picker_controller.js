import { Controller } from '@hotwired/stimulus'
import { Calendar } from 'vanilla-calendar-pro'
import dayjs from 'dayjs'
import customParseFormat from 'dayjs/plugin/customParseFormat'
import utc from 'dayjs/plugin/utc'
dayjs.extend(customParseFormat)
dayjs.extend(utc)

// window.dayjs = dayjs
export default class extends Controller {
  static targets = [
    'startDateInput',
    'endDateInput',
    'startDateHiddenInput',
    'endDateHiddenInput',
    'clearButton',
    'calendarIcon',
  ]

  connect() {
    this.startDate = this.element.dataset.startDate
    this.endDate = this.element.dataset.endDate
    this.format = this.element.dataset.format
    this.type = this.element.dataset.type
    const settings = this.getSettings()
    settings.type = 'multiple'
    settings.selectionDatesMode = 'multiple-ranged'
    settings.displayMonthsCount = 2
    settings.monthsToSwitch = 1
    settings.displayDatesOutside = false

    if (this.startDate && dayjs(this.startDate).isValid()) {
      const dayjsDate = dayjs(this.startDate)
      const formattedDate = dayjsDate.format(this.format)
      this.startDateInputTarget.value = formattedDate
      settings.selectedDates = [dayjsDate.format('YYYY-MM-DD')]
    }

    if (this.endDate && dayjs(this.endDate).isValid()) {
      const dayjsDate = dayjs(this.endDate)
      const formattedDate = dayjsDate.format(this.format)
      this.endDateInputTarget.value = formattedDate
      settings.selectedDates = [
        ...settings.selectedDates,
        dayjsDate.format('YYYY-MM-DD'),
      ]
    }

    const calendar = new Calendar(this.element, {
      inputMode: true,
      enableJumpToSelectedDate: true,
      ...settings,
      onShow(self) {
        const controllerElement = self.context.inputElement

        const startDateInput = controllerElement.querySelector(
          '[data-shadcn-phlexcomponents--date-range-picker-target="startDateInput"]',
        )

        const endDateInput = controllerElement.querySelector(
          '[data-shadcn-phlexcomponents--date-range-picker-target="endDateInput"]',
        )

        controllerElement.dataset.focus = 'true'
        if (document.activeElement !== endDateInput) {
          startDateInput.focus()
        }
      },
      onHide(self) {
        const controllerElement = self.context.inputElement
        controllerElement.dataset.focus = 'false'
      },
      onClickDate(self, event) {
        const dates = self.context.selectedDates.filter((date) => !!date)
        const controllerElement = self.context.inputElement

        const startDateInput = controllerElement.querySelector(
          '[data-shadcn-phlexcomponents--date-range-picker-target="startDateInput"]',
        )

        const endDateInput = controllerElement.querySelector(
          '[data-shadcn-phlexcomponents--date-range-picker-target="endDateInput"]',
        )

        const startDateHiddenInput = controllerElement.querySelector(
          '[data-shadcn-phlexcomponents--date-range-picker-target="startDateHiddenInput"]',
        )

        const endDateHiddenInput = controllerElement.querySelector(
          '[data-shadcn-phlexcomponents--date-range-picker-target="endDateHiddenInput"]',
        )

        if (dates.length > 0) {
          const startDate = dates[0]
          const endDate = dates[1]

          const formattedStartDate = dayjs(startDate).format(
            controllerElement.dataset.format,
          )
          startDateInput.value = formattedStartDate
          controllerElement.dataset.hasValue = 'true'
          const utcStartDate = dayjs(startDate).utc().format()
          startDateHiddenInput.value = utcStartDate

          if (endDate) {
            const formattedEndDate = dayjs(endDate).format(
              controllerElement.dataset.format,
            )
            endDateInput.value = formattedEndDate
            const utcEndDate = dayjs(endDate).utc().format()
            endDateHiddenInput.value = utcEndDate
          } else {
            endDateInput.value = ''
            endDateHiddenInput.value = ''
          }
        } else {
          self.context.inputElement.value = ''
          endDateInput.value = ''
          controllerElement.dataset.hasValue = 'false'
          startDateHiddenInput.value = ''
          endDateHiddenInput.value = ''
        }
      },
    })
    calendar.init()

    this.calendar = calendar
  }

  openCalendar(event) {
    this.calendar.show()
  }

  closeCalendar(event) {
    const key = event.key

    switch (key) {
      case 'Tab':
        if (
          event.target.dataset[
            'shadcnPhlexcomponents-DateRangePickerTarget'
          ] === 'startDateInput'
        ) {
          if (event.shiftKey) {
            this.calendar.hide()
          }
        } else {
          if (!event.shiftKey) {
            this.calendar.hide()
          }
        }

        break
      case 'Escape':
        this.calendar.hide()
        break
      default:
        break
    }
  }

  changeDate(event) {
    const value = event.target.value
    const dates = this.calendar.selectedDates.filter((date) => !!date)

    if (
      event.target.dataset['shadcnPhlexcomponents-DateRangePickerTarget'] ===
      'startDateInput'
    ) {
      if (dayjs(value, this.format, true).isValid()) {
        const dayjsDate = dayjs(value, this.format)
        dates[0] = dayjsDate.format('YYYY-MM-DD')

        this.calendar.set({
          selectedDates: dates,
        })
        this.element.dataset.hasValue = 'true'
      }
    } else {
      if (dayjs(value, this.format, true).isValid()) {
        const dayjsDate = dayjs(value, this.format)
        dates[1] = dayjsDate.format('YYYY-MM-DD')

        this.calendar.set({
          selectedDates: dates,
        })
        this.element.dataset.hasValue = 'true'
      }
    }
  }

  openCalendar() {
    setTimeout(() => {
      this.calendar.show()
    }, 125)
  }

  clear() {
    this.startDateInputTarget.value = ''

    if (this.hasEndDateInputTarget) {
      this.endDateInputTarget.value = ''
    }

    this.calendar.set({
      selectedDates: [],
    })

    this.element.dataset.hasValue = 'false'
  }

  showClearButton() {
    if (this.element.dataset.hasValue === 'true') {
      this.clearButtonTarget.classList.remove('!hidden')
      this.calendarIconTarget.classList.add('hidden')
    }
  }

  hideClearButton() {
    this.clearButtonTarget.classList.add('!hidden')
    this.calendarIconTarget.classList.remove('hidden')
  }

  getSettings() {
    try {
      return JSON.parse(this.element.dataset.settings)
    } catch {
      return {}
    }
  }
}
