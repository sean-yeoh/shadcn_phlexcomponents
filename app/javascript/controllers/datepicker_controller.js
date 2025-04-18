import { Controller } from '@hotwired/stimulus'
import { Calendar } from 'vanilla-calendar-pro'
import { getDateString, parseDates } from 'vanilla-calendar-pro/utils'
import dayjs from 'dayjs'

export default class extends Controller {
  connect() {
    this.date = new Date(this.element.dataset.value)
    this.format = this.element.dataset.format
    const settings = this.getSettings()

    if (!isNaN(this.date.getTime())) {
      const dateString = getDateString(this.date)
      const formattedDate = this.format
        ? dayjs(this.date).format(this.format)
        : this.date.toLocaleDateString()
      this.element.value = formattedDate
      settings.selectedDates = [dateString]
    }

    const calendar = new Calendar(this.element, {
      inputMode: true,
      enableJumpToSelectedDate: true,
      ...settings,
      onClickDate(self, event) {
        const date = self.context.selectedDates[0]
        const formattedDate = self.context.inputElement.dataset.format
          ? dayjs(date).format(self.context.inputElement.dataset.format)
          : new Date(date).toLocaleDateString()

        self.context.inputElement.value = formattedDate
        self.hide()
      },
    })
    calendar.init()

    this.calendar = calendar
  }

  getSettings() {
    try {
      return JSON.parse(this.element.dataset.settings)
    } catch {
      return {}
    }
  }
}
