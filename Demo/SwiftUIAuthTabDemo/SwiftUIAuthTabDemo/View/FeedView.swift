import SwiftUI
import TurboNavigator

struct FeedView: View {
    let navigator: Navigator<AppDependencies, MainRoute>
    let sessionStore: SessionStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Feed Tab")
                    .font(.largeTitle.weight(.bold))

                Text("로그인 완료 후에는 앱 루트가 `TabNavigationContainer`로 전환되고, 첫 번째 탭이 이 화면으로 시작합니다.")
                    .foregroundStyle(.secondary)

                Button("Push Detail 42") {
                    navigator.push(.detail(id: "42"))
                }
                .buttonStyle(.borderedProminent)

                Button("Open Settings Modal") {
                    navigator.present(.settings)
                }
                .buttonStyle(.bordered)

                Button("Switch To Profile Tab") {
                    navigator.switchTab(tag: 1)
                }
                .buttonStyle(.bordered)

                Button("Sign Out") {
                    sessionStore.signOut()
                }
                .buttonStyle(.bordered)

                infoCard
            }
            .padding(20)
        }
        .background(Color(uiColor: .systemBackground))
    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Current Pattern")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Text("로그아웃하면 `phase = .signedOut`이 되고, 루트가 다시 로그인용 NavigationContainer로 바뀝니다.")
        }
        .font(.footnote)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
    }
}
