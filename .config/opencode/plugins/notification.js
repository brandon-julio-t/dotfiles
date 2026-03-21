const escapeAppleScriptString = (value) =>
  value.replaceAll("\\", "\\\\").replaceAll('"', '\\"').replaceAll("\n", " ");

const notify = async ($, title, message) => {
  await $`osascript -e display notification "${escapeAppleScriptString(message)}" with title "${escapeAppleScriptString(title)}" sound name "Blow"`;
};

export const NotificationPlugin = async ({ project, $ }) => {
  const title = project?.name ? `OpenCode - ${project.name}` : "OpenCode";

  return {
    event: async ({ event }) => {
      if (event.type !== "session.idle") return;
      await notify($, title, "Response ready");
    },
  };
};
