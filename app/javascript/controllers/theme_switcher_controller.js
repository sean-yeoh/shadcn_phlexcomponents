import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  initialize() {
    document.documentElement.classList.toggle(
      'dark',
      localStorage.theme === 'dark' ||
        (!('theme' in localStorage) &&
          window.matchMedia('(prefers-color-scheme: dark)').matches),
    )
  }

  toggle() {
    if (document.documentElement.classList.contains('dark')) {
      localStorage.theme = 'light'
      document.documentElement.classList.remove('dark')
    } else {
      localStorage.theme = 'dark'
      document.documentElement.classList.add('dark')
    }
  }
}
