---
title: Android
roadmap: android
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, android, mobile]
---

# Android

> roadmap.sh: https://roadmap.sh/android

Track for the **Android** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Languages & fundamentals
- [ ] Basics of Kotlin
- [ ] Kotlin
- [ ] Java
- [ ] Basics of OOP
- [ ] Functional programming
- [ ] Coroutines
- [ ] Flow
- [ ] RxJava

### Tooling & environment
- [ ] Development IDE (Android Studio)
- [ ] Gradle build system
- [ ] Android SDK & SDK Manager
- [ ] Emulator & AVD Manager
- [ ] ADB (Android Debug Bridge)
- [ ] Version control with Git
- [ ] GitHub
- [ ] GitLab

### App components
- [ ] App components overview
- [ ] Activity
- [ ] Activity lifecycle
- [ ] Fragments
- [ ] Services
- [ ] Broadcast receivers
- [ ] Content providers
- [ ] Intents & intent filters
- [ ] App shortcuts
- [ ] App manifest
- [ ] Permissions

### UI with Views
- [ ] XML layouts
- [ ] ConstraintLayout
- [ ] RecyclerView
- [ ] ImageView
- [ ] ViewBinding
- [ ] DataBinding
- [ ] Material Design components

### UI with Jetpack Compose
- [ ] Composable functions
- [ ] Column & Row
- [ ] Box
- [ ] Button
- [ ] Card
- [ ] Image
- [ ] Icon
- [ ] Dialog
- [ ] BottomSheet
- [ ] State & recomposition
- [ ] Theming & Material 3

### Architecture
- [ ] Design & architecture principles
- [ ] MVC
- [ ] MVP
- [ ] MVVM
- [ ] MVI
- [ ] Repository pattern
- [ ] Observer pattern
- [ ] Factory pattern
- [ ] Builder pattern
- [ ] Clean architecture

### Jetpack & lifecycle
- [ ] ViewModel
- [ ] LiveData
- [ ] Lifecycle-aware components
- [ ] Navigation component
- [ ] WorkManager
- [ ] Paging

### Data & persistence
- [ ] SharedPreferences
- [ ] DataStore
- [ ] Room database
- [ ] File system
- [ ] SQLite

### Networking & async
- [ ] Networking (Retrofit / OkHttp)
- [ ] REST APIs
- [ ] JSON parsing (Moshi / Gson)
- [ ] Asynchronism
- [ ] Authentication
- [ ] Caching

### Dependency injection
- [ ] Dependency injection concepts
- [ ] Hilt
- [ ] Dagger
- [ ] Koin

### Firebase & services
- [ ] Firebase overview
- [ ] Firestore
- [ ] Cloud Messaging (FCM)
- [ ] Crashlytics
- [ ] Remote Config
- [ ] Google Play Services
- [ ] Google Maps
- [ ] Google AdMob

### Testing & quality
- [ ] Debugging
- [ ] JUnit
- [ ] Espresso
- [ ] Linting
- [ ] ktlint
- [ ] detekt
- [ ] LeakCanary

### Distribution
- [ ] Google Play Store
- [ ] App signing
- [ ] App Bundles
- [ ] CI/CD for Android

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build an offline-first notes app using Jetpack Compose, Room, and a Repository-pattern MVVM architecture.
- Create a weather app that pulls a REST API with Retrofit + Coroutines, caches with DataStore, and shows a Compose UI.
- Ship a small habit-tracker to the Play Store with WorkManager reminders, Firebase Crashlytics, and a signed App Bundle.
