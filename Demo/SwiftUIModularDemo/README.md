# SwiftUIModularDemo

Tuist-based modular version of `Demo/SwiftUIDemo`.

## Generate

```bash
tuist generate --path Demo/SwiftUIModularDemo
```

## Scaffold A New Module

```bash
tuist scaffold scofield-module --path Demo/SwiftUIModularDemo --name Profile
```

## How To Add A Module

### 1. Generate the feature module

```bash
tuist scaffold scofield-module --path Demo/SwiftUIModularDemo --name Profile
```

This creates:

- `Modules/FeatureProfile/Sources/ProfileView.swift`
- `Modules/FeatureProfile/README.md`

### 2. Add the target to `Project.swift`

Add a new target like this:

```swift
.target(
    name: "FeatureProfile",
    destinations: .iOS,
    product: .framework,
    bundleId: "\(bundlePrefix).feature.profile",
    deploymentTargets: deploymentTargets,
    infoPlist: .default,
    sources: ["Modules/FeatureProfile/Sources/**"],
    dependencies: [
        .target(name: "AppCore")
    ]
)
```

Then add `.target(name: "FeatureProfile")` to `AppNavigation` dependencies.

### 3. Add a route in `AppCore`

Update `Modules/AppCore/Sources/AppCore.swift`:

```swift
public enum AppRoute: Hashable {
    case home
    case detail(id: String)
    case settings
    case profile
}
```

### 4. Register the screen in `AppRouter`

Update `Modules/AppNavigation/Sources/AppRouter.swift`:

```swift
import FeatureProfile
```

```swift
.registering(.profile) { context in
    WrappingController(route: context.route, title: "Profile") {
        ProfileView(navigator: context.navigator)
    }
}
```

### 5. Call the route from another screen

Example:

```swift
navigator.push(.profile)
```

### 6. Regenerate the project

```bash
tuist generate --path Demo/SwiftUIModularDemo
```

## Example Flow

1. `tuist scaffold scofield-module --path Demo/SwiftUIModularDemo --name Profile`
2. Add `FeatureProfile` target to `Project.swift`
3. Add `case profile` to `AppRoute`
4. Register `ProfileView` in `AppRouter`
5. Run `tuist generate --path Demo/SwiftUIModularDemo`

## Modules

- `AppCore`: shared route types, dependencies, and `TurboNavigator` export
- `FeatureHome`: home screen
- `FeatureDetail`: detail screen
- `FeatureSettings`: settings screen
- `AppNavigation`: route registry and navigator assembly
- `App`: app entry point and assets

## Notes

- Behavior matches the original `SwiftUIDemo`.
- `TurboNavigator` is linked only once from `AppCore` to avoid static package duplication warnings.
- `scofield-module` generates `Modules/Feature{Name}` with a starter SwiftUI screen and an integration checklist.
