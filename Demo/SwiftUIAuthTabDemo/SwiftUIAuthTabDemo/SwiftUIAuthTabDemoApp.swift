import SwiftUI
import TurboNavigator

@main
struct SwiftUIAuthTabDemoApp: App {
    @StateObject private var sessionStore: SessionStore
    private let authNavigator: Navigator<AppDependencies, AuthRoute>
    private let mainNavigator: Navigator<AppDependencies, MainRoute>

    init() {
        let sessionStore = SessionStore()
        _sessionStore = StateObject(wrappedValue: sessionStore)
        authNavigator = AppRouter.buildAuthNavigator(sessionStore: sessionStore)
        mainNavigator = AppRouter.buildMainNavigator(sessionStore: sessionStore)
    }

    var body: some Scene {
        WindowGroup {
            RootView(
                sessionStore: sessionStore,
                authNavigator: authNavigator,
                mainNavigator: mainNavigator
            )
            .task {
                await sessionStore.restoreSession()
            }
        }
    }
}
