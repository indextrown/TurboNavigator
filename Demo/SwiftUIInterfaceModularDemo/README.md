# SwiftUIInterfaceModularDemo

Tuist-based modular sample that separates feature interfaces from feature implementations.

## Generate

```bash
tuist generate --path Demo/SwiftUIInterfaceModularDemo
```

## Module Layout

- `AppCore`: shared routes, app dependencies, and `TurboNavigator` export
- `FeatureHomeInterface`: contract for building the Home screen
- `FeatureDetailInterface`: contract for building the Detail screen
- `FeatureSettingsInterface`: contract for building the Settings screen
- `FeatureHome`: Home screen implementation
- `FeatureDetail`: Detail screen implementation
- `FeatureSettings`: Settings screen implementation
- `AppNavigation`: route registry that depends only on interfaces
- `App`: composition root that injects concrete feature builders

## Why This Demo Exists

`SwiftUIModularDemo` keeps the sample intentionally small by letting `AppNavigation` import feature implementations directly.

This demo shows the next step:

- feature implementation targets depend on their own interface targets
- `AppNavigation` knows only interface protocols
- the app target wires concrete factories into the router
- feature factories return `RouteViewController` so SwiftUI type erasure is avoided at the interface boundary

## Dependency Direction

```text
App
 |- AppNavigation
 |- FeatureHome
 |- FeatureDetail
 |- FeatureSettings
 |
AppNavigation
 |- FeatureHomeInterface
 |- FeatureDetailInterface
 |- FeatureSettingsInterface
 |
FeatureHome -> FeatureHomeInterface
FeatureDetail -> FeatureDetailInterface
FeatureSettings -> FeatureSettingsInterface
 |
AppCore
```
