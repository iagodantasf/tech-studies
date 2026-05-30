---
title: Frontend Performance
roadmap: frontend-performance
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, frontend, performance]
---

# Frontend Performance

> roadmap.sh: https://roadmap.sh/best-practices/frontend-performance

Track for the **Frontend Performance** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Foundations
- [ ] Why frontend performance matters
- [ ] Performance affects UX and conversion
- [ ] The critical rendering path
- [ ] How the browser parses HTML, CSS and JS
- [ ] Render-blocking vs non-blocking resources
- [ ] Set a performance budget

### Core Web Vitals & Metrics
- [ ] Largest Contentful Paint (LCP)
- [ ] Interaction to Next Paint (INP)
- [ ] Cumulative Layout Shift (CLS)
- [ ] First Contentful Paint (FCP)
- [ ] Time to First Byte (TTFB)
- [ ] Total Blocking Time (TBT)
- [ ] Lab data vs field data (RUM)

### Measuring & Tooling
- [ ] Lighthouse audits
- [ ] Chrome DevTools Performance panel
- [ ] WebPageTest
- [ ] Real User Monitoring (RUM)
- [ ] Track and budget bundle size
- [ ] Continuous performance monitoring in CI

### Network
- [ ] Minimize the number of requests
- [ ] Use a CDN
- [ ] HTTP/2 and HTTP/3
- [ ] Enable compression (gzip / Brotli)
- [ ] Cache-Control and ETag headers
- [ ] Preload critical resources
- [ ] Prefetch and preconnect
- [ ] DNS prefetch
- [ ] Use resource hints wisely

### JavaScript
- [ ] Code splitting
- [ ] Tree shaking
- [ ] Lazy load non-critical JS
- [ ] Minify and compress bundles
- [ ] Defer and async script loading
- [ ] Reduce main-thread work
- [ ] Avoid long tasks
- [ ] Use Web Workers for heavy work
- [ ] Remove unused dependencies
- [ ] Debounce and throttle expensive handlers

### CSS
- [ ] Minify CSS
- [ ] Remove unused CSS
- [ ] Inline critical CSS
- [ ] Avoid @import chains
- [ ] Contain layout and paint (content-visibility)
- [ ] Avoid layout thrashing

### Images & Media
- [ ] Use modern formats (WebP / AVIF)
- [ ] Responsive images (srcset / sizes)
- [ ] Lazy load offscreen images
- [ ] Compress and resize images
- [ ] Set explicit width and height
- [ ] Use SVG for icons
- [ ] Optimize and lazy load video

### Fonts
- [ ] Use font-display: swap
- [ ] Preload key web fonts
- [ ] Subset fonts
- [ ] Self-host fonts
- [ ] Prefer variable fonts
- [ ] Limit font weights and families

### Rendering Strategies
- [ ] Client-side rendering (CSR)
- [ ] Server-side rendering (SSR)
- [ ] Static site generation (SSG)
- [ ] Incremental static regeneration
- [ ] Streaming and progressive hydration
- [ ] Avoid unnecessary re-renders
- [ ] Virtualize long lists

### Caching & Delivery
- [ ] Service workers and offline caching
- [ ] App shell architecture
- [ ] Cache-first vs network-first strategies
- [ ] Immutable asset hashing
- [ ] Edge caching and rendering

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Run Lighthouse and WebPageTest against a content-heavy site, then drive LCP/INP/CLS into the green by fixing images, fonts, and render-blocking resources.
- Add a route-based code-splitting + lazy-loading pass to a single-page app and chart the bundle-size and TBT reduction before/after.
- Build a tiny RUM script that reports Core Web Vitals to an endpoint, then compare your field data against lab scores.
