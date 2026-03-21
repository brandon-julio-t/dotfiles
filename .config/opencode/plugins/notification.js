const esc = (value) =>
  String(value)
    .replaceAll("\\", "\\\\")
    .replaceAll('"', '\\"')
    .replace(/\s+/g, " ")
    .trim();

const cut = (value, size = 140) =>
  value.length > size ? `${value.slice(0, size - 3)}...` : value;

const leaf = (value) => value.split(/[\\/]/).filter(Boolean).at(-1) ?? value;

const note = async ($, title, body, sound) => {
  const script = sound
    ? `display notification "${esc(body)}" with title "${esc(title)}" sound name "${esc(sound)}"`
    : `display notification "${esc(body)}" with title "${esc(title)}"`;

  await $`osascript -e ${script}`.quiet().nothrow();
};

const fail = (event) => {
  const err = event.properties?.error;
  if (!err) return "OpenCode hit an error.";
  if (err.data?.message) return err.data.message;
  if (err.message) return err.message;
  if (err.name) return err.name;
  return "OpenCode hit an error.";
};

const branch = async ($, dir) => {
  const out = await $`git branch --show-current`.cwd(dir).quiet().nothrow();
  return out.exitCode === 0 ? out.text().trim() : "";
};

const ctx = (project, worktree, branch) => {
  const name = project?.name ?? leaf(worktree);
  const place = branch ? `${name}@${branch}` : name;
  return {
    name,
    place,
    root: leaf(worktree),
  };
};

const perm = (event) => {
  const props = event.properties;
  const path =
    props.metadata?.filepath ??
    props.metadata?.parentDir ??
    props.patterns?.[0];
  const tool = props.metadata?.tool ?? props.patterns?.[0];

  if (props.permission === "external_directory") {
    return {
      title: "Folder access needed",
      body: `Allow access to ${path ?? "that folder"}?`,
    };
  }

  if (props.permission === "doom_loop") {
    return {
      title: "Loop guard blocked",
      body: `Allow OpenCode to retry ${tool ?? "that tool"}?`,
    };
  }

  if (props.permission === "bash") {
    return {
      title: "Shell access needed",
      body: `Allow OpenCode to run a shell command${tool ? ` for ${tool}` : ""}?`,
    };
  }

  if (["read", "write", "edit", "apply_patch"].includes(props.permission)) {
    const verb = props.permission === "read" ? "read" : "edit";
    return {
      title: `File ${verb} needed`,
      body: `Allow OpenCode to ${verb} ${path ?? "that file"}?`,
    };
  }

  if (["webfetch", "websearch", "codesearch"].includes(props.permission)) {
    return {
      title: "Web access needed",
      body: `Allow OpenCode to use ${props.permission}?`,
    };
  }

  if (props.permission === "question") {
    return {
      title: "Question permission needed",
      body: "Allow OpenCode to ask you a follow-up question?",
    };
  }

  return {
    title: "Permission needed",
    body: `Allow ${props.permission.replaceAll("_", " ")}${tool ? ` for ${tool}` : ""}?`,
  };
};

const text = (event, info) => {
  if (event.type === "session.idle") {
    return {
      sound: "Glass",
      title: `${info.place} - Response ready`,
      body: `OpenCode finished in ${info.root} and is waiting for your next message.`,
    };
  }

  if (event.type === "permission.asked") {
    const msg = perm(event);
    return {
      sound: "Ping",
      title: `${info.place} - ${msg.title}`,
      body: cut(`${msg.body} OpenCode is waiting for your answer.`),
    };
  }

  if (event.type === "question.asked") {
    const props = event.properties;
    const first =
      props.questions?.[0]?.question ?? "OpenCode has a question for you.";
    const extra =
      props.questions.length > 1
        ? ` (+${props.questions.length - 1} more)`
        : "";

    return {
      sound: "Pop",
      title: `${info.place} - Question waiting`,
      body: cut(`${first}${extra}`),
    };
  }

  if (event.type === "session.error") {
    return {
      sound: "Basso",
      title: `${info.place} - Error`,
      body: cut(fail(event)),
    };
  }
};

export const NotificationPlugin = async ({ project, worktree, $ }) => {
  const info = ctx(project, worktree, await branch($, worktree));

  return {
    event: async ({ event }) => {
      const msg = text(event, info);
      if (!msg) return;
      await note($, msg.title, msg.body, msg.sound);
    },
  };
};
