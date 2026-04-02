import SwiftUI
import ComposableArchitecture

@main
struct SwiftUITCAMonolithicDemoApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(
                    initialState: AppFeature.State(),
                    reducer: { AppFeature() }
                )
            )
        }
    }
}
