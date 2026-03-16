const escapeAppleScriptString = (value) => value.replaceAll('\\', '\\\\').replaceAll('"', '\\"').replaceAll('\n', ' ')

const notify = async ($, title, message) => {
  const script = `display notification "${escapeAppleScriptString(message)}" with title "${escapeAppleScriptString(title)}"`
  await $`osascript -e ${script}`
}

export const NotificationPlugin = async ({ project, $ }) => {
  const title = project?.name ? `OpenCode - ${project.name}` : 'OpenCode'

  return {
    event: async ({ event }) => {
      if (event.type !== 'session.idle') return
      await notify($, title, 'Response ready')
    },
  }
}
