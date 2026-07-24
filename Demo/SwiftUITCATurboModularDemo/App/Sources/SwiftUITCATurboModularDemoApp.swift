import AppNavigation
import SwiftUI

@main
struct SwiftUITCATurboModularDemoApp: App {
    private let rootView = AppRootView()

    var body: some Scene {
        WindowGroup {
            rootView
        }
    }
}
