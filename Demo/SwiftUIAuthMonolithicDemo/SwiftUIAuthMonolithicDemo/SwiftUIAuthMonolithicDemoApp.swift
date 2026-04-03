import SwiftUI
import TurboNavigator

@main
struct SwiftUIAuthMonolithicDemoApp: App {
    @StateObject private var sessionStore: SessionStore
    private let navigator: Navigator<AppDependencies, AppRoute>

    init() {
        let sessionStore = SessionStore()
        _sessionStore = StateObject(wrappedValue: sessionStore)
        navigator = AppRouter.buildNavigator(sessionStore: sessionStore)
    }

    var body: some Scene {
        WindowGroup {
            NavigationContainer(
                navigator: navigator,
                initialRoutes: [.splash],
                prefersLargeTitles: true
            )
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
}
