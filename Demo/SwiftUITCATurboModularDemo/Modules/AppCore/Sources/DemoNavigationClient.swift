@_exported import ComposableArchitecture

public struct DemoNavigationClient: Sendable {
    public var push: @MainActor @Sendable (AppRoute) -> Void
    public var pushMany: @MainActor @Sendable ([AppRoute]) -> Void
    public var present: @MainActor @Sendable (AppRoute) -> Void
    public var presentFullScreen: @MainActor @Sendable (AppRoute) -> Void
    public var replace: @MainActor @Sendable ([AppRoute]) -> Void
    public var back: @MainActor @Sendable () -> Void
    public var backTo: @MainActor @Sendable (AppRoute) -> Void
    public var backOrPush: @MainActor @Sendable (AppRoute) -> Void
    public var routesDescription: @MainActor @Sendable () -> String

    public init(
        push: @escaping @MainActor @Sendable (AppRoute) -> Void = { _ in },
        pushMany: @escaping @MainActor @Sendable ([AppRoute]) -> Void = { _ in },
        present: @escaping @MainActor @Sendable (AppRoute) -> Void = { _ in },
        presentFullScreen: @escaping @MainActor @Sendable (AppRoute) -> Void = { _ in },
        replace: @escaping @MainActor @Sendable ([AppRoute]) -> Void = { _ in },
        back: @escaping @MainActor @Sendable () -> Void = {},
        backTo: @escaping @MainActor @Sendable (AppRoute) -> Void = { _ in },
        backOrPush: @escaping @MainActor @Sendable (AppRoute) -> Void = { _ in },
        routesDescription: @escaping @MainActor @Sendable () -> String = { "No routes" }
    ) {
        self.push = push
        self.pushMany = pushMany
        self.present = present
        self.presentFullScreen = presentFullScreen
        self.replace = replace
        self.back = back
        self.backTo = backTo
        self.backOrPush = backOrPush
        self.routesDescription = routesDescription
    }

    public static let noop = Self()
}

private enum DemoNavigationClientKey: DependencyKey {
    static let liveValue = DemoNavigationClient.noop
    static let testValue = DemoNavigationClient.noop
}

public extension DependencyValues {
    var demoNavigation: DemoNavigationClient {
        get { self[DemoNavigationClientKey.self] }
        set { self[DemoNavigationClientKey.self] = newValue }
    }
}
