import SwiftUI
import AppCore
import FeatureSettingsInterface

public struct SettingView: View {
    let navigator: Navigator<AppDependencies, AppRoute>

    public init(navigator: Navigator<AppDependencies, AppRoute>) {
        self.navigator = navigator
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.largeTitle.weight(.bold))

            Text("Settings is injected into AppNavigation through its interface target.")
                .font(.body)
                .foregroundStyle(.secondary)

            actionButton("Push Detail 7") {
                navigator.push(.detail(id: "7"))
            }

            actionButton("Dismiss Or Back") {
                navigator.back()
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(uiColor: .systemGroupedBackground))
    }

    private func actionButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
    }
}

public struct SettingsScreenFactory: SettingsScreenBuilding {
    public init() {}

    public func makeSettingsScreen(
        route: AppRoute,
        navigator: Navigator<AppDependencies, AppRoute>
    ) -> RouteViewController {
        WrappingController(route: route, title: "Settings") {
            SettingView(navigator: navigator)
        }
    }
}

#Preview {
    SettingView(navigator: .preview)
}
