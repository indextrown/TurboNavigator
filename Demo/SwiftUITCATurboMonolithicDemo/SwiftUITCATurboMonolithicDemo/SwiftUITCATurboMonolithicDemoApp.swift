import ComposableArchitecture
import SwiftUI
import TurboNavigator

@main
struct SwiftUITCATurboMonolithicDemoApp: App {
    private let store: StoreOf<AppFeature>
    private let navigator: Navigator<AppDependencies, AppRoute>

    init() {
        let navigatorBox = NavigatorBox()
        let store = Store(
            initialState: AppFeature.State(),
            reducer: {
                AppFeature(navigatorClient: .live(box: navigatorBox))
            }
        )
        let navigator = AppRouter.buildNavigator(store: store)

        navigatorBox.navigator = navigator
        self.store = store
        self.navigator = navigator
    }

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
