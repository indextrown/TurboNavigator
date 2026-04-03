import SwiftUI
import AppCore
import FeatureHomeInterface

public struct HomeView: View {
    let navigator: Navigator<AppDependencies, AppRoute>

    @State private var routesText = "Current routes will appear here."

    public init(navigator: Navigator<AppDependencies, AppRoute>) {
        self.navigator = navigator
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Interface-Based Modular Demo")
                    .font(.largeTitle.weight(.bold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("AppNavigation is built against feature interfaces, not concrete screens.")
                    .font(.body)
                    .foregroundStyle(.secondary)

                actionButton("Push Detail 42") {
                    navigator.push(.detail(id: "42"))
                }

                actionButton("Push Detail 42 -> 99") {
                    navigator.push([.detail(id: "42"), .detail(id: "99")])
                }

                actionButton("Present Settings") {
                    navigator.present(.settings)
                }

                actionButton("Replace With Home -> Detail 77") {
                    navigator.replace(with: [.home, .detail(id: "77")])
                }

                actionButton("Show Current Routes") {
                    let routes = navigator.currentRoutes()
                        .map { String(describing: $0) }
                        .joined(separator: " -> ")
                    routesText = routes.isEmpty ? "No routes" : routes
                }

                Text(routesText)
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(uiColor: .secondarySystemBackground))
                    )
            }
            .padding(20)
        }
        .background(Color(uiColor: .systemBackground))
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

public struct HomeScreenFactory: HomeScreenBuilding {
    public init() {}

    public func makeHomeScreen(
        route: AppRoute,
        navigator: Navigator<AppDependencies, AppRoute>
    ) -> RouteViewController {
        WrappingController(route: route, title: "Home") {
            HomeView(navigator: navigator)
        }
    }
}

#Preview {
    HomeView(navigator: .preview)
}
