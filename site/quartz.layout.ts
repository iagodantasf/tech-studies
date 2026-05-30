import { PageLayout, SharedLayout } from "./quartz/cfg"
import * as Component from "./quartz/components"

// Roadmaps are filed under roadmaps/<category>/. Show those category folders in
// intent order (not alphabetical) with nice labels.
// IMPORTANT: Quartz serializes these functions with .toString() and rebuilds them
// in the browser via new Function(), so they MUST be self-contained — no references
// to outer-scope variables (that's why the maps are inlined inside each body).
const explorerOptions = {
  folderDefaultState: "collapsed" as const,
  mapFn: (node: any) => {
    const labels: Record<string, string> = {
      "role-based": "Role-based",
      "skill-based": "Skill-based",
      "best-practices": "Best Practices",
      beginner: "Beginner",
    }
    if (node.isFolder && labels[node.slugSegment]) {
      node.displayName = labels[node.slugSegment]
    }
  },
  sortFn: (a: any, b: any) => {
    const order = ["role-based", "skill-based", "best-practices", "beginner"]
    const ai = order.indexOf(a.slugSegment)
    const bi = order.indexOf(b.slugSegment)
    if (ai !== -1 || bi !== -1) {
      return (ai === -1 ? 99 : ai) - (bi === -1 ? 99 : bi)
    }
    if (a.isFolder === b.isFolder) {
      return a.displayName.localeCompare(b.displayName, undefined, {
        numeric: true,
        sensitivity: "base",
      })
    }
    return a.isFolder ? -1 : 1
  },
}

// components shared across all pages
export const sharedPageComponents: SharedLayout = {
  head: Component.Head(),
  header: [],
  afterBody: [],
  footer: Component.Footer({
    links: {
      GitHub: "https://github.com/jackyzha0/quartz",
      "Discord Community": "https://discord.gg/cRFFHYye7t",
    },
  }),
}

// components for pages that display a single page (e.g. a single note)
export const defaultContentPageLayout: PageLayout = {
  beforeBody: [
    Component.ConditionalRender({
      component: Component.Breadcrumbs(),
      condition: (page) => page.fileData.slug !== "index",
    }),
    Component.ArticleTitle(),
    Component.ContentMeta(),
    Component.TagList(),
  ],
  left: [
    Component.PageTitle(),
    Component.MobileOnly(Component.Spacer()),
    Component.Flex({
      components: [
        {
          Component: Component.Search(),
          grow: true,
        },
        { Component: Component.Darkmode() },
        { Component: Component.ReaderMode() },
      ],
    }),
    Component.Explorer(explorerOptions),
  ],
  right: [
    Component.Graph(),
    Component.DesktopOnly(Component.TableOfContents()),
    Component.Backlinks(),
  ],
}

// components for pages that display lists of pages  (e.g. tags or folders)
export const defaultListPageLayout: PageLayout = {
  beforeBody: [Component.Breadcrumbs(), Component.ArticleTitle(), Component.ContentMeta()],
  left: [
    Component.PageTitle(),
    Component.MobileOnly(Component.Spacer()),
    Component.Flex({
      components: [
        {
          Component: Component.Search(),
          grow: true,
        },
        { Component: Component.Darkmode() },
      ],
    }),
    Component.Explorer(explorerOptions),
  ],
  right: [],
}
