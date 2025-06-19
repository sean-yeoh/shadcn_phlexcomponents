import { Controller } from '@hotwired/stimulus'
import SidebarController from './sidebar_controller'

export default class extends Controller<HTMLElement> {
  declare sidebarId: string | undefined

  connect() {
    this.sidebarId = this.element.dataset.sidebarId
  }

  toggle() {
    const sidebar = this.application.getControllerForElementAndIdentifier(
      document.querySelector(`#${this.sidebarId}`) as HTMLElement,
      'sidebar',
    ) as SidebarController

    if (sidebar) {
      sidebar.toggle()
    }
  }
}
