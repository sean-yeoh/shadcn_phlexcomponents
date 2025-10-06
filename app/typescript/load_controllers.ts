import * as controllers from './shadcn_phlexcomponents'
import { Application } from '@hotwired/stimulus'

const loadControllers = (application: Application) => {
  Object.keys(controllers).forEach((controllerName) => {
    const controller = controllers[controllerName as keyof typeof controllers]
    application.register(controller.name, controller)
  })
}

export { loadControllers }
