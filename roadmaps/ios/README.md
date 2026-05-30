---
title: iOS
roadmap: ios
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, ios, mobile]
---

# iOS

> roadmap.sh: https://roadmap.sh/ios

Track for the **iOS** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Language — Swift
- [ ] Swift basics
- [ ] Optionals
- [ ] Closures
- [ ] Generics
- [ ] Protocols
- [ ] Protocol-oriented programming
- [ ] Error handling
- [ ] Value vs reference types
- [ ] Property wrappers
- [ ] Result builders
- [ ] Concurrency (async/await)
- [ ] Actors

### Objective-C (legacy)
- [ ] Objective-C basics
- [ ] Interoperability with Swift

### Tooling
- [ ] Xcode
- [ ] Swift Package Manager
- [ ] CocoaPods
- [ ] Carthage
- [ ] Instruments & profiling
- [ ] Simulator
- [ ] Version control with Git

### Foundation & frameworks
- [ ] Foundation
- [ ] UIKit
- [ ] SwiftUI
- [ ] Combine
- [ ] Core Data
- [ ] Core Animation
- [ ] Core Graphics
- [ ] Core Location
- [ ] MapKit
- [ ] AVFoundation
- [ ] WebKit

### UI fundamentals
- [ ] View controllers
- [ ] View lifecycle
- [ ] Auto Layout
- [ ] Storyboards & XIBs
- [ ] Programmatic UI
- [ ] Navigation
- [ ] Table & collection views
- [ ] Gestures
- [ ] Animations
- [ ] Accessibility

### Architecture
- [ ] MVC
- [ ] MVVM
- [ ] MVP
- [ ] VIPER
- [ ] Clean architecture
- [ ] Coordinator pattern
- [ ] Dependency injection

### Data & persistence
- [ ] UserDefaults
- [ ] Keychain
- [ ] File system
- [ ] Core Data
- [ ] SQLite
- [ ] Codable / JSON

### Networking
- [ ] URLSession
- [ ] REST APIs
- [ ] Alamofire
- [ ] Authentication (OAuth)
- [ ] WebSockets
- [ ] Caching

### Concurrency
- [ ] Grand Central Dispatch
- [ ] OperationQueue
- [ ] async/await
- [ ] Structured concurrency
- [ ] Combine publishers

### App services
- [ ] Push notifications (APNs)
- [ ] Background tasks
- [ ] App lifecycle
- [ ] Deep linking & universal links
- [ ] In-app purchases (StoreKit)
- [ ] Sign in with Apple
- [ ] WidgetKit
- [ ] App Clips

### Testing
- [ ] Unit testing (XCTest)
- [ ] UI testing
- [ ] Snapshot testing
- [ ] TDD
- [ ] Debugging

### Distribution
- [ ] App Store Connect
- [ ] Provisioning & signing
- [ ] TestFlight
- [ ] App Store submission
- [ ] CI/CD (Fastlane / Xcode Cloud)

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a SwiftUI + Combine RSS reader that fetches via URLSession, decodes with Codable, and persists with Core Data.
- Create a UIKit photo gallery using collection views, AVFoundation capture, and Keychain-backed login.
- Ship a TestFlight beta of a tip-calculator widget using WidgetKit, StoreKit in-app purchases, and Fastlane automation.
