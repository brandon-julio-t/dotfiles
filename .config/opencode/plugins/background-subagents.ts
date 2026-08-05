import type { Plugin } from "@opencode-ai/plugin"

export const BackgroundSubagentsPlugin: Plugin = async () => ({
  "tool.execute.before": async (input, output) => {
    if (input.tool === "task") output.args.background = true
  },
})
