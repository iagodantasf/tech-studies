---
title: HTML
roadmap: html
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, html, frontend]
---

# HTML

> roadmap.sh: https://roadmap.sh/html

Track for the **HTML** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Introduction
- [ ] What is HTML?
- [ ] History and evolution of HTML
- [ ] How the browser renders HTML
- [ ] Anatomy of an HTML element
- [ ] Tags, attributes, and values

### Document structure
- [ ] `<!DOCTYPE html>`
- [ ] `<html>` root element
- [ ] `<head>` and metadata
- [ ] `<body>`
- [ ] `<title>`
- [ ] `<meta>` tags (charset, viewport, description)
- [ ] Linking CSS with `<link>`
- [ ] Adding JS with `<script>`
- [ ] Favicons

### Text content
- [ ] Headings (`h1`–`h6`)
- [ ] Paragraphs
- [ ] Line breaks and horizontal rules
- [ ] Lists (ordered, unordered, description)
- [ ] Blockquotes and citations
- [ ] Preformatted text and code
- [ ] Inline text semantics (strong, em, mark, small, abbr)
- [ ] Superscript and subscript

### Links and navigation
- [ ] Anchor element and `href`
- [ ] Absolute vs relative URLs
- [ ] Fragment / in-page links
- [ ] `target` and `rel` attributes
- [ ] Email and telephone links

### Images and media
- [ ] `<img>` and `alt` text
- [ ] Responsive images (`srcset`, `sizes`, `<picture>`)
- [ ] `<figure>` and `<figcaption>`
- [ ] Audio
- [ ] Video
- [ ] Embedding with `<iframe>`
- [ ] SVG in HTML

### Tables
- [ ] Table structure (`table`, `tr`, `td`, `th`)
- [ ] `thead`, `tbody`, `tfoot`
- [ ] Captions
- [ ] Spanning rows and columns
- [ ] Accessible tables (scope, headers)

### Forms
- [ ] `<form>` element and attributes
- [ ] Input types (text, email, password, number, date, etc.)
- [ ] Labels
- [ ] Textarea
- [ ] Select and option
- [ ] Checkboxes and radio buttons
- [ ] Buttons and submission
- [ ] Fieldset and legend
- [ ] Client-side validation
- [ ] `name`, `value`, `placeholder`, `required`
- [ ] Datalist and progress

### Semantic HTML
- [ ] Why semantics matter
- [ ] `<header>` and `<footer>`
- [ ] `<nav>`
- [ ] `<main>`
- [ ] `<article>` and `<section>`
- [ ] `<aside>`
- [ ] `<details>` and `<summary>`
- [ ] `<time>`, `<address>`, `<mark>`
- [ ] `<div>` and `<span>` (non-semantic)

### Accessibility (a11y)
- [ ] ARIA roles, states, and properties
- [ ] Accessible names and descriptions
- [ ] Keyboard navigation and focus order
- [ ] Skip links
- [ ] `tabindex`
- [ ] Screen reader testing
- [ ] WCAG basics

### SEO basics
- [ ] Meta description and title tags
- [ ] Heading hierarchy
- [ ] Open Graph and Twitter Card tags
- [ ] Structured data / schema.org
- [ ] robots and sitemap

### Best practices
- [ ] Writing valid HTML (W3C validator)
- [ ] Naming and formatting conventions
- [ ] Separation of concerns (structure vs style vs behavior)
- [ ] Progressive enhancement
- [ ] Character entities

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Hand-code a multi-section landing page using only semantic elements (no `div` soup) and validate it against the W3C validator with zero errors.
- Build an accessible multi-step contact/registration form with native HTML5 validation, proper labels, fieldsets, and ARIA where needed; test it with a screen reader.
- Create a responsive image gallery using `<picture>`, `srcset`, and `<figure>`/`<figcaption>`, served at correct resolutions for mobile and desktop.
