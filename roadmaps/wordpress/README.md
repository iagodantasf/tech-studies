---
title: WordPress
roadmap: wordpress
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, wordpress]
---

# WordPress

> roadmap.sh: https://roadmap.sh/wordpress

Track for the **WordPress** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Prerequisites
- [ ] HTML and CSS
- [ ] PHP fundamentals
- [ ] JavaScript basics
- [ ] MySQL / databases
- [ ] How the web works (HTTP, DNS)
- [ ] Web hosting basics

### Getting started
- [ ] What is WordPress
- [ ] WordPress.com vs WordPress.org
- [ ] Installing WordPress
- [ ] Local development (Local, XAMPP, wp-env)
- [ ] wp-config.php
- [ ] WordPress file structure
- [ ] The WordPress dashboard
- [ ] Updating WordPress

### Content management
- [ ] Posts and pages
- [ ] Categories and tags
- [ ] Media library
- [ ] Menus
- [ ] Widgets
- [ ] Comments
- [ ] Users and roles
- [ ] Permalinks
- [ ] Settings

### The block editor (Gutenberg)
- [ ] Block editor overview
- [ ] Core blocks
- [ ] Patterns and reusable blocks
- [ ] Full Site Editing (FSE)
- [ ] Block themes
- [ ] theme.json
- [ ] Template parts
- [ ] Global styles

### Themes
- [ ] What is a theme
- [ ] Theme anatomy and template hierarchy
- [ ] The Loop
- [ ] Template tags
- [ ] functions.php
- [ ] Enqueuing scripts and styles
- [ ] Child themes
- [ ] Custom page templates
- [ ] Conditional tags
- [ ] Classic vs block themes

### Plugins
- [ ] What is a plugin
- [ ] Installing and managing plugins
- [ ] Plugin development basics
- [ ] Plugin header and structure
- [ ] Activation and deactivation hooks
- [ ] Essential plugins (SEO, caching, security, forms)
- [ ] Page builders (Elementor, etc.)

### Core APIs and development
- [ ] Hooks: actions and filters
- [ ] Shortcodes API
- [ ] Custom post types
- [ ] Custom taxonomies
- [ ] Custom fields and metadata
- [ ] Advanced Custom Fields (ACF)
- [ ] WP_Query
- [ ] Options API
- [ ] Transients API
- [ ] Settings API
- [ ] Customizer API
- [ ] Widgets API
- [ ] Cron / WP-Cron
- [ ] Internationalization (i18n)

### REST API and headless
- [ ] WordPress REST API
- [ ] Custom REST endpoints
- [ ] Authentication (nonces, application passwords, JWT)
- [ ] Headless WordPress
- [ ] WPGraphQL

### Database
- [ ] WordPress database schema
- [ ] $wpdb and custom queries
- [ ] phpMyAdmin
- [ ] Database optimization and cleanup

### Performance
- [ ] Caching (page, object, opcode)
- [ ] CDN integration
- [ ] Image optimization
- [ ] Lazy loading
- [ ] Minification
- [ ] Hosting and server tuning

### Security
- [ ] Hardening WordPress
- [ ] User permissions and roles
- [ ] Sanitization and escaping
- [ ] Nonces and CSRF
- [ ] SSL/HTTPS
- [ ] Backups
- [ ] Security plugins and monitoring
- [ ] Keeping core/plugins/themes updated

### SEO and marketing
- [ ] On-page SEO basics
- [ ] SEO plugins (Yoast, Rank Math)
- [ ] Sitemaps
- [ ] Schema / structured data
- [ ] Analytics integration

### Tooling and deployment
- [ ] WP-CLI
- [ ] Composer with WordPress
- [ ] Staging environments
- [ ] Migrations and backups
- [ ] Version control with WordPress
- [ ] Managed WordPress hosting

### eCommerce
- [ ] WooCommerce basics
- [ ] Products and orders
- [ ] Payments and shipping
- [ ] Extending WooCommerce

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a custom block theme with theme.json, Full Site Editing templates, and a few custom Gutenberg blocks.
- Develop a plugin that registers a custom post type, custom taxonomy, and exposes them via custom REST API endpoints.
- Build a headless WordPress site using WPGraphQL as the backend and a Next.js frontend consuming the content.
