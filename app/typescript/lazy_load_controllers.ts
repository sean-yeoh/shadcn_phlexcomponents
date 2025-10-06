import StimulusControllerResolver, {
  createViteGlobResolver,
  // @ts-ignore
} from 'stimulus-controller-resolver'

import { Application } from '@hotwired/stimulus'

const isVite =
  typeof import.meta !== 'undefined' && typeof import.meta.env !== 'undefined'

const lazyLoadControllers = (application: Application, ext = 'ts') => {
  if (isVite) {
    const glob = import.meta.glob('./controllers/*')
    StimulusControllerResolver.install(
      application,
      createViteGlobResolver({
        glob,
        toIdentifier(key: string) {
          const fileName = key.split('/').at(-1)
          if (!fileName) return
          return fileName
            .replace(/\.[jt]s$/, '')
            .replace(/_controller$/, '')
            .replaceAll('_', '-')
        },
      }),
    )
  } else {
    StimulusControllerResolver.install(
      application,
      async (controllerName: string) =>
        (
          await import(
            `./controllers/${controllerName.replaceAll(
              '-',
              '_',
            )}_controller.${ext}`
          )
        ).default,
    )
  }
}

export { lazyLoadControllers }
