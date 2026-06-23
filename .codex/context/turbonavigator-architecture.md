# TurboNavigator Architecture Context

## 1. Project One-Liner

TurboNavigator is a typed route-based navigation library that lets SwiftUI screens run on top of UIKit navigation controllers while exposing one imperative API for stack, tab, modal, and deep link flows.

## 2. Supported Shape

- Minimum deployment target: iOS 13
- UI authoring: SwiftUI first
- Navigation engine: UIKit
- Main package target: `Sources/TurboNavigator`
- Optional SwiftUI compatibility target: `Sources/TurboSwiftUI`
- Examples: `Demo/*`

## 3. Core Concepts

1. `Navigator`
   Owns dependencies, route registry, active root/modal/tab controllers, and public navigation operations.
2. `RouteRegistry`
   Maps typed routes to screen builders.
3. `RouteContext`
   Provides `route`, `navigator`, and `dependencies` to builders.
4. `WrappingController`
   Wraps SwiftUI screens in UIKit controllers while preserving route identity.
5. `NavigationContainer`
   Hosts a single UIKit navigation stack inside SwiftUI.
6. `TabNavigationContainer`
   Hosts a `UITabBarController` with one `UINavigationController` per tab.
7. `DeepLinkParser`
   Converts URLs into typed `DeepLink<Route>` values.

## 4. Navigation Policy

- Route values are the source of truth for app-level navigation intent.
- `Navigator.activeController` prioritizes modal stack, then selected tab stack, then root stack.
- Call sites should not need to know whether a push targets root, tab, or modal.
- Deep links should resolve to typed route actions before execution.
- UIKit controller access is intentional for cases SwiftUI `NavigationStack` does not control cleanly.
- SwiftUI view state and navigation transition policy should remain loosely coupled.

## 5. Implementation Boundaries

- Keep public API changes small and strongly typed.
- Preserve iOS 13 compatibility unless the issue explicitly changes support policy.
- Avoid tying core behavior to `NavigationStack`.
- Do not add app-specific route names to package code.
- Keep demo code illustrative; do not let demo-only assumptions leak into the library.
- When adding route operations, update registry/coordinator/debug behavior together.

## 6. Important Files

- `Sources/TurboNavigator/Core/3. Navigator.swift`
- `Sources/TurboNavigator/Core/7. SingleStackCoordinator.swift`
- `Sources/TurboNavigator/Core/8. ModalCoordinator.swift`
- `Sources/TurboNavigator/Core/9. TabCoordinator.swift`
- `Sources/TurboNavigator/Registry/6. RouteRegistry.swift`
- `Sources/TurboNavigator/Adapter/11. NavigationContainer.swift`
- `Sources/TurboNavigator/Adapter/12. TabNavigationContainer.swift`
- `Sources/TurboNavigator/DeepLink/16. Navigator+DeepLink.swift`
- `Tests/TurboNavigatorTests/TurboNavigatorTests.swift`
- `README.md`
- `README.en.md`

## 7. Repository Workflow

1. Reuse an existing matching GitHub Issue or create one first.
2. Work on an issue-based branch, preferably `codex/<type>-<issue-number>-<short-slug>`.
3. Commit with Conventional Commits style, using Korean summaries when the surrounding work is Korean.
4. Open a PR titled `[#<issue-number>] <issue-title>` when an issue is linked.
5. Stop after PR creation and wait for user approval.
6. Do not merge or perform follow-up remote writes unless the user explicitly asks.

## 8. Validation Defaults

- Documentation-only change: `git diff --check`
- Package behavior change: Swift Package test/build if available
- UIKit/SwiftUI bridge change: build at least one relevant demo target when practical
- Public README/API change: update both `README.md` and `README.en.md`
