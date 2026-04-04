import SwiftUI
import TurboNavigator

@main
struct SwiftUITabBarDemoApp: App {
    private let navigator = AppRouter.buildNavigator()

    var body: some Scene {
        WindowGroup {
            RootView(navigator: navigator)
                .ignoresSafeArea(.container, edges: .bottom)
        }
    }
}
