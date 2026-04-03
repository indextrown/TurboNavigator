import SwiftUI
import AppCore
import FeatureDetailInterface

public struct DetailView: View {
    let navigator: Navigator<AppDependencies, AppRoute>
    let userID: String
    let repository: any UserRepository

    public init(
        navigator: Navigator<AppDependencies, AppRoute>,
        userID: String,
        repository: any UserRepository
    ) {
        self.navigator = navigator
        self.userID = userID
        self.repository = repository
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Detail Screen")
                .font(.largeTitle.weight(.bold))

            Text("This screen is provided through `DetailScreenBuilding`.")
                .font(.body)
                .foregroundStyle(.secondary)

            detailRow("userID", value: userID)
            detailRow("displayName", value: repository.displayName(for: userID))

            actionButton("Push Next Detail") {
                navigator.push(.detail(id: userID + "-next"))
            }

            actionButton("Back To Home") {
                navigator.backTo(.home)
            }

            actionButton("Present Settings Full Screen") {
                navigator.presentFullScreen(.settings)
            }

            actionButton("Back") {
                navigator.back()
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(uiColor: .systemBackground))
    }

    private func detailRow(_ title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body)
        }
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

public struct DetailScreenFactory: DetailScreenBuilding {
    public init() {}

    public func makeDetailScreen(
        route: AppRoute,
        navigator: Navigator<AppDependencies, AppRoute>,
        userID: String,
        repository: any UserRepository
    ) -> RouteViewController {
        WrappingController(route: route, title: "Detail \(userID)") {
            DetailView(
                navigator: navigator,
                userID: userID,
                repository: repository
            )
        }
    }
}

#Preview {
    DetailView(
        navigator: .preview,
        userID: "42",
        repository: DefaultUserRepository()
    )
}
