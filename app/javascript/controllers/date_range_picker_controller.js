import { DatePickerController } from "./date_picker_controller";
import dayjs from "dayjs";
import customParseFormat from "dayjs/plugin/customParseFormat";
import utc from "dayjs/plugin/utc";
dayjs.extend(customParseFormat);
dayjs.extend(utc);
const DELIMITER = " - ";
const DAYJS_FORMAT = "YYYY-MM-DD";
const DateRangePickerController = class extends DatePickerController {
  static name = "date-range-picker";
  // targets
  static targets = [
    "trigger",
    "triggerText",
    "contentContainer",
    "content",
    "input",
    "hiddenInput",
    "endHiddenInput",
    "inputContainer",
    "calendar",
    "overlay",
  ];
  // values
  static values = {
    isOpen: Boolean,
    date: String,
    endDate: String,
  };
  inputBlur() {
    const dates = this.calendar.context.selectedDates;
    const startDate = dates[0];
    const endDate = dates[1];
    let datesDisplay = "";
    if (startDate) {
      datesDisplay = `${dayjs(startDate).format(this.format)}${DELIMITER}`;
    }
    if (endDate) {
      datesDisplay = `${datesDisplay}${dayjs(endDate).format(this.format)}`;
    }
    this.inputTarget.value = datesDisplay;
    this.inputContainerTarget.dataset.focus = "false";
  }
  inputDate(event) {
    const value = event.target.value;
    const dates = value.split(DELIMITER).filter((d) => d.length > 0);
    if (dates.length > 0) {
      const startDate = dates[0];
      const endDate = dates[1];
      let selectedDates = this.calendar.context.selectedDates;
      if (dayjs(startDate, this.format, true).isValid()) {
        const dayjsDate = dayjs(value, this.format).format(DAYJS_FORMAT);
        selectedDates[0] = dayjsDate;
      }
      if (dayjs(endDate, this.format, true).isValid()) {
        const dayjsDate = dayjs(endDate, this.format).format(DAYJS_FORMAT);
        selectedDates[1] = dayjsDate;
      }
      selectedDates = selectedDates.filter((d) => !!d);
      this.calendar.set({
        selectedDates: selectedDates,
      });
      if (selectedDates[0]) {
        this.dateValue = selectedDates[0];
      }
      if (selectedDates[1]) {
        this.endDateValue = selectedDates[1];
      }
    } else {
      this.calendar.set({
        selectedDates: [],
      });
      this.dateValue = "";
      this.endDateValue = "";
    }
  }
  dateValueChanged(value) {
    this.onClickDateListener = this.onClickDate.bind(this);
    const endDate = this.endDateValue;
    let datesDisplay = "";
    if (value && value.length > 0) {
      const dayjsDate = dayjs(value);
      const formattedDate = dayjsDate.format(this.format);
      this.hiddenInputTarget.value = dayjsDate.utc().format();
      if (endDate) {
        datesDisplay = `${formattedDate}${DELIMITER}${dayjs(endDate).format(this.format)}`;
      } else {
        datesDisplay = `${formattedDate}${DELIMITER}`;
      }
    } else {
      this.hiddenInputTarget.value = "";
      if (endDate) {
        datesDisplay = `${DELIMITER}${dayjs(endDate).format(this.format)}`;
      }
    }
    if (this.hasInputTarget) this.inputTarget.value = datesDisplay;
    if (this.hasTriggerTextTarget) {
      const hasValue = (!!value && value.length > 0) || !!endDate;
      this.triggerTarget.dataset.hasValue = `${hasValue}`;
      if (this.triggerTarget.dataset.placeholder && !hasValue) {
        this.triggerTextTarget.textContent =
          this.triggerTarget.dataset.placeholder;
      } else {
        this.triggerTextTarget.textContent = datesDisplay;
      }
    }
  }
  endDateValueChanged(value) {
    const startDate = this.dateValue;
    let datesDisplay = "";
    if (value && value.length > 0) {
      const dayjsDate = dayjs(value);
      const formattedDate = dayjsDate.format(this.format);
      this.endHiddenInputTarget.value = dayjsDate.utc().format();
      if (startDate) {
        datesDisplay = `${dayjs(startDate).format(this.format)}${DELIMITER}${formattedDate}`;
      } else {
        datesDisplay = `${DELIMITER}${formattedDate}`;
      }
    } else {
      this.endHiddenInputTarget.value = "";
      if (startDate) {
        datesDisplay = `${dayjs(startDate).format(this.format)}${DELIMITER}`;
      }
    }
    if (this.hasInputTarget) this.inputTarget.value = datesDisplay;
    if (this.hasTriggerTextTarget) {
      const hasValue = (!!value && value.length > 0) || !!startDate;
      this.triggerTarget.dataset.hasValue = `${hasValue}`;
      if (this.triggerTarget.dataset.placeholder && !hasValue) {
        this.triggerTextTarget.textContent =
          this.triggerTarget.dataset.placeholder;
      } else {
        this.triggerTextTarget.textContent = datesDisplay;
      }
    }
  }
  getOptions() {
    let options = {
      type: "multiple",
      selectionDatesMode: "multiple-ranged",
      displayMonthsCount: 2,
      monthsToSwitch: 1,
      displayDatesOutside: false,
      enableJumpToSelectedDate: true,
      onClickDate: this.onClickDateListener,
    };
    const selectedDates = [];
    const startDate = this.element.dataset.value;
    const endDate = this.element.dataset.endValue;
    if (startDate && dayjs(startDate).isValid()) {
      const date = dayjs(startDate).format(DAYJS_FORMAT);
      selectedDates.push(date);
    }
    if (endDate && dayjs(endDate).isValid()) {
      const date = dayjs(endDate).format(DAYJS_FORMAT);
      selectedDates.push(date);
    }
    options.selectedDates = selectedDates;
    try {
      options = {
        ...options,
        ...JSON.parse(this.element.dataset.options || ""),
      };
    } catch {
      // noop
    }
    if (options.selectedDates && options.selectedDates.length > 0) {
      this.dateValue = `${options.selectedDates[0]}`;
      if (options.selectedDates[1]) {
        this.endDateValue = `${options.selectedDates[1]}`;
      }
    }
    return options;
  }
  onClickDate(self) {
    const dates = self.context.selectedDates;
    if (dates.length > 0) {
      const startDate = dates[0];
      const endDate = dates[1];
      this.dateValue = startDate;
      if (endDate) {
        this.endDateValue = endDate;
        this.close();
      } else {
        this.endDateValue = "";
      }
    } else {
      this.dateValue = "";
      this.endDateValue = "";
    }
  }
  setupInputMask() {
    const pattern = this.format.replace(/[^\/]/g, "9");
    const im = new Inputmask(`${pattern}${DELIMITER}${pattern}`, {
      showMaskOnHover: false,
    });
    im.mask(this.inputTarget);
  }
};
export { DateRangePickerController };
