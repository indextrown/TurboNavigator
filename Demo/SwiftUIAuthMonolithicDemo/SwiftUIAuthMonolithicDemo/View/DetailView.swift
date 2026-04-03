import SwiftUI
import TurboNavigator

struct DetailView: View {
    let navigator: Navigator<AppDependencies, AppRoute>
    let userID: String
    let repository: UserRepository
    let sessionStore: SessionStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Detail Screen")
                .font(.largeTitle.weight(.bold))

            detailRow("userID", value: userID)
            detailRow("displayName", value: repository.displayName(for: userID))
            detailRow("session", value: sessionStore.isLoggedIn ? "logged in" : "logged out")

            actionButton("Push Next Detail") {
                navigator.push(.detail(id: userID + "-next"))
            }

            actionButton("Back To Home") {
                navigator.backTo(.home)
            }

            actionButton("Present Settings Full Screen") {
                navigator.presentFullScreen(.settings)
            }

            actionButton("Force Sign Out") {
                sessionStore.signOut()
                navigator.replace(with: [.login])
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

#Preview {
    DetailView(
        navigator: .preview,
        userID: "42",
        repository: DefaultUserRepository(),
        sessionStore: SessionStore()
    )
}
