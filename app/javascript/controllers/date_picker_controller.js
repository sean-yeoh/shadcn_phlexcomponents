import { Controller } from '@hotwired/stimulus'
import { Calendar } from 'vanilla-calendar-pro'
import dayjs from 'dayjs'
import customParseFormat from 'dayjs/plugin/customParseFormat'
import utc from 'dayjs/plugin/utc'
dayjs.extend(customParseFormat)
dayjs.extend(utc)

export default class extends Controller {
  static targets = ['dateInput', 'hiddenInput', 'clearButton', 'calendarIcon']

  connect() {
    this.date = this.element.dataset.value
    this.format = this.element.dataset.format
    const settings = this.getSettings()
    settings.type = 'default'

    if (this.date && dayjs(this.date).isValid()) {
      const dayjsDate = dayjs(this.date)
      const formattedDate = dayjsDate.format(this.format)
      this.dateInputTarget.value = formattedDate
      settings.selectedDates = [dayjsDate.format('YYYY-MM-DD')]
    }

    const calendar = new Calendar(this.dateInputTarget, {
      inputMode: true,
      enableJumpToSelectedDate: true,
      ...settings,
      onClickDate(self, event) {
        const date = self.context.selectedDates[0]

        const controllerElement = self.context.inputElement.closest(
          '[data-controller="shadcn-phlexcomponents--date-picker"]',
        )

        const hiddenInput = controllerElement.querySelector(
          '[data-shadcn-phlexcomponents--date-picker-target="hiddenInput"]',
        )

        if (date) {
          const formattedDate = dayjs(date).format(
            controllerElement.dataset.format,
          )
          self.context.inputElement.value = formattedDate
          controllerElement.dataset.hasValue = 'true'
          const utcDate = dayjs(date).utc().format()
          hiddenInput.value = utcDate
        } else {
          self.context.inputElement.value = ''
          controllerElement.dataset.hasValue = 'false'
          hiddenInput.value = ''
        }
      },
    })
    calendar.init()

    this.calendar = calendar
  }

  inputBlur() {
    const date = this.calendar.selectedDates[0]

    if (date) {
      const formattedDate = dayjs(date).format(this.format)
      this.dateInputTarget.value = formattedDate
    }
  }

  changeDate(event) {
    const value = event.target.value

    if (value.length > 0 && dayjs(value, this.format, true).isValid()) {
      const dayjsDate = dayjs(value, this.format)
      this.calendar.set({
        selectedDates: [dayjsDate.format('YYYY-MM-DD')],
      })
    }
  }

  closeCalendar(event) {
    const key = event.key

    if (key === 'Escape' || key === 'Tab') {
      this.calendar.hide()
    }
  }

  clear() {
    this.dateInputTarget.value = ''
    this.hiddenInputTarget.value = ''

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
