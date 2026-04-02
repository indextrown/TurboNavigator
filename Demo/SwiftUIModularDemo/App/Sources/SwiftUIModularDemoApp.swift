import SwiftUI
import AppCore
import AppNavigation

@main
struct SwiftUIModularDemoApp: App {
    private let navigator = AppRouter.buildNavigator()

    var body: some Scene {
        WindowGroup {
            NavigationContainer(
                navigator: navigator,
                initialRoutes: [.home],
                prefersLargeTitles: true
            )
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
}
