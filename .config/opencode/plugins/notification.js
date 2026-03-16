const escapeAppleScriptString = (value) => value.replaceAll('\\', '\\\\').replaceAll('"', '\\"').replaceAll('\n', ' ')

const SOUND_FILE = '/System/Library/Sounds/Blow.aiff'

const notify = async ($, title, message) => {
  const script = `display notification "${escapeAppleScriptString(message)}" with title "${escapeAppleScriptString(title)}"`
  await $`osascript -e ${script}`
  await $`afplay ${SOUND_FILE}`
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
