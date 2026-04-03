import SwiftUI
import TurboNavigator

struct HomeView: View {
    let navigator: Navigator<AppDependencies, AppRoute>
    let sessionStore: SessionStore

    @State private var routesText = "Current routes will appear here."

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Authenticated Home")
                    .font(.largeTitle.weight(.bold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("로그인된 사용자는 앱 실행 직후 이 화면으로 진입합니다.")
                    .font(.body)
                    .foregroundStyle(.secondary)

                statusCard
                debugCard

                actionButton("Push Detail 42") {
                    navigator.push(.detail(id: "42"))
                }

                actionButton("Present Settings") {
                    navigator.present(.settings)
                }

                actionButton("Reset Root To Home -> Detail 77") {
                    navigator.replace(with: [.home, .detail(id: "77")])
                }

                actionButton("Show Current Routes") {
                    let routes = navigator.currentRoutes()
                        .map { String(describing: $0) }
                        .joined(separator: " -> ")
                    routesText = routes.isEmpty ? "No routes" : routes
                }

                actionButton("Sign Out") {
                    sessionStore.signOut()
                    navigator.replace(with: [.login])
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

    private var statusCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Session")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(sessionStore.isLoggedIn ? "Logged In" : "Logged Out")
                .font(.title3.weight(.semibold))

            Text("로그아웃 시에는 현재 stack 대신 `login`을 새 루트로 교체합니다.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
    }

    private var debugCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Debug")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text("domain: \(sessionStore.storageDomain)")
                .font(.system(.footnote, design: .monospaced))

            Text("stored value: \(sessionStore.persistedValueDescription)")
                .font(.system(.footnote, design: .monospaced))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
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
    HomeView(
        navigator: .preview,
        sessionStore: SessionStore()
    )
}
