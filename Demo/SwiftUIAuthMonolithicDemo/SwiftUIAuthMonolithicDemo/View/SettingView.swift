import SwiftUI
import TurboNavigator

struct SettingView: View {
    let navigator: Navigator<AppDependencies, AppRoute>
    let sessionStore: SessionStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.largeTitle.weight(.bold))

            Text("Modal에서도 로그아웃 후 루트를 `login`으로 바꾸는 패턴을 볼 수 있습니다.")
                .font(.body)
                .foregroundStyle(.secondary)

            actionButton("Push Detail 7") {
                navigator.push(.detail(id: "7"))
            }

            actionButton("Sign Out And Reset To Login") {
                sessionStore.signOut()
                navigator.replace(with: [.login])
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

#Preview {
    SettingView(
        navigator: .preview,
        sessionStore: SessionStore()
    )
}
